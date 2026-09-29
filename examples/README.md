# Examples

Worked examples using North Sea plaice (`ple4` and `ple4.indices` from
FLCore). Run them from the repository root, either line by line or with
`source()`:

```r
source("examples/01-getting-started.R")
```

| script | shows |
|--------|-------|
| `01-getting-started.R` | a first fit, results as FLQuants, `stock + fit`, summary plots, index fits, residuals, AIC/BIC |
| `02-smoothers.R` | `s()`, `te()`, `ti()` in the F, catchability and recruitment submodels; how `k` trades flexibility against parameters |
| `03-covariates.R` | year-only and age x year covariates via `covar`; linear, smooth and varying-coefficient effects; `breakpts()` |
| `04-stock-recruitment.R` | Beverton-Holt, Ricker, hockey stick and geomean relationships; fitted curves; the effect of the CV |
| `helpers.R` | base-graphics plotting helpers used by the scripts |

The plots use base R graphics only, so no packages beyond FLa4a's own
dependencies are needed. Each script takes 10-30 seconds.

The smoothers here are unpenalised regression splines: the basis size `k`
fixes their flexibility. These scripts are the baseline for the planned
penalised smoothers, which will estimate the smoothness instead.
