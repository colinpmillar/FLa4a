# ML versus REML: bias of the observation variances and interval coverage
#
# Maximum likelihood (ML) estimates the observation standard deviations as
# if the other coefficients were known, so it underestimates them and the
# confidence intervals are too narrow. REML (sca(..., method = "REML"))
# integrates the other coefficients out. This script compares the two on
# simulated data with known truth, for unpenalised and penalised models:
#
#   1. unpenalised: the "simple" scenario fitted with the correct model
#   2. penalised 1D: the same data with a penalised P-spline for F by year
#   3. penalised 2D: the "smooth" scenario (non-separable F) fitted with
#      penalised s(age) + s(year) + ti(age, year)
#
# Each simulated data set is fitted by ML and by REML, and 95% intervals
# from derivedCI() are checked against the truth. With penalised smoothers,
# REML also estimates the smoothing parameters. The estimates are equally
# accurate under both methods; REML widens the intervals to restore
# coverage. Results are saved to
# src/examples/09-reml-coverage/results.rds; later runs only redo the
# summaries and plots (delete the file, or set `rerun <- TRUE`, to refit).
#
# Run from the repository root:  source("src/examples/09-reml-coverage.R")
# (about 15 minutes on 4 cores with the default number of simulations)

library(FLa4a)
source("src/examples/helpers.R")
outDir <- exampleDir("09-reml-coverage")  # plots and results are saved here

rerun <- !file.exists(file.path(outDir, "results.rds"))
cores <- if (.Platform$OS.type == "windows") 1 else min(4, parallel::detectCores())

studies <- list(
  unpenalised = list(
    label = "Unpenalised (correct model)", scenario = "simple", nsim = 200, seed = 1,
    models = function(d) d$models, penalise = character(0)),
  penalised1D = list(
    label = "Penalised 1D: F ~ s(age) + s(year)", scenario = "simple", nsim = 200, seed = 2,
    models = function(d) {
      m <- d$models
      m$fmodel <- ~ s(age, k = 5) + s(year, k = 20, bs = "ps")
      m
    },
    penalise = "fmodel"),
  penalised2D = list(
    label = "Penalised 2D: F ~ s(age) + s(year) + ti(age, year)", scenario = "smooth", nsim = 50, seed = 3,
    models = function(d) {
      m <- d$models
      m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") +
        ti(age, year, k = c(5, 15), bs = "ps")
      m
    },
    penalise = "fmodel")
)
# true observation standard deviations of the scenarios, by fleet
trueSd <- list(simple = c(catch = 0.1, survey = 0.2),
               smooth = c(catch = 0.15, summer = 0.25, winter = 0.3))

#---------------------------------------------------------------------
# Fit every simulated data set by ML and REML
#---------------------------------------------------------------------
fitOne <- function(i, study, d) {
  stk <- iter(d$stock, i)
  idx <- FLIndices(lapply(d$indices, iter, i))
  models <- study$models(d)
  truth <- list(ssb = c(d$truth$ssb), fbar = c(d$truth$fbar), rec = c(d$truth$rec),
                harvest = c(d$truth$harvest))
  lapply(c("ML", "REML"), function(method) {
    t0 <- Sys.time()
    fit <- tryCatch(do.call(sca, c(list(stk, idx), models,
                                   list(penalise = study$penalise, method = method))),
                    error = function(e) NULL)
    secs <- as.numeric(Sys.time() - t0, units = "secs")
    if (is.null(fit) || fitSumm(fit)["convergence", 1] != 0) {
      return(list(ci = NULL, sd = NULL, secs = secs, converged = FALSE))
    }
    ci <- derivedCI(fit, stk, idx)
    ci$truth <- unlist(truth[unique(ci$quantity)])
    ci$method <- method
    ci$sim <- i
    v <- grep("^vMod:.*:\\(Intercept\\)$", dimnames(coef(fit))$params, value = TRUE)
    sds <- exp(c(coef(fit)[v, 1]))
    names(sds) <- sub("^vMod:(.*):\\(Intercept\\)$", "\\1", v)
    list(ci = ci, sd = data.frame(method = method, sim = i, fleet = names(sds), sd = sds),
         secs = secs, converged = TRUE)
  })
}

resultsFile <- file.path(outDir, "results.rds")
if (rerun || !file.exists(resultsFile)) {
  results <- lapply(studies, function(study) {
    message("Study: ", study$label)
    d <- simScenario(study$scenario, nsim = study$nsim, seed = study$seed)
    runs <- parallel::mclapply(seq_len(study$nsim), fitOne, study = study, d = d, mc.cores = cores)
    runs <- unlist(runs, recursive = FALSE)
    list(ci = do.call(rbind, lapply(runs, `[[`, "ci")),
         sd = do.call(rbind, lapply(runs, `[[`, "sd")),
         secs = tapply(sapply(runs, `[[`, "secs"), rep(c("ML", "REML"), study$nsim), mean),
         converged = tapply(sapply(runs, `[[`, "converged"), rep(c("ML", "REML"), study$nsim), mean),
         nsim = study$nsim, label = study$label, scenario = study$scenario)
  })
  saveRDS(results, resultsFile)
}
results <- readRDS(resultsFile)

#---------------------------------------------------------------------
# Summaries
#---------------------------------------------------------------------
quantities <- c("ssb", "fbar", "rec", "harvest")
summaries <- lapply(names(results), function(s) {
  r <- results[[s]]
  ci <- r$ci
  ci$covered <- ci$truth >= ci$lower & ci$truth <= ci$upper
  ci$width <- log(ci$upper / ci$lower)
  ci$logerror <- log(ci$estimate / ci$truth)
  cov <- tapply(ci$covered, list(ci$quantity, ci$method), mean)[quantities, ]
  bias <- tapply(ci$logerror, list(ci$quantity, ci$method), mean)[quantities, ]
  rmse <- sqrt(tapply(ci$logerror^2, list(ci$quantity, ci$method), mean))[quantities, ]
  # interval width ratio REML / ML, paired by simulation and cell (median)
  key <- paste(ci$quantity, ci$year, ci$age, ci$sim)
  ml <- ci[ci$method == "ML", ]
  re <- ci[ci$method == "REML", ]
  both <- intersect(key[ci$method == "ML"], key[ci$method == "REML"])
  ml <- ml[match(both, key[ci$method == "ML"]), ]
  re <- re[match(both, key[ci$method == "REML"]), ]
  widthRatio <- tapply(re$width / ml$width, ml$quantity, stats::median)[quantities]
  sd <- r$sd
  sd$true <- trueSd[[r$scenario]][sd$fleet]
  sdBias <- tapply(sd$sd / sd$true - 1, list(sd$fleet, sd$method), mean)
  list(study = s, label = r$label, nsim = r$nsim, coverage = cov, widthRatio = widthRatio,
       bias = bias, rmse = rmse, sdBias = sdBias, secs = r$secs, converged = r$converged)
})
names(summaries) <- names(results)

for (s in summaries) {
  cat("\n==", s$label, "(", s$nsim, "simulations )\n")
  cat("coverage of 95% intervals:\n"); print(round(s$coverage, 3))
  cat("interval width, REML / ML (median over paired intervals):\n"); print(round(s$widthRatio, 3))
  cat("mean log error (bias):\n"); print(round(s$bias, 4))
  cat("root mean square log error:\n"); print(round(s$rmse, 4))
  cat("relative bias of observation sd estimates:\n"); print(round(s$sdBias, 3))
  cat("seconds per fit:\n"); print(round(s$secs, 1))
  cat("converged:\n"); print(s$converged)
}
saveRDS(summaries, file.path(outDir, "summaries.rds"))

#---------------------------------------------------------------------
# Plots
#---------------------------------------------------------------------
methodCols <- c(ML = "#B2182B", REML = "#2166AC")

savePng("coverage", width = 1100, height = 420, {
  par(mfrow = c(1, length(summaries)), mar = c(4, 4, 3, 1))
  for (s in summaries) {
    b <- barplot(t(s$coverage), beside = TRUE, ylim = c(0.5, 1), xpd = FALSE, las = 1,
                 col = methodCols, border = NA, names.arg = c("SSB", "Fbar", "R", "F at age"),
                 main = s$label, cex.main = 0.85, ylab = "coverage of 95% intervals")
    abline(h = 0.95, lty = 2)
    # binomial range around 0.95 for this number of simulations
    abline(h = 0.95 + c(-1, 1) * 1.96 * sqrt(0.95 * 0.05 / s$nsim), lty = 3, col = "grey50")
    box()
  }
  legend("bottomright", names(methodCols), fill = methodCols, border = NA, bty = "n")
})

savePng("sd-estimates", width = 1100, height = 420, {
  par(mfrow = c(1, length(results)), mar = c(4, 4, 3, 1))
  for (s in names(results)) {
    sd <- results[[s]]$sd
    sd$rel <- sd$sd / trueSd[[results[[s]]$scenario]][sd$fleet]
    boxplot(rel ~ method + fleet, data = sd, col = methodCols, las = 2, outline = FALSE,
            ylab = "estimated / true observation sd", xlab = "", main = results[[s]]$label,
            cex.main = 0.85, cex.axis = 0.8)
    abline(h = 1, lty = 2)
  }
})
