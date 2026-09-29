# Simulating from a fit with covariates
#
# 1. fit a model with covariates in the F and catchability submodels
# 2. simulate new catches and survey indices from it (a predictive check)
# 3. simulate under new covariate values (a scenario)
# 4. simulate with a known effect size and refit, to see if it is recoverable
#
# predict() gives the expected values under new covariates; simulate() adds
# lognormal observation error with the fitted variance model. Submodels keep
# their fitted bases, so smoothers of covariates are evaluated at the new
# values with the same knots and coefficients.
#
# Run from the repository root:  source("src/examples/05-simulate-covariates.R")
# (takes about 1-2 minutes, mostly the refits in part 4)

library(FLa4a)
source("src/examples/helpers.R")
outDir <- exampleDir("05-simulate-covariates")  # plots are saved here

data(ple4)
data(ple4.indices)
indices <- ple4.indices[c("BTS-Combined (all)", "SNS")]
years <- dimnames(ple4)$year

#---------------------------------------------------------------------
# Covariates (as in 03-covariates.R)
#---------------------------------------------------------------------
# temp: a SIMULATED year-only temperature anomaly, for illustration
set.seed(1)
temp <- FLQuant(c(stats::arima.sim(list(ar = 0.7), n = length(years), sd = 0.4)),
                dimnames = list(year = years))
# wtAnomaly: anomaly of log stock weight at age (age x year, from the data)
lw <- log(stock.wt(ple4))
wtAnomaly <- lw %-% yearMeans(lw)
covar <- list(temp = temp, wtAnomaly = wtAnomaly)

#---------------------------------------------------------------------
# 1. Fit
#---------------------------------------------------------------------
fmod <- ~ te(age, year, k = c(5, 20)) + temp
qmod <- list(~ s(age, k = 5) + wtAnomaly, ~ s(age, k = 4))
fit <- sca(ple4, indices, fmodel = fmod, qmodel = qmod, covar = covar)
print(fit)

p <- c(coef(fit)[, 1])
names(p) <- dimnames(coef(fit))$params
se <- sqrt(diag(vcov(fit)[, , 1]))
effects <- grep("temp|wtAnomaly", names(p))
print(round(cbind(estimate = p[effects], se = se[effects]), 3))

#---------------------------------------------------------------------
# 2. Simulate from the fitted model
#---------------------------------------------------------------------
# Each simulation is a new data set with the same observation pattern as
# the real data. stock and indices supply the biology and survey timing.
sims <- simulate(fit, nsim = 100, seed = 1, stock = ple4, indices = indices)
print(dims(sims$stock)$iter)              # FLStock: catch.n simulated, stock.n/harvest true
print(dims(index(sims$indices[[1]]))$iter) # FLIndices of simulated indices

bts <- names(indices)[1]
savePng("predictive-check", {
  par(mfrow = c(2, 2), mar = c(3, 5, 2, 1))
  for (a in c(2, 6)) {
    plotEnvelope(list(simulated = catch.n(sims$stock)), age = a, obs = catch.n(ple4),
                 main = paste("catch at age", a), ylab = "thousands")
    plotEnvelope(list(simulated = index(sims$indices[[bts]])), age = a, obs = index(indices[[bts]]),
                 main = paste(bts, "age", a), ylab = "index")
  }
})

# add parameter uncertainty as well as observation error
simsP <- simulate(fit, nsim = 100, seed = 1, stock = ple4, indices = indices, sample.pars = TRUE)

#---------------------------------------------------------------------
# 3. A covariate scenario
#---------------------------------------------------------------------
# Scenario: fish are 10% lighter at age than observed, and it is 1 degree
# warmer. Catchability of the beam trawl survey depends on wtAnomaly, and F
# on temp; everything else keeps its fitted values.
scenario <- list(wtAnomaly = wtAnomaly + log(0.9), temp = temp + 1)

# expected values: the effect on F is exp(beta_temp) at every age and year
p0 <- predict(fit, ple4, indices)
p1 <- predict(fit, ple4, indices, covar = scenario)
print(range(p1$harvest / p0$harvest))
print(exp(p[["fMod:temp"]]))

simsS <- simulate(fit, nsim = 100, seed = 1, stock = ple4, indices = indices, covar = scenario)

# The expected change is small next to observation error, so show both the
# simulated envelopes and the expected ratio scenario / fitted
ratios <- cbind("BTS index, age 2" = c(p1$index[[bts]]["2", ] / p0$index[[bts]]["2", ]),
                "BTS index, age 6" = c(p1$index[[bts]]["6", ] / p0$index[[bts]]["6", ]),
                "catch, age 2" = c(p1$catch.n["2", ac(1996:2017)] / p0$catch.n["2", ac(1996:2017)]),
                "catch, age 6" = c(p1$catch.n["6", ac(1996:2017)] / p0$catch.n["6", ac(1996:2017)]))
savePng("scenario", {
  par(mfrow = c(1, 2), mar = c(3, 5, 2, 1))
  plotEnvelope(list(fitted = index(sims$indices[[bts]]), scenario = index(simsS$indices[[bts]])),
               age = 6, main = paste(bts, "age 6"), ylab = "index")
  matplot(1996:2017, ratios, type = "l", lty = c(1, 1, 2, 2), lwd = 2, col = fitCols(2)[c(1, 2, 1, 2)],
          las = 1, xlab = "", ylab = "scenario / fitted", main = "Expected change (predict)")
  abline(h = 1, col = "grey60")
  legend("bottomright", colnames(ratios), lty = c(1, 1, 2, 2), lwd = 2, col = fitCols(2)[c(1, 2, 1, 2)],
         bty = "n", cex = 0.8)
})

# Covariates can also differ between simulations: give them nsim iterations,
# e.g. 50 random temperature trajectories
tempPaths <- propagate(temp, 50)
for (i in 1:50) {
  tempPaths[, , , , , i] <- c(stats::arima.sim(list(ar = 0.7), n = length(years), sd = 0.4))
}
simsT <- simulate(fit, nsim = 50, seed = 2, stock = ple4, indices = indices,
                  covar = list(temp = tempPaths))

#---------------------------------------------------------------------
# 4. Is a covariate effect recoverable?
#---------------------------------------------------------------------
# Suppose F responded to temperature by +20% per degree. Set that effect in
# the fitted model, simulate data sets, refit each one and compare.
truth <- fit
truth@coefficients["fMod:temp", 1] <- log(1.2)

simsR <- simulate(truth, nsim = 20, seed = 3, stock = ple4, indices = indices)
refits <- sca(simsR$stock, simsR$indices, fmodel = fmod, qmodel = qmod, covar = covar)

est <- c(coef(refits)["fMod:temp", ])
estSE <- sqrt(vcov(refits)["fMod:temp", "fMod:temp", ])
print(summary(est))
print(mean(abs(est - log(1.2)) < 2 * estSE))   # coverage of approximate 95% intervals

yrs <- as.numeric(years)
fbarRange <- ac(range(ple4)["minfbar"]:range(ple4)["maxfbar"])
savePng("effect-recovery", {
  par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
  plot(seq_along(est), est, ylim = range(est - 2 * estSE, est + 2 * estSE), pch = 16, las = 1,
       xlab = "simulation", ylab = "estimated temp effect on log F", main = "Refitted effect")
  segments(seq_along(est), est - 2 * estSE, seq_along(est), est + 2 * estSE)
  abline(h = log(1.2), col = fitCols(1), lwd = 2)
  legend("topleft", c("estimate +/- 2 se", "true value"), pch = c(16, NA), lwd = c(1, 2),
         col = c("black", fitCols(1)), bty = "n", cex = 0.8)

  plot(yrs, yearly(fbar(simsR$stock[, , , , , 1])), type = "n", las = 1, xlab = "", ylab = "Fbar",
       ylim = c(0, 1), main = "Fbar: truth and refits")
  for (i in seq_along(est)) lines(yrs, yearly(quantMeans(harvest(refits)[fbarRange, , , , , i])), col = "grey70")
  lines(yrs, yearly(fbar(simsR$stock[, , , , , 1])), col = fitCols(1), lwd = 2)
  legend("topleft", c("refits", "truth"), col = c("grey70", fitCols(1)), lwd = c(1, 2), bty = "n", cex = 0.8)
})
