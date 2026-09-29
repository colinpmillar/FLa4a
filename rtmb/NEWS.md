# FLa4a 2.0.0.9000

* Minimal rewrite: the model is implemented in R with RTMB, replacing the
  ADMB executable.
* `sca()` returns a single `a4aFit` class holding estimates, coefficients,
  covariance and fit summary; `fit = "assessment"` or `"MP"`.
* Dropped: MCMC, simulation/prediction, diagnostics, natural mortality,
  growth and length-to-age tools.
