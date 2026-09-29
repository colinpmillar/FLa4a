fmod <- ~ s(age, k = 5) + s(year, k = 25, bs = "ps")
qmod <- list(~ s(age, k = 4))
pfit <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, penalise = "fmodel")

test_that("penalised smoothers estimate smoothing parameters", {
  s <- fitSumm(pfit)[, 1]
  expect_equal(s[["convergence"]], 0)
  expect_lt(s[["maxgrad"]], 1e-3)
  expect_equal(rownames(smoothing(pfit)), c("fMod:s(age)", "fMod:s(year)"))
  expect_true(all(is.finite(smoothing(pfit))))

  # effective degrees of freedom lie between the null space and the basis size
  expect_gt(s[["edf:fMod:s(year)"]], 1)
  expect_lt(s[["edf:fMod:s(year)"]], 24)
  expect_equal(s[["nopar"]], length(coef(pfit)) - 4 - 24 + s[["edf:fMod:s(age)"]] + s[["edf:fMod:s(year)"]])

  # all coefficients have a covariance, and AIC uses the effective parameters
  expect_false(anyNA(vcov(pfit)))
  expect_equal(c(AIC(pfit)), 2 * s[["nopar"]] + 2 * s[["nlogl"]])
})

test_that("unpenalised smoothers and submodels are left alone", {
  f1 <- sca(ple4, ple4.index, fmodel = ~ s(age, k = 5, fx = TRUE) + s(year, k = 25, bs = "ps"),
            qmodel = qmod, penalise = TRUE, fit = "MP")
  # TRUE penalises every submodel's smoothers, including the default
  # variance and initial-numbers models, but not those with fx = TRUE
  expect_equal(rownames(smoothing(f1)),
               c("fMod:s(year)", "qMod:BTS-Combined (all):s(age)", "vMod:catch:s(age)", "n1Mod:s(age)"))

  f2 <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, penalise = "qmodel", fit = "MP")
  expect_equal(rownames(smoothing(f2)), "qMod:BTS-Combined (all):s(age)")

  f0 <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, fit = "MP")
  expect_equal(nrow(smoothing(f0)), 0)
  expect_error(sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, penalise = "fmod"), "penalise must be")
})

test_that("Fellner-Schall and Laplace estimates agree", {
  lap <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, penalise = "fmodel", sp.method = "laplace")
  expect_equal(fitSumm(lap)["convergence", 1], 0)
  expect_equal(c(smoothing(lap)), c(smoothing(pfit)), tolerance = 0.05)
  # Laplace maximises the marginal likelihood directly
  expect_lte(fitSumm(lap)["nlogl:marginal", 1], fitSumm(pfit)["nlogl:marginal", 1] + 1e-6)
})

test_that("the smoother prior is a normalised (improper) Gaussian density", {
  set.seed(1)
  S <- crossprod(diff(diag(8), differences = 2))          # second-order difference penalty
  e <- eigen(S, symmetric = TRUE)
  N <- e$vectors[, e$values < 1e-8]
  block <- list(idx = 1:8, lam = 1, S = list(methods::as(Matrix::Matrix(S, sparse = TRUE), "CsparseMatrix")),
                N = N, NN = methods::as(Matrix::Matrix(tcrossprod(N), sparse = TRUE), "CsparseMatrix"))
  u <- rnorm(8)
  lambda <- 2.5
  got <- FLa4a:::penaltyNll(list(re = u, loglambda = log(lambda)), list(block))
  Q <- lambda * S
  pos <- eigen(Q, symmetric = TRUE)$values
  pos <- pos[pos > 1e-8]
  expected <- -(0.5 * sum(log(pos)) - 0.5 * sum(u * (Q %*% u)) - 0.5 * length(pos) * log(2 * pi))
  expect_equal(got, expected)
})

test_that("the sparse Hessian equals the AD Hessian", {
  idx <- FLa4a:::prepIndices(ple4.index)
  data <- FLa4a:::a4aData(ple4, idx, fmod, qmod, defaultVmod(ple4, idx), defaultN1mod(ple4),
                          ~ bevholt(CV = 0.3), penalise = c("f", "q"))
  obj <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), data$par, silent = TRUE)
  set.seed(2)
  p <- obj$par + rnorm(length(obj$par), 0, 0.05)
  nb <- length(p) - length(data$par$loglambda)
  expect_equal(FLa4a:::hessianFun(data)(p), obj$he(p)[1:nb, 1:nb], tolerance = 1e-10)
})

test_that("predict and simulate work with penalised fits", {
  p <- predict(pfit, ple4, ple4.index)
  expect_equal(c(p$stock.n), c(stock.n(pfit)))
  expect_equal(c(p$index[[1]]), c(index(pfit)[[1]]))
  s <- simulate(pfit, nsim = 2, seed = 1, stock = ple4, indices = ple4.index, sample.pars = TRUE)
  expect_equal(dims(s$stock)$iter, 2)
  expect_false(anyNA(c(stock.n(s$stock))))
})
