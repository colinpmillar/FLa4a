# Examples

Worked examples using North Sea plaice (`ple4` and `ple4.indices` from
FLCore). Run them from the repository root, either line by line or with
`source()`:

```r
source("examples/01-getting-started.R")
```

Each script saves its plots as PNG files in a folder named after it, e.g.
`examples/01-getting-started/stock-summary.png` (these folders are not
tracked by git). In your own code, `savePng("name", { ...plotting code... })`
from `helpers.R` does the same.

| script | shows |
|--------|-------|
| `01-getting-started.R` | a first fit, results as FLQuants, `stock + fit`, summary plots, index fits, residuals, AIC/BIC |
| `02-smoothers.R` | `s()`, `te()`, `ti()` in the F, catchability and recruitment submodels; how `k` trades flexibility against parameters |
| `03-covariates.R` | year-only and age x year covariates via `covar`; linear, smooth and varying-coefficient effects; `breakpts()` |
| `04-stock-recruitment.R` | Beverton-Holt, Ricker, hockey stick and geomean relationships; fitted curves; the effect of the CV |
| `05-simulate-covariates.R` | `predict()` and `simulate()` from a covariate model: predictive checks, covariate scenarios (including per-simulation covariates), parameter uncertainty, and refitting simulated data to check an effect is recoverable |
| `06-penalised-smoothers.R` | penalised 1D and 2D smoothers with estimated smoothing parameters: unpenalised vs penalised, Fellner-Schall vs Laplace, uncertainty, and a 2D tensor-product F surface |
| `helpers.R` | base-graphics plotting helpers used by the scripts |

The plots use base R graphics only, so no packages beyond FLa4a's own
dependencies are needed. Scripts 01-04 take 10-30 seconds each; 05 and 06 take 1-3 minutes.

In 01-05 the smoothers are unpenalised regression splines, whose basis size
`k` fixes their flexibility; 06 shows penalised smoothers, whose smoothness
is estimated.
