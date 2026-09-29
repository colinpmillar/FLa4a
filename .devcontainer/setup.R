# Run once when the dev container is created.
# CRAN packages come as Linux binaries from Posit Package Manager (the
# default repository in Rocker images); FLCore comes from the FLR r-universe.

options(Ncpus = parallel::detectCores())
repos <- c(FLR = "https://flr.r-universe.dev", getOption("repos"))

install.packages(c("RTMB", "mgcv", "Matrix", "testthat", "roxygen2", "devtools", "FLCore"),
                 repos = repos)

# install FLa4a itself so that library(FLa4a) works straight away
install.packages(".", repos = NULL, type = "source")
