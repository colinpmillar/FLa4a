# R development environment for FLa4a (RTMB)
FROM rocker/r-ver:4.5

# system libraries needed to build R packages from source
RUN apt-get update && apt-get install -y --no-install-recommends \
      git libxml2-dev libcurl4-openssl-dev libssl-dev libfontconfig1-dev \
      libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# package dependencies (CRAN binaries come from Posit Package Manager via rocker's defaults)
RUN install2.r --error --skipinstalled --ncpus -1 \
      RTMB mgcv Matrix testthat roxygen2 devtools languageserver \
    && rm -rf /tmp/downloaded_packages

# FLCore from the FLR r-universe
RUN Rscript -e 'install.packages("FLCore", repos = c(FLR = "https://flr.r-universe.dev", CRAN = getOption("repos")))' \
    && Rscript -e 'library(FLCore); library(RTMB)'
