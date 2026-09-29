# Reference negative log-likelihoods were produced with the ADMB
# implementation of FLa4a 1.9.7 on the same data and submodels.

fmod <- ~ s(age, k = 5) + s(year, k = 20)
qmod <- list(~ s(age, k = 4))

test_that("separable model matches the ADMB implementation", {
  fit <- sca(ple4, ple4.index, fmodel = ~ factor(age) + factor(year),
             qmodel = list(~ factor(age)))
  expect_s4_class(fit, "a4aFit")
  expect_equal(fitSumm(fit)["nopar", 1], 148)
  expect_equal(fitSumm(fit)["nlogl", 1], -101.25012, tolerance = 1e-6)
  expect_equal(fitSumm(fit)["convergence", 1], 0)
  expect_lt(fitSumm(fit)["maxgrad", 1], 1e-4)
})

test_that("stock-recruitment models match the ADMB implementation", {
  bh <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, srmodel = ~ bevholt(CV = 0.3))
  expect_equal(fitSumm(bh)["nlogl", 1], 34.79643, tolerance = 1e-6)
  expect_true("nlogl:srr" %in% rownames(fitSumm(bh)))

  gm <- sca(ple4, ple4.index, fmodel = ~ te(age, year, k = c(4, 15)), qmodel = qmod,
            srmodel = ~ geomean(CV = 0.5))
  expect_equal(fitSumm(gm)["nlogl", 1], -233.21555, tolerance = 1e-6)
})

test_that("biomass indices match the ADMB implementation", {
  bidx <- as(ple4.index, "FLIndexBiomass")
  index(bidx) <- quantSums(index(ple4.index) * stock.wt(ple4)[1:10, ac(1996:2017)])
  range(bidx)[c("startf", "endf")] <- c(0.6, 0.7)
  fit <- sca(ple4, FLIndices(a = ple4.index, b = bidx), fmodel = fmod, qmodel = list(qmod[[1]], ~ 1))
  expect_equal(fitSumm(fit)["nlogl", 1], -31.57419, tolerance = 1e-6)
  expect_equal(dimnames(index(fit)$b)$age, "all")
})

test_that("fitted quantities are consistent", {
  fit <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod)
  expect_equal(dim(stock.n(fit)), dim(stock.n(ple4)))
  expect_equal(dimnames(index(fit)[[1]]), dimnames(index(ple4.index)))
  Z <- harvest(fit) + m(ple4)
  expect_equal(c(catch.n(fit)), c(harvest(fit) / Z * (1 - exp(-Z)) * stock.n(fit)))
  # survivors: N[a+1, y+1] = N[a, y] exp(-Z[a, y]) away from the plus group
  expect_equal(c(stock.n(fit)[2:9, -1]), c((stock.n(fit) * exp(-Z))[1:8, -dims(fit@stock.n)$year]))

  stk <- ple4 + fit
  expect_equal(stock.n(stk), stock.n(fit))
  expect_equal(harvest(stk), harvest(fit))
  expect_equal(c(catch(stk)), c(quantSums(catch.n(fit) * catch.wt(ple4))))

  expect_equal(dim(vcov(fit))[1:2], rep(fitSumm(fit)["nopar", 1], 2))
  expect_false(anyNA(vcov(fit)))
  expect_output(print(fit), "a4aFit")
  expect_lt(length(capture.output(print(fit))), 20)
  expect_equal(c(AIC(fit)), 2 * fitSumm(fit)["nopar", 1] + 2 * fitSumm(fit)["nlogl", 1])
})

test_that("fit = 'MP' skips the covariance matrix", {
  fit <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, fit = "MP")
  expect_true(all(is.na(vcov(fit))))
  expect_false(anyNA(stock.n(fit)))
})

test_that("iterations are fitted independently", {
  stk <- propagate(ple4, 2)
  catch.n(stk)[, , , , , 2] <- catch.n(stk)[, , , , , 2] * 1.1
  fit <- sca(stk, ple4.index, fmodel = fmod, qmodel = qmod, fit = "MP")
  fit1 <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, fit = "MP")
  expect_equal(dims(stock.n(fit))$iter, 2)
  expect_equal(ncol(fitSumm(fit)), 2)
  expect_equal(c(stock.n(fit)[, , , , , 1]), c(stock.n(fit1)), tolerance = 1e-6)
  expect_false(isTRUE(all.equal(c(stock.n(fit)[, , , , , 1]), c(stock.n(fit)[, , , , , 2]))))

  expect_error(sca(stk, propagate(ple4.index, 3), fmodel = fmod, qmodel = qmod),
               "inconsistent number of iterations")
})

test_that("covariates can be used in submodels", {
  temp <- FLQuant(seq(-1, 1, length = dims(ple4)$year), dimnames = list(year = dimnames(ple4)$year))
  fit <- sca(ple4, ple4.index, fmodel = fmod, qmodel = list(~ s(age, k = 4) + temp),
             covar = list(temp = temp), fit = "MP")
  expect_true(any(grepl("^qMod:.*:temp$", dimnames(coef(fit))$params)))
})

test_that("default submodels run", {
  fit <- sca(ple4, ple4.indices[c("BTS-Combined (all)", "SNS")], fit = "MP")
  expect_equal(fitSumm(fit)["convergence", 1], 0)
  expect_equal(names(index(fit)), c("BTS-Combined (all)", "SNS"))
})
