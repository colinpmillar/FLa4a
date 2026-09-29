# Confidence interval coverage with simulated data
#
# simScenario("simple") simulates data from a known population whose truth
# the model can represent exactly (separable F, catchability by age, free
# recruitment, constant observation variances). Fitting the correct model to
# many simulated data sets shows whether estimates are unbiased and whether
# 95% confidence intervals (derivedCI(), delta method) contain the truth 95%
# of the time.
#
# Run from the repository root:  source("src/examples/07-coverage.R")
# (about 0.4 seconds per simulation)

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
truthOf <- function(q) switch(q, ssb = c(d$truth$ssb), fbar = c(d$truth$fbar),
                              rec = c(d$truth$rec), harvest = c(d$truth$harvest))
results <- lapply(seq_len(nsim), function(i) {
  stk <- iter(d$stock, i)
  idx <- FLIndices(lapply(d$indices, iter, i))
  fit <- do.call(sca, c(list(stk, idx), d$models))
  ci <- derivedCI(fit, stk, idx)
  ci$truth <- unlist(lapply(unique(ci$quantity), truthOf))
  ci$sim <- i
  s <- fitSumm(fit)[, 1]
  sds <- exp(c(coef(fit)[c("vMod:catch:(Intercept)", "vMod:survey:(Intercept)"), 1]))
  list(ci = ci, n = s[["nobs"]], p = s[["nopar"]], converged = s[["convergence"]] == 0, sd = sds)
})
ci <- do.call(rbind, lapply(results, `[[`, "ci"))
cat("converged:", mean(sapply(results, `[[`, "converged")), "\n")

#---------------------------------------------------------------------
# Bias and coverage
#---------------------------------------------------------------------
ci$logerror <- log(ci$estimate / ci$truth)
ci$covered <- ci$truth >= ci$lower & ci$truth <= ci$upper

# the estimates are close to unbiased...
print(round(tapply(ci$logerror, ci$quantity, mean), 4))

# ...but the intervals cover the truth less often than 95%
coverage <- tapply(ci$covered, ci$quantity, mean)
print(round(coverage, 3))

# One reason: the observation standard deviations are estimated by maximum
# likelihood, which underestimates them when many parameters are fitted
# (here about 80 parameters for 330 observations). True values: catch 0.1,
# survey 0.2.
sdEst <- t(sapply(results, `[[`, "sd"))
print(round(colMeans(sdEst), 4))

# Inflating the standard errors by sqrt(n / (n - p)) recovers much of the
# shortfall; a REML-type estimate of the variances would address it directly.
n <- results[[1]]$n
p <- results[[1]]$p
z <- qnorm(0.975)
ci$coveredAdj <- abs(ci$logerror) <= z * ci$se * sqrt(n / (n - p))
print(round(rbind(nominal = coverage, df.adjusted = tapply(ci$coveredAdj, ci$quantity, mean)), 3))

#---------------------------------------------------------------------
# Plots
#---------------------------------------------------------------------
savePng("coverage-by-year", {
  par(mar = c(3, 4, 2, 1))
  byYear <- sapply(c("ssb", "fbar", "rec"), function(q) {
    x <- ci[ci$quantity == q, ]
    tapply(x$covered, x$year, mean)
  })
  matplot(years, byYear, type = "l", lty = 1, lwd = 2, col = fitCols(3), ylim = c(0.5, 1), las = 1,
          xlab = "", ylab = "coverage", main = paste("Coverage of 95% intervals,", nsim, "simulations"))
  abline(h = 0.95, lty = 2)
  # binomial 95% band around 0.95 for nsim simulations
  abline(h = 0.95 + c(-1, 1) * 1.96 * sqrt(0.95 * 0.05 / nsim), lty = 3, col = "grey50")
  legend("bottomleft", c("SSB", "Fbar", "recruitment", "nominal 0.95"), col = c(fitCols(3), "black"),
         lty = c(1, 1, 1, 2), lwd = c(2, 2, 2, 1), bty = "n", cex = 0.8)
})

savePng("relative-error", {
  par(mfrow = c(1, 3), mar = c(3, 4, 2, 1))
  for (q in c("ssb", "fbar", "rec")) {
    x <- ci[ci$quantity == q, ]
    boxplot(100 * (x$estimate / x$truth - 1) ~ x$year, outline = FALSE, las = 1, xlab = "",
            ylab = "% error", main = toupper(q), col = grDevices::adjustcolor(fitCols(1), 0.3),
            xaxt = "n")
    axis(1, at = seq_along(years)[years %% 5 == 0], labels = years[years %% 5 == 0])
    abline(h = 0, lty = 2)
  }
})

savePng("ssb-intervals", {
  par(mar = c(3, 5, 2, 1))
  x <- ci[ci$quantity == "ssb" & ci$sim <= 20, ]
  last <- x[x$year == max(years), ]
  plot(last$sim, last$estimate, ylim = range(last$lower, last$upper, last$truth), pch = 16, las = 1,
       xlab = "simulation", ylab = "SSB (t)", main = paste("SSB in", max(years), ": estimates and 95% intervals"))
  segments(last$sim, last$lower, last$sim, last$upper, col = ifelse(last$covered, "grey40", "red"))
  abline(h = last$truth[1], col = fitCols(1), lwd = 2)
  legend("topleft", c("truth", "interval misses the truth"), col = c(fitCols(1), "red"), lwd = 2,
         bty = "n", cex = 0.8)
})
