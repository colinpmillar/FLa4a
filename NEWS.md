# FLa4a 2.0.0.9000

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
