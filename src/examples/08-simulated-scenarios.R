# Simulated scenarios: can the model recover the truth?
#
# simScenario() provides simulated data sets that each test one aspect of
# the model, with the submodels to fit them:
#   "simple"     separable F, one survey (the correct model is known)
#   "smooth"     selectivity shifting over time (non-separable F), two surveys
#   "covariate"  survey catchability depends on temp, F on effort
#   "sr"         Beverton-Holt recruitment and a strong contrast in SSB
#   "biomass"    an age-structured and a biomass survey
# Each scenario is fitted once and compared with the truth.
#
# Run from the repository root:  source("src/examples/08-simulated-scenarios.R")
# (takes about a minute)

library(FLa4a)
source("src/examples/helpers.R")
outDir <- exampleDir("08-simulated-scenarios")  # plots are saved here

scenarios <- c("simple", "smooth", "covariate", "sr", "biomass")
sims <- lapply(scenarios, simScenario, nsim = 1, seed = 1)
names(sims) <- scenarios

fitScenario <- function(d, ...) {
  do.call(sca, c(list(d$stock, d$indices), d$models, list(covar = d$covar, ...)))
}
fits <- lapply(sims, fitScenario)

# the smooth scenario also with penalised smoothers
penalisedSmooth <- sims$smooth
penalisedSmooth$models$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") +
  ti(age, year, k = c(5, 15), bs = "ps")
fits$`smooth (penalised)` <- fitScenario(penalisedSmooth, penalise = "fmodel")
sims$`smooth (penalised)` <- sims$smooth

#---------------------------------------------------------------------
# Truth and estimates
#---------------------------------------------------------------------
# covariate effects: true values 0.3 (effort on log F) and 0.4 (temp on log q)
p <- c(coef(fits$covariate)[, 1])
names(p) <- dimnames(coef(fits$covariate))$params
se <- sqrt(diag(vcov(fits$covariate)[, , 1]))
effects <- grep("effort|temp", names(p))
print(round(cbind(true = c(0.3, 0.4), estimate = p[effects], se = se[effects]), 3))

# error in SSB and Fbar in the last year
lastYear <- function(x) c(x[, dim(x)[2]])
err <- t(sapply(names(fits), function(n) {
  est <- sims[[n]]$stock + fits[[n]]
  c(ssb = lastYear(ssb(est)) / lastYear(sims[[n]]$truth$ssb) - 1,
    fbar = lastYear(fbar(est)) / lastYear(sims[[n]]$truth$fbar) - 1)
}))
print(round(100 * err, 1))   # % error in the final year

#---------------------------------------------------------------------
# Plots: truth (black) and estimates with 95% intervals
#---------------------------------------------------------------------
for (n in names(fits)) {
  d <- sims[[n]]
  ci <- derivedCI(fits[[n]], d$stock, d$indices, quantities = c("ssb", "fbar", "rec"))
  truth <- list(ssb = c(d$truth$ssb), fbar = c(d$truth$fbar), rec = c(d$truth$rec))
  savePng(gsub("[^a-z]+", "-", sub("[^a-z]+$", "", tolower(n))), width = 1100, height = 380, {
    par(mfrow = c(1, 3), mar = c(3, 4, 2, 1), oma = c(0, 0, 2, 0))
    scale <- c(ssb = 1e3, fbar = 1, rec = 1e6)
    titles <- c(ssb = "SSB (thousand t)", fbar = "Fbar", rec = "recruits (millions)")
    for (q in c("ssb", "fbar", "rec")) {
      x <- ci[ci$quantity == q, ]
      x[c("estimate", "lower", "upper")] <- x[c("estimate", "lower", "upper")] / scale[[q]]
      tr <- truth[[q]] / scale[[q]]
      plot(x$year, x$estimate, type = "n", ylim = range(0, x$upper, tr), las = 1,
           xlab = "", ylab = "", main = titles[[q]])
      polygon(c(x$year, rev(x$year)), c(x$lower, rev(x$upper)),
              col = grDevices::adjustcolor(fitCols(1), 0.3), border = NA)
      lines(x$year, x$estimate, col = fitCols(1), lwd = 2)
      lines(x$year, tr, lwd = 2)
    }
    mtext(paste("scenario:", n, " (black: truth; colour: estimate and 95% interval)"), outer = TRUE, font = 2)
  })
}
