# FLa4a 2.0.0.9000

* `sca(..., method = "REML")` estimates the observation variances and any
  smoothing parameters by restricted maximum likelihood, integrating out
  all other coefficients. Maximum likelihood underestimates the variances
  (the catch sd by about 20% in the "simple" scenario), so its 95%
  confidence intervals cover the truth about 89% of the time; REML brings
  coverage close to 95% (see `src/examples/09-reml-coverage.R`); estimates
  are unchanged. With penalised smoothers REML also estimates the smoothing
  parameters.
* Fellner-Schall smoothing parameter updates now use step control (a step
  is halved until the marginal likelihood improves); previously they could
  occasionally diverge.
* Fits whose Laplace-based optimisation stops with "false convergence" at a
  small gradient are treated as converged.

* Simulated data with known truth: `simStock()` (with `simSurvey()`) and
  ready-made `simScenario()`s ("simple", "smooth", "covariate", "sr",
  "biomass"), each with the submodels to fit them. The population
  dynamics are implemented independently of the model.
* `derivedCI()`: delta-method confidence intervals for SSB, Fbar,
  recruitment and F at age, with Jacobians from automatic differentiation.
* Examples moved to `src/examples/`, with new examples on confidence
  interval coverage and simulated scenarios. Coverage of 95% intervals is
  about 0.89 for correctly specified models, mainly because maximum
  likelihood underestimates the observation variances.

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
