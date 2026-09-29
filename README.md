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

See [`examples/`](examples) for worked examples with plots: getting started,
smoothers, covariates and stock-recruitment models.

## Code layout

| file | contents |
|------|----------|
| `R/sca.R` | `sca()`: loops over iterations and assembles the `a4aFit` |
| `R/data.R` | observations, biology and submodel design matrices for one iteration |
| `R/model.R` | the RTMB objective function `a4aNll()` and optimiser `fitA4a()` |
| `R/formula.R` | `getX()`: formula to design matrix (mgcv smoothers supported) |
| `R/srmodels.R` | stock-recruitment models: `bevholt()`, `ricker()`, `hockey()`, `geomean()`, `bevholtSV()` |
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

Results agree with the ADMB implementation (FLa4a 1.9.7). The tests pin the ADMB
likelihoods for separable, smooth, stock-recruitment and biomass-index models.

## Not (yet) included

Compared with FLa4a 1.9.x, this version drops MCMC, `simulate`/`predict`,
residual and diagnostic classes, `a4aM`/growth/length-to-age tools, multiple
units/seasons/areas, and the `trawl()` formula helper. The next step is
efficient sparse estimation of penalised 1D and 2D smoothers.

## License

EUPL
