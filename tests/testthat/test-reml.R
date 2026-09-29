d <- simScenario("simple", nsim = 1, seed = 3)
ml <- do.call(sca, c(list(d$stock, d$indices), d$models))
reml <- do.call(sca, c(list(d$stock, d$indices), d$models, method = "REML"))
sdOf <- function(fit) exp(c(coef(fit)[c("vMod:catch:(Intercept)", "vMod:survey:(Intercept)"), 1]))

test_that("REML fits converge and report the restricted likelihood", {
  s <- fitSumm(reml)[, 1]
  expect_equal(s[["convergence"]], 0)
  expect_lt(s[["maxgrad"]], 1e-3)
  expect_true(is.finite(s[["nlogl:marginal"]]))
  expect_false("nlogl:marginal" %in% rownames(fitSumm(ml)))
  expect_false(anyNA(vcov(reml)))
})

test_that("REML gives larger observation variances than ML", {
  # ML underestimates them; REML accounts for the estimated coefficients
  expect_true(all(sdOf(reml) > sdOf(ml)))
  # the catch sd, supported by the most coefficients, changes most
  expect_gt(sdOf(reml)[[1]] / sdOf(ml)[[1]], sdOf(reml)[[2]] / sdOf(ml)[[2]])
  # the mean structure barely changes, so neither does SSB, but intervals widen
  ciML <- derivedCI(ml, d$stock, d$indices, quantities = "ssb")
  ciREML <- derivedCI(reml, d$stock, d$indices, quantities = "ssb")
  expect_equal(ciREML$estimate, ciML$estimate, tolerance = 0.02)
  expect_true(all(ciREML$se > ciML$se))
})

test_that("REML works with penalised smoothers", {
  m <- d$models
  m$fmodel <- ~ s(age, k = 5) + s(year, k = 20, bs = "ps")
  f <- do.call(sca, c(list(d$stock, d$indices), m, list(penalise = "fmodel", method = "REML")))
  s <- fitSumm(f)[, 1]
  expect_equal(s[["convergence"]], 0)
  expect_equal(nrow(smoothing(f)), 2)
  expect_true(all(c("nlogl:marginal", "edf:fMod:s(year)") %in% names(s)))
  expect_gt(sdOf(f)[[1]], sdOf(ml)[[1]])
})
