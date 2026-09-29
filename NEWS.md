# FLa4a 2.0.0.9000

* Penalised smoothers: `sca(..., penalise = TRUE)` (or naming submodels, e.g.
  `penalise = "fmodel"`) penalises `s()`, `te()`, `ti()` and `t2()` smoothers
  and estimates their smoothing parameters by maximising the Laplace
  approximation of the marginal likelihood. `sp.method = "efs"` (default)
  uses extended Fellner-Schall updates; `"laplace"` uses RTMB's Laplace
  approximation directly. `fx = TRUE` keeps a smoother unpenalised.
  `smoothing()` returns the log smoothing parameters and `fitSumm()` the
  effective degrees of freedom; `AIC()` is then a conditional AIC.
* Hessians for penalised fits use a sparse Hessian of the likelihood in the
  linear predictors.

* New `predict()` and `simulate()` methods for `a4aFit`. They evaluate the
  fitted model at new covariate values (smoothers keep their fitted bases)
  and simulate catch and survey indices with lognormal observation error,
  optionally with parameter uncertainty. Simulations are returned as an
  `FLStock` and `FLIndices` with `nsim` iterations, ready to refit.
* Covariates may have iterations, matched to the data's iterations in
  `sca()` and to simulations in `simulate()`.
* Fits store their submodel designs and covariates.

* Minimal rewrite: the model is implemented in R with RTMB, replacing the
  ADMB executable.
* `sca()` returns a single `a4aFit` class holding estimates, coefficients,
  covariance and fit summary; `fit = "assessment"` or `"MP"`.
* Dropped: MCMC, diagnostics, natural mortality,
  growth and length-to-age tools.
