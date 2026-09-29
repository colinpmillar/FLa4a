suppressMessages(library(FLa4a))
trueCV <- sqrt(exp(0.3^2) - 1)
study <- function(label, ...) {
  d <- simScenario("sr", nsim = 40, seed = 11, ...)
  res <- parallel::mclapply(1:40, function(i) {
    stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
    fitOne <- function(sr, method = "ML") {
      m <- d$models; m$srmodel <- sr
      f <- tryCatch(do.call(sca, c(list(stk, idx), m, list(method = method, fit = "MP"))), error = function(e) NULL)
      if (is.null(f) || fitSumm(f)["convergence", 1] != 0) return(c(NA, NA))
      c(rmse = sqrt(mean(log(c(stock.n(f)[1, ]) / c(d$truth$rec))^2)),
        cv = if ("srr:cv" %in% rownames(fitSumm(f))) fitSumm(f)["srr:cv", 1] else NA)
    }
    rbind(free = fitOne(~ factor(year)), fixed = fitOne(~ bevholt(CV = 0.3)),
          randomML = fitOne(~ bevholt(CV = NA)), randomREML = fitOne(~ bevholt(CV = NA), "REML"))
  }, mc.cores = 4)
  a <- simplify2array(res)
  cat("\n==", label, "(true CV", round(trueCV, 3), ")\n")
  print(round(cbind(recRMSE = apply(a[, 1, ], 1, mean, na.rm = TRUE),
                    meanCV = apply(a[, 2, ], 1, mean, na.rm = TRUE),
                    converged = apply(!is.na(a[, 1, ]), 1, mean)), 3))
}
study("sr scenario")
study("data-poor: catch sd 0.3, survey sd 0.5", catch.sd = 0.3,
      surveys = list(simSurvey("survey", ages = 1:7, q = 2e-3, sd = 0.5, time = 0.5)))
