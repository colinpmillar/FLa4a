# FLa4a (RTMB)

A minimal re-implementation of the [a4a](https://github.com/flr/FLa4a)
statistical catch-at-age model. The model is written in plain R and
differentiated with [RTMB](https://github.com/kaskr/RTMB), with no ADMB
executable and no C++ template.

## Installation

```r
install.packages(c("RTMB", "mgcv"))
install.packages("FLCore", repos = "https://flr.r-universe.dev")
remotes::install_github("colinpmillar/FLa4a", ref = "claude/peaceful-babbage-if9ubk")
```

### Dev container

The `.devcontainer/` folder uses the prebuilt
[Rocker](https://rocker-project.org) image `ghcr.io/rocker-org/devcontainer/r-ver:4.5`,
so nothing is built locally (this works with Docker Desktop on Windows). Open
the repository in VS Code and choose *Dev Containers: Reopen in Container*, or
open it in GitHub Codespaces. On first start `.devcontainer/setup.R` uses
[pak](https://pak.r-lib.org) to install the requirements declared in
`DESCRIPTION` (imports, `Suggests` and the dev tools listed under
`Config/Needs/dev`: devtools and roxygen2) as binaries, together with the
system libraries they need, and then installs FLa4a. Then:

```r
devtools::load_all()   # or devtools::test(), devtools::check()
```

On Windows, `.gitattributes` keeps line endings as LF inside the container.

## Usage

```r
library(FLa4a)
data(ple4)
data(ple4.indices)

fit <- sca(ple4, ple4.indices["BTS-Combined (all)"],
           fmodel  = ~ s(age, k = 5) + s(year, k = 20),
           qmodel  = list(~ s(age, k = 4)),
           srmodel = ~ bevholt(CV = 0.3))
fit
stk <- ple4 + fit
AIC(fit)
```

### Penalised smoothers

```r
# a generous basis; the smoothing parameter is estimated
fit <- sca(ple4, ple4.indices["BTS-Combined (all)"],
           fmodel = ~ s(age, k = 5) + s(year, k = 40, bs = "ps"),
           qmodel = list(~ s(age, k = 4)), penalise = "fmodel")
smoothing(fit)   # log smoothing parameters
fitSumm(fit)     # includes the effective degrees of freedom of each smoother
```

### Simulated data with known truth

```r
# data sets that test one aspect of the model each, with their submodels:
# "simple", "smooth", "covariate", "sr", "biomass"
d <- simScenario("simple", nsim = 100, seed = 1)
fit <- do.call(sca, c(list(iter(d$stock, 1), FLIndices(lapply(d$indices, iter, 1))), d$models))
ci <- derivedCI(fit, iter(d$stock, 1), FLIndices(lapply(d$indices, iter, 1)))  # SSB, Fbar, R, F
d$truth$ssb                                                             # the true values
```

`simStock()` builds custom data sets (selectivity, F trajectory, recruitment
model, surveys, covariate effects).

### REML

```r
# observation variances (and smoothing parameters) by restricted maximum
# likelihood, for confidence intervals with close to nominal coverage
fit <- sca(ple4, ple4.indices["BTS-Combined (all)"],
           fmodel = ~ s(age, k = 5) + s(year, k = 20), qmodel = list(~ s(age, k = 4)),
           method = "REML")
```

Maximum likelihood underestimates the observation variances, which makes
intervals too narrow; see `src/examples/09-reml-coverage.R`. Use ML (the
default) to compare models by AIC.

### Simulation with covariates

```r
temp <- FLQuant(rnorm(61), dimnames = list(year = 1957:2017))
fit <- sca(ple4, ple4.indices["BTS-Combined (all)"], covar = list(temp = temp),
           fmodel = ~ s(age, k = 5) + s(year, k = 20) + temp,
           qmodel = list(~ s(age, k = 4)))

# expected values, and simulated catches and indices, under new covariates
p   <- predict(fit, ple4, ple4.indices["BTS-Combined (all)"], covar = list(temp = temp + 1))
sim <- simulate(fit, nsim = 100, stock = ple4, indices = ple4.indices["BTS-Combined (all)"],
                covar = list(temp = temp + 1))
refit <- sca(sim$stock, sim$indices, covar = list(temp = temp),
             fmodel = fit@models$fmodel, qmodel = fit@models$qmodel)
```

See [`src/examples/`](src/examples) for worked examples with plots: getting started,
smoothers, covariates, stock-recruitment models, simulation, penalised
smoothers, confidence interval coverage and simulated scenarios.

## Code layout

| file | contents |
|------|----------|
| `R/sca.R` | `sca()`: loops over iterations and assembles the `a4aFit` |
| `R/data.R` | observations, biology and submodel design matrices for one iteration |
| `R/model.R` | the RTMB objective function `a4aNll()`, the smoother priors, the sparse Hessian, and estimation (`fitA4a()`, Fellner-Schall and Laplace smoothing parameter estimation) |
| `R/formula.R` | submodel designs: formula to design matrix (mgcv smoothers supported), re-evaluable at new data with the fitted basis |
| `R/srmodels.R` | stock-recruitment models: `bevholt()`, `ricker()`, `hockey()`, `geomean()`, `bevholtSV()` |
| `R/simulate.R` | `predict()` and `simulate()`: the fitted model at new covariate values, with observation error |
| `R/uncertainty.R` | `derivedCI()`: delta-method intervals for SSB, Fbar, recruitment and F |
| `R/simdata.R` | `simStock()`, `simSurvey()`, `simScenario()`: simulated data with known truth |
| `R/defaults.R` | default submodels |
| `R/a4aFit-class.R` | result class, accessors, `logLik()`, `FLStock + a4aFit` |

## Model

For ages *a* and years *y*, each submodel is a linear predictor
`X %*% beta` on the log scale:

- log F<sub>ay</sub> (`fmodel`), log q<sub>ay</sub> per index (`qmodel`),
  log observation sd per fleet (`vmodel`), log N in the first year
  (`n1model`) and log recruitment (`srmodel`)
- N<sub>a+1,y+1</sub> = N<sub>ay</sub> exp(-F<sub>ay</sub> - M<sub>ay</sub>), with an optional plus group
- catches follow the Baranov equation; indices are q N exp(-Z t) (biomass
  indices sum q N w exp(-Z t) over the index ages)
- log observations are normal, weighted by inverse relative variances if given
- an optional stock-recruitment curve adds a lognormal penalty on recruitment
- with `penalise`, smoothers are penalised: their coefficients have a
  Gaussian prior with precision sum<sub>j</sub> λ<sub>j</sub> S<sub>j</sub>
  (the mgcv penalty matrices, flat on the penalty's null space), and the
  smoothing parameters λ maximise the Laplace approximation of the marginal
  likelihood, with the coefficients integrated out. `sp.method = "efs"`
  (default) uses extended Fellner-Schall updates (Wood and Fasiolo, 2017),
  with Hessians computed from a sparse Hessian of the likelihood in the
  linear predictors; `sp.method = "laplace"` maximises RTMB's Laplace
  approximation directly
- with `method = "REML"`, the observation variance parameters and any
  smoothing parameters maximise the restricted likelihood, with all other
  coefficients integrated out by RTMB's Laplace approximation (flat priors
  on the unpenalised ones), starting from the maximum likelihood fit

Results agree with the ADMB implementation (FLa4a 1.9.7). The tests pin the ADMB
likelihoods for separable, smooth, stock-recruitment and biomass-index models.

## Not (yet) included

Compared with FLa4a 1.9.x, this version drops MCMC, residual and diagnostic classes, `a4aM`/growth/length-to-age tools, multiple
units/seasons/areas, and the `trawl()` formula helper. `predict()` and
`simulate()` cover the fitted ages and years (no projections yet), and
recruitment follows its fitted values unless its submodel uses covariates.
For penalised smoothers, mgcv's identifiability constraint makes P-spline
bases dense (keeping them sparse is a possible next step). With a single
penalised `te(age, year)` F surface, the marginal likelihood for ple4
favours very little smoothing across ages, so F follows the catch data
closely; separable main effects plus a penalised `ti(age, year)`
interaction are faster and better behaved (see `src/examples/06-penalised-smoothers.R`).

## License

EUPL
