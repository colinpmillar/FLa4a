# Run once when the dev container is created.
#
# Installs everything needed to develop FLa4a, as declared in DESCRIPTION:
#   Imports/Depends/LinkingTo  - RTMB, FLCore, mgcv, Matrix, ...
#   Suggests                   - testthat
#   Config/Needs/dev           - devtools, roxygen2
# pak installs binaries from Posit Package Manager (the default repository
# in Rocker images) and also the system libraries they need (via sudo).
# FLCore comes from the FLR r-universe.

options(repos = c(FLR = "https://flr.r-universe.dev", getOption("repos")))

if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")

pak::local_install_deps(
  ".",
  upgrade = FALSE,
  dependencies = c("Depends", "Imports", "LinkingTo", "Suggests", "Config/Needs/dev")
)

# install FLa4a itself so that library(FLa4a) works straight away
pak::local_install(".", upgrade = FALSE, dependencies = FALSE)

# check the main tools load
for (pkg in c("FLa4a", "RTMB", "FLCore", "devtools", "roxygen2", "testthat")) {
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
}
message("FLa4a development environment ready")
