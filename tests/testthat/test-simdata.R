test_that("simStock produces consistent data and truth", {
  d <- simStock(nsim = 3, seed = 1)
  expect_s4_class(d$stock, "FLStock")
  expect_s4_class(d$indices, "FLIndices")
  expect_equal(dims(d$stock)$iter, 3)
  expect_equal(dims(index(d$indices[[1]]))$iter, 3)

  tr <- d$truth
  Z <- tr$harvest + m(d$stock)[, , , , , 1]
  expect_equal(c(tr$catch.n), c(tr$harvest / Z * (1 - exp(-Z)) * tr$stock.n))
  expect_equal(c(tr$ssb), c(quantSums(tr$stock.n * stock.wt(d$stock)[, , , , , 1] * mat(d$stock)[, , , , , 1])))
  # survivors, away from the plus group
  n <- tr$stock.n
  expect_equal(c(n[2:7, -1]), c((n * exp(-Z))[1:6, -30]))

  # observations vary around the truth, the truth does not
  expect_false(isTRUE(all.equal(c(catch.n(d$stock)[, , , , , 1]), c(catch.n(d$stock)[, , , , , 2]))))
  expect_identical(simStock(nsim = 3, seed = 1), d)
})

test_that("the model recovers the truth from nearly noise-free data", {
  d <- simStock(ages = 1:6, years = 1991:2020, fbar = c(2, 4), sel = list(a50 = 2, slope = 0.5),
                surveys = list(simSurvey("s", ages = 1:5, q = 2e-3, sd = 0.01)), catch.sd = 0.01, seed = 1)
  fit <- do.call(sca, c(list(d$stock, d$indices), simScenario("simple")$models))
  expect_equal(fitSumm(fit)["convergence", 1], 0)
  expect_equal(c(harvest(fit)), c(d$truth$harvest), tolerance = 0.03)
  expect_equal(c(stock.n(fit)), c(d$truth$stock.n), tolerance = 0.03)
})

test_that("scenarios have the right structure and fit", {
  for (sc in c("simple", "smooth", "covariate", "sr", "biomass")) {
    d <- simScenario(sc, seed = 1)
    expect_equal(length(d$models$qmodel), length(d$indices), label = sc)
    expect_equal(length(d$models$vmodel), length(d$indices) + 1, label = sc)
  }
  expect_true(is(simScenario("biomass", seed = 1)$indices[[2]], "FLIndexBiomass"))

  d <- simScenario("covariate", seed = 1)
  fit <- do.call(sca, c(list(d$stock, d$indices), d$models, list(covar = d$covar)))
  b <- c(coef(fit)[c("fMod:effort", "qMod:survey:temp"), 1])
  se <- sqrt(diag(vcov(fit)[, , 1]))[c("fMod:effort", "qMod:survey:temp")]
  expect_true(all(abs(b - c(0.3, 0.4)) < 4 * se))
  # scenario arguments can be replaced
  expect_equal(dims(simScenario("simple", years = 2001:2010)$stock)$year, 10)
})

test_that("derivedCI matches the fit and brackets the estimates", {
  d <- simScenario("simple", seed = 2)
  fit <- do.call(sca, c(list(d$stock, d$indices), d$models))
  ci <- derivedCI(fit, d$stock, d$indices)
  est <- d$stock + fit
  expect_equal(ci$estimate[ci$quantity == "ssb"], c(ssb(est)))
  expect_equal(ci$estimate[ci$quantity == "fbar"], c(fbar(est)))
  expect_equal(ci$estimate[ci$quantity == "rec"], c(stock.n(fit)[1, ]))
  expect_equal(ci$estimate[ci$quantity == "harvest"], c(harvest(fit)))
  expect_true(all(ci$lower < ci$estimate & ci$estimate < ci$upper))

  # the delta-method standard error of log F matches the linear predictor's
  X <- FLa4a:::predictDesign(fit@design$f, expand.grid(age = 1:6, year = 1991:2020))
  pf <- grep("^fMod:", dimnames(coef(fit))$params)
  V <- vcov(fit)[pf, pf, 1]
  expect_equal(ci$se[ci$quantity == "harvest"], sqrt(rowSums((X %*% V) * X)), tolerance = 1e-8)

  mp <- sca(d$stock, d$indices, fmodel = d$models$fmodel, qmodel = d$models$qmodel, fit = "MP")
  expect_error(derivedCI(mp, d$stock, d$indices), "covariance")
})
