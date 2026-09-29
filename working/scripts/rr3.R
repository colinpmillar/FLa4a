suppressMessages(library(FLa4a))
res <- parallel::mclapply(1:12, function(i) {
  d <- simScenario("sr", seed = 100 + i, catch.sd = 0.01,
                   surveys = list(simSurvey("survey", ages = 1:7, q = 2e-3, sd = 0.01, time = 0.5)))
  S <- c(d$truth$ssb); R <- c(d$truth$rec); n <- length(R)
  dev <- log(R[-1]) - log(2e6 * S[-n] / (2e5 + S[-n]))   # true curve, SSB of the previous year
  m <- d$models; m$srmodel <- ~ bevholt(CV = NA)
  f <- do.call(sca, c(list(d$stock, d$indices), m, list(fit = "MP")))
  est <- fitSumm(f)["srr:cv", 1]
  # sd of deviations from the estimated curve, recomputed from the fitted recruitments and SSB
  stk <- d$stock + f
  Sf <- c(ssb(stk)); Rf <- c(rec(stk))
  fitDev <- log(Rf[-1]) - log(Sf[-n]) 
  c(realisedSD = sd(dev), realisedRMS = sqrt(mean(dev^2)), estSD = sqrt(log(est^2 + 1)), conv = fitSumm(f)["convergence", 1])
}, mc.cores = 4)
r <- do.call(rbind, res); print(round(r, 3)); print(round(colMeans(r), 3))
