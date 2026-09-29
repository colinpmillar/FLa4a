# Working files

Code used during development to check the RTMB implementation. None of it
is part of the package (the folder is in `.Rbuildignore`), and paths are
those of the development container (`/tmp/claude-0`, `~/Rlib`), so expect
to edit them before rerunning.

- `make-admb-reference.sh` builds the original ADMB version of FLa4a
  (branch `master`) into a separate library, `/tmp/claude-0/reflib`.
- `scripts/` holds the scratch scripts. Those taking an argument `ref` or
  `new` run against the ADMB reference or the RTMB version:
  - ADMB regressions: `refrun.R` (a separable fit with ADMB), `cmp.R`
    (six model configurations: nopar, nlogl, SSB, Fbar, recruitment,
    fitted biomass index), `dflt.R` (default submodels), `se.R`
    (standard errors), `sr.R` (Ricker, hockey stick, Beverton-Holt SV).
    The agreed values are pinned in `tests/testthat/test-sca.R`.
  - `dbg*.R`: debugging.
  - `hess.R`, `prof*.R`: sparse Hessian and profiling.
  - `pen*.R`, `conv2d.R`, `fsdbg.R`: penalised smoothers and
    Fellner-Schall updates.
  - `sim1.R`, `simdata1.R`, `cov*.R`: simulated data and coverage.
  - `reml*.R`: REML.
  - `rr*.R`: random recruitment.
  - `readme_*.R`: checks that the README code runs.
- `session-log.md` lists every command in the session that ran R code, in
  order, with its output. It includes the one-off `Rscript -e` checks that
  were never saved as files.
- `logs/`: output of the penalised smoother checks (`pen4.log`) and the
  ML vs REML study (`reml-study.log`).
