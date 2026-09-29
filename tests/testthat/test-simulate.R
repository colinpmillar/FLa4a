years <- dimnames(ple4)$year
set.seed(1)
temp <- FLQuant(rnorm(length(years)), dimnames = list(year = years))
lw <- log(stock.wt(ple4))
wtAnomaly <- lw %-% yearMeans(lw)
covar <- list(temp = temp, wtAnomaly = wtAnomaly)

fit <- sca(ple4, ple4.index, covar = covar,
           fmodel = ~ s(age, k = 5) + s(year, k = 20) + temp,
           qmodel = list(~ s(age, k = 4) + s(wtAnomaly, k = 3)))
beta <- c(coef(fit)["fMod:temp", 1])

test_that("predict at the fitted covariates reproduces the fit", {
  p <- predict(fit, ple4, ple4.index)
  expect_equal(c(p$stock.n), c(stock.n(fit)))
  expect_equal(c(p$harvest), c(harvest(fit)))
  expect_equal(c(p$catch.n), c(catch.n(fit)))
  expect_equal(c(p$index[[1]]), c(index(fit)[[1]]))
})

test_that("predict uses new covariate values with the fitted parameters", {
  p0 <- predict(fit, ple4, ple4.index)
  p1 <- predict(fit, ple4, ple4.index, covar = list(temp = temp + 1))
  # linear effect on log F
  expect_equal(c(p1$harvest / p0$harvest), rep(exp(beta), length(p0$harvest)))
  # recruitment and first-year numbers are not modelled with temp
  expect_equal(c(p1$stock.n[1, ]), c(p0$stock.n[1, ]))
  expect_equal(c(p1$stock.n[, 1]), c(p0$stock.n[, 1]))

  # a smoother of a covariate keeps its basis: only the index changes
  p2 <- predict(fit, ple4, ple4.index, covar = list(wtAnomaly = wtAnomaly * 0))
  expect_equal(c(p2$stock.n), c(p0$stock.n))
  expect_false(isTRUE(all.equal(c(p2$index[[1]]), c(p0$index[[1]]))))

  expect_warning(predict(fit, ple4, ple4.index, covar = list(sst = temp)), "not used")
})

test_that("simulate generates catches and indices around the expected values", {
  s1 <- simulate(fit, nsim = 25, seed = 3, stock = ple4, indices = ple4.index)
  s2 <- simulate(fit, nsim = 25, seed = 3, stock = ple4, indices = ple4.index)
  expect_identical(s1, s2)

  expect_s4_class(s1$stock, "FLStock")
  expect_s4_class(s1$indices, "FLIndices")
  expect_equal(dims(s1$stock)$iter, 25)
  expect_equal(dims(index(s1$indices[[1]]))$iter, 25)

  # true values are the fitted ones; observations vary around them
  expect_equal(c(stock.n(s1$stock)[, , , , , 7]), c(stock.n(fit)))
  r <- log(catch.n(s1$stock) / propagate(catch.n(fit), 25))
  expect_lt(abs(mean(r)), 0.02)
  expect_equal(c(catch(s1$stock)), c(quantSums(catch.n(s1$stock) * catch.wt(s1$stock))))

  # the observation pattern is kept
  expect_equal(is.na(c(index(s1$indices[[1]])[, , , , , 1])), is.na(c(index(ple4.index))))
})

test_that("simulate responds to new covariates, per simulation if given", {
  temp2 <- propagate(temp, 2)
  temp2[, , , , , 2] <- temp + 1
  s <- simulate(fit, nsim = 2, seed = 1, stock = ple4, indices = ple4.index, covar = list(temp = temp2))
  h <- harvest(s$stock)
  expect_equal(c(h[, , , , , 2] / h[, , , , , 1]), rep(exp(beta), 610))
  expect_error(simulate(fit, nsim = 3, stock = ple4, indices = ple4.index, covar = list(temp = propagate(temp, 2))),
               "1 or nsim")
})

test_that("simulated data can be refitted", {
  s <- simulate(fit, nsim = 2, seed = 4, stock = ple4, indices = ple4.index)
  refit <- sca(s$stock, s$indices, covar = covar, fmodel = fit@models$fmodel,
               qmodel = fit@models$qmodel, fit = "MP")
  expect_equal(dims(stock.n(refit))$iter, 2)
  expect_true(all(fitSumm(refit)["convergence", ] == 0))
  expect_equal(c(coef(refit)["fMod:temp", ]), rep(beta, 2), tolerance = 0.1)
})

test_that("parameter uncertainty can be sampled", {
  s <- simulate(fit, nsim = 2, seed = 5, stock = ple4, indices = ple4.index, sample.pars = TRUE)
  expect_false(isTRUE(all.equal(c(stock.n(s$stock)[, , , , , 1]), c(stock.n(s$stock)[, , , , , 2]))))

  mp <- sca(ple4, ple4.index, covar = covar, fmodel = fit@models$fmodel,
            qmodel = fit@models$qmodel, fit = "MP")
  expect_error(simulate(mp, stock = ple4, indices = ple4.index, sample.pars = TRUE), "covariance")
})

test_that("covariates with iterations are matched to data iterations in sca", {
  stk <- propagate(ple4, 2)
  tt <- propagate(temp, 2)
  tt[, , , , , 2] <- rev(c(temp))
  f2 <- sca(stk, ple4.index, covar = list(temp = tt), fmodel = ~ s(age, k = 5) + s(year, k = 20) + temp,
            qmodel = list(~ s(age, k = 4)), fit = "MP")
  f1 <- sca(ple4, ple4.index, covar = list(temp = temp), fmodel = ~ s(age, k = 5) + s(year, k = 20) + temp,
            qmodel = list(~ s(age, k = 4)), fit = "MP")
  expect_equal(c(stock.n(f2)[, , , , , 1]), c(stock.n(f1)), tolerance = 1e-6)
  expect_false(isTRUE(all.equal(c(coef(f2)[, 1]), c(coef(f2)[, 2]))))
})
