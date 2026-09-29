# Confidence interval coverage with simulated data
#
# simScenario("simple") simulates data from a known population whose truth
# the model can represent exactly (separable F, catchability by age, free
# recruitment, constant observation variances). Fitting the correct model to
# many simulated data sets shows whether estimates are unbiased and whether
# 95% confidence intervals (derivedCI(), delta method) contain the truth 95%
# of the time. Each data set is fitted twice: by maximum likelihood (ML, the
# default) and with the observation variances estimated by REML
# (sca(..., method = "REML")).
#
# Run from the repository root:  source("src/examples/07-coverage.R")
# (about 1.5 seconds per simulation for the two fits)

library(FLa4a)
source("src/examples/helpers.R")
outDir <- exampleDir("07-coverage")  # plots are saved here

nsim <- 100
d <- simScenario("simple", nsim = nsim, seed = 1)
print(d$models)                      # the correct submodels
years <- as.numeric(dimnames(d$stock)$year)

#---------------------------------------------------------------------
# Fit each simulated data set and compute 95% intervals
#---------------------------------------------------------------------
# true values of every quantity derivedCI() reports; n1 is the numbers at age
# in the first year, ages after the first (the n1model)
truth <- list(ssb = c(d$truth$ssb), fbar = c(d$truth$fbar), rec = c(d$truth$rec),
              harvest = c(d$truth$harvest), n1 = c(d$truth$stock.n[-1, 1]))
truthOf <- function(q) {
  if (is.null(truth[[q]])) stop("no true values for derivedCI quantity '", q, "'")
  truth[[q]]
}
methods <- c("ML", "REML")
methodCols <- c(ML = "#B2182B", REML = "#2166AC")
fitOne <- function(i, method) {
  stk <- iter(d$stock, i)
  idx <- FLIndices(lapply(d$indices, iter, i))
  fit <- do.call(sca, c(list(stk, idx), d$models, list(method = method)))
  ci <- derivedCI(fit, stk, idx)
  ci$truth <- unlist(lapply(unique(ci$quantity), truthOf))
  ci$sim <- i
  ci$method <- method
  s <- fitSumm(fit)[, 1]
  sds <- exp(c(coef(fit)[c("vMod:catch:(Intercept)", "vMod:survey:(Intercept)"), 1]))
  list(ci = ci, n = s[["nobs"]], p = s[["nopar"]], converged = s[["convergence"]] == 0, sd = sds)
}
results <- lapply(methods, function(method) lapply(seq_len(nsim), fitOne, method = method))
names(results) <- methods
ci <- do.call(rbind, lapply(results, function(r) do.call(rbind, lapply(r, `[[`, "ci"))))
rownames(ci) <- NULL
print(sapply(results, function(r) c(converged = mean(sapply(r, `[[`, "converged")))))

#---------------------------------------------------------------------
# Bias and coverage
#---------------------------------------------------------------------
ci$logerror <- log(ci$estimate / ci$truth)
ci$covered <- ci$truth >= ci$lower & ci$truth <= ci$upper

# the estimates are close to unbiased, and the same under both methods...
print(round(tapply(ci$logerror, list(ci$quantity, ci$method), mean), 4))

# ...but with ML the intervals cover the truth less often than 95%
coverage <- tapply(ci$covered, list(ci$quantity, ci$method), mean)
print(round(coverage, 3))

# The reason: ML estimates the observation standard deviations as if the
# other coefficients were known, and so underestimates them when many are
# fitted (here about 80 parameters for 330 observations). REML integrates
# the other coefficients out. True values: catch 0.1, survey 0.2.
sdEst <- t(sapply(results, function(r) colMeans(t(sapply(r, `[[`, "sd")))))
colnames(sdEst) <- c("catch", "survey")
print(round(sdEst, 4))

# For ML, inflating the standard errors by sqrt(n / (n - p)) recovers much of
# the shortfall; REML addresses it directly.
n <- results$ML[[1]]$n
p <- results$ML[[1]]$p
z <- qnorm(0.975)
ml <- ci$method == "ML"
coveredAdj <- abs(ci$logerror[ml]) <= z * ci$se[ml] * sqrt(n / (n - p))
print(round(rbind(ML = coverage[, "ML"], ML.df.adjusted = tapply(coveredAdj, ci$quantity[ml], mean),
                  REML = coverage[, "REML"]), 3))

#---------------------------------------------------------------------
# Plots
#---------------------------------------------------------------------
savePng("coverage-by-year", width = 1300, height = 550, {
  par(mfrow = c(1, 2), mar = c(3, 4, 2, 1))
  for (m in methods) {
    byYear <- sapply(c("ssb", "fbar", "rec"), function(q) {
      x <- ci[ci$quantity == q & ci$method == m, ]
      tapply(x$covered, x$year, mean)
    })
    matplot(years, byYear, type = "l", lty = 1, lwd = 2, col = fitCols(3), ylim = c(0.5, 1), las = 1,
            xlab = "", ylab = "coverage",
            main = paste0("Coverage of 95% intervals, ", m, " (", nsim, " simulations)"))
    abline(h = 0.95, lty = 2)
    # binomial 95% band around 0.95 for nsim simulations
    abline(h = 0.95 + c(-1, 1) * 1.96 * sqrt(0.95 * 0.05 / nsim), lty = 3, col = "grey50")
    legend("bottomleft", c("SSB", "Fbar", "recruitment", "nominal 0.95"), col = c(fitCols(3), "black"),
           lty = c(1, 1, 1, 2), lwd = c(2, 2, 2, 1), bty = "n", cex = 0.8)
  }
})

savePng("coverage-by-quantity", width = 900, height = 500, {
  par(mar = c(3, 4, 2, 1))
  b <- barplot(t(coverage[c("ssb", "fbar", "rec", "harvest", "n1"), methods]), beside = TRUE,
               ylim = c(0.5, 1.04), xpd = FALSE, las = 1, col = methodCols, border = NA,
               names.arg = c("SSB", "Fbar", "recruitment", "F at age", "N first year"),
               ylab = "coverage", main = paste("Coverage of 95% intervals,", nsim, "simulations"))
  abline(h = 0.95, lty = 2)
  abline(h = 0.95 + c(-1, 1) * 1.96 * sqrt(0.95 * 0.05 / nsim), lty = 3, col = "grey50")
  box()
  legend("topright", methods, fill = methodCols, border = NA, bty = "n", horiz = TRUE, cex = 0.9)
})

# relative errors of the ML estimates (REML's are practically the same)
savePng("relative-error", {
  par(mfrow = c(1, 3), mar = c(3, 4, 2, 1))
  for (q in c("ssb", "fbar", "rec")) {
    x <- ci[ci$quantity == q & ci$method == "ML", ]
    boxplot(100 * (x$estimate / x$truth - 1) ~ x$year, outline = FALSE, las = 1, xlab = "",
            ylab = "% error", main = toupper(q), col = grDevices::adjustcolor(fitCols(1), 0.3),
            xaxt = "n")
    axis(1, at = seq_along(years)[years %% 5 == 0], labels = years[years %% 5 == 0])
    abline(h = 0, lty = 2)
  }
})

savePng("ssb-intervals", width = 1300, height = 550, {
  par(mfrow = c(1, 2), mar = c(3, 5, 2, 1))
  x <- ci[ci$quantity == "ssb" & ci$sim <= 20 & ci$year == max(years), ]
  for (m in methods) {
    last <- x[x$method == m, ]
    plot(last$sim, last$estimate, ylim = range(x$lower, x$upper, x$truth), pch = 16, las = 1,
         xlab = "simulation", ylab = "SSB (t)",
         main = paste0("SSB in ", max(years), ", ", m, ": estimates and 95% intervals"))
    segments(last$sim, last$lower, last$sim, last$upper, col = ifelse(last$covered, "grey40", "red"))
    abline(h = last$truth[1], col = fitCols(1), lwd = 2)
    legend("topleft", c("truth", "interval misses the truth"), col = c(fitCols(1), "red"), lwd = 2,
           bty = "n", cex = 0.8)
  }
})
