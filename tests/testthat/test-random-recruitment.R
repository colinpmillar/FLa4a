d <- simScenario("sr", seed = 1)
fitWith <- function(sr, ...) {
  m <- d$models
  m$srmodel <- sr
  do.call(sca, c(list(d$stock, d$indices), m, list(...)))
}
rfit <- fitWith(~ bevholt(CV = NA))

test_that("an estimated SR CV makes recruitment a random effect", {
  s <- fitSumm(rfit)[, 1]
  expect_equal(s[["convergence"]], 0)
  expect_true(all(c("srr:cv", "edf:recruitment", "nlogl:marginal") %in% names(s)))
  expect_gt(s[["srr:cv"]], 0.1)
  expect_lt(s[["srr:cv"]], 0.6)
  # the recruitments' effective degrees of freedom are below their number
  expect_gt(s[["edf:recruitment"]], 1)
  expect_lt(s[["edf:recruitment"]], 40)
  # nlogl is the data likelihood only: the recruitment distribution is a prior
  expect_equal(s[["nlogl"]], sum(s[c("nlogl:catch", "nlogl:survey")]))
  expect_false(anyNA(vcov(rfit)))
})

test_that("the estimated recruitment sd matches the simulated deviations", {
  # with nearly noise-free data the recruitments are known, so the estimated
  # sd must equal the sd of the true deviations from the true curve
  dn <- simScenario("sr", seed = 101, catch.sd = 0.01,
                    surveys = list(simSurvey("survey", ages = 1:7, q = 2e-3, sd = 0.01, time = 0.5)))
  S <- c(dn$truth$ssb)
  R <- c(dn$truth$rec)
  n <- length(R)
  dev <- log(R[-1]) - log(2e6 * S[-n] / (2e5 + S[-n]))
  m <- dn$models
  m$srmodel <- ~ bevholt(CV = NA)
  f <- do.call(sca, c(list(dn$stock, dn$indices), m, list(fit = "MP")))
  sdR <- sqrt(log(fitSumm(f)["srr:cv", 1]^2 + 1))
  expect_equal(sdR, sd(dev), tolerance = 0.05)
})

test_that("random recruitment works with other SR models, REML, prediction and simulation", {
  g <- fitWith(~ geomean(CV = NA), fit = "MP")
  expect_equal(fitSumm(g)["convergence", 1], 0)
  expect_true(is.finite(fitSumm(g)["srr:cv", 1]))

  r <- fitWith(~ bevholt(CV = NA), method = "REML")
  expect_equal(fitSumm(r)["convergence", 1], 0)
  expect_false(anyNA(vcov(r)))

  p <- predict(rfit, d$stock, d$indices)
  expect_equal(c(p$stock.n), c(stock.n(rfit)))
  s <- simulate(rfit, nsim = 2, seed = 1, stock = d$stock, indices = d$indices)
  expect_equal(dims(s$stock)$iter, 2)
  expect_false(anyNA(derivedCI(rfit, d$stock, d$indices)$se))

  expect_error(bevholt(CV = -1), "positive")
})
