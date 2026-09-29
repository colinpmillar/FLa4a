# Session log: R commands used for checking and development

Every shell command from the development session that ran R code, in order,
with its output (long outputs truncated). Scratch scripts referenced as
`/tmp/claude-0/*.R` are copied to `scripts/`.

## 1. 

```sh
git status && git branch -a && git log --oneline | head -5 && ls && cat DESCRIPTION && ls R src inst 2>/dev/null | head -80 && wc -l R/*.R | tail -1
```

Output:

```
On branch claude/peaceful-babbage-if9ubk
nothing to commit, working tree clean
* claude/peaceful-babbage-if9ubk
  master
  remotes/origin/claude/peaceful-babbage-if9ubk
  remotes/origin/master
6b5fc59 Add new features to FLa4a 1.9.x
b8ba395 getX with ti
0f044d9 Merge pull request #149 from danaim/ti-addition
cc80aca adding ti() in getX
35e91e5 Merge pull request #148 from danaim/plotBICvsGCV
BinaryFiles
DESCRIPTION
Makefile
NAMESPACE
NEWS
NEWS.md
R
README.md
_pkgdown.yml
appveyor.yml
code-experimental
data
inst
man
man-experimental
man-roxygen
pkgdown
tests
Package: FLa4a
Type: Package
Title: A Simple and Robust Statistical Catch at Age Model
Version: 1.9.7
Author: Colin P. Millar [aut], Ernesto Jardim [aut, cre]
Maintainer: Ernesto Jardim <ernesto.jardim@gmail.com>
Authors@R: c(
  person("Colin P.", "Millar", email = "colin.millar@ices.dk", role = "aut"),
  person("Ernesto", "Jardim", email = "ernesto.jardim@gmail.com", role = c("aut", "cre")))
Description: A simple and robust statistical Catch at Age model that is
    specifically designed for stocks with intermediate levels of data quantity and
    quality.
License: EUPL
Imports:
  methods,
  lattice,
  Matrix,
  copula,
  coda,
  grid,
  gridExtra,
  latticeExtra,
  mgcv
Depends:
  R (>= 4.0),
  FLCore (>= 2.6.15),
  triangle
Additional_repositories: http://flrproject.org/R
Suggests:
    knitr,
    formatR,
    XML,
    reshape2,
    testthat (>= 3.0.0),
    ggplotFL
LazyLoad: yes
LazyData: yes
VignetteBuilder: knitr
Collate:
    'FLCompMethods.R'
    'FLModelSimMethods.R'
    'a4aM-class.R'
    'a4aM-methods.R'
    'a4aGr-class.R'
    'a4aGr-methods.R'
    'a4aStkParams-class.R'
    'submodel-class.R'
    'submodels-class.R'
    'SCAPars-class.R'
    'SCAMCMC-class.R'
    'a4aFit-class.R'
    'a4aFits-class.R'
    'a4aFitSA-class.R'
    'a4aFitSAs-class.R'
    'a4aFitMCMC-class.R'
    'a4aFitMCMCs-class.R'
    'a4aFitresiduals-class.R'
    'coef-methods.R'
    'vcov-methods.R'
    'predict-methods.R'
    'simulate-methods.R'
    'addition-methods.R'
    'internal.R'
    'data.R'
    'redfish-data.R'
    'setupModel.R'
    'fittingFunctions.R'
    'l2a-methods.R'
    'ma-methods.R'
    'utilities.R'
    'gen-methods.R'
    'southern_hake-data.R'
    'a4amse-sa.R'
    'a4aFitCatchDiagn-class.R'
Encoding: UTF-8
Config/testthat/edition: 3
R:
FLCompMethods.R
FLModelSimMethods.R
SCAMCMC-class.R
SCAPars-class.R
a4aFit-class.R
a4aFitCatchDiagn-class.R
a4aFitMCMC-class.R
a4aFitMCMCs-class.R
a4aFitSA-class.R
a4aFitSAs-class.R
a4aFitresiduals-class.R
a4aFits-class.R
a4aGr-class.R
a4aGr-methods.R
a4aM-class.R
a4aM-methods.R
a4aStkParams-class.R
a4amse-sa.R
addition-methods.R
coef-methods.R
data.R
fittingFunctions.R
gen-methods.R
internal.R
l2a-methods.R
ma-methods.R
predict-methods.R
redfish-data.R
setupModel.R
simulate-methods.R
southern_hake-data.R
submodel-class.R
submodels-class.R
utilities.R
vcov-methods.R

inst:
CITATION
admb
bin
  7919 total
```

## 2. 

```sh
ls inst/admb inst/bin data tests tests/* | head -50; wc -l R/*.R; which R Rscript; R --version | head -1
```

Output:

```
tests/addition.R
tests/l2a.R
tests/m.R
tests/mcmc.R
tests/obserror.R
tests/predict.R
tests/residuals.R
tests/sca.R
tests/scas.R
tests/scssr.R
tests/simulate.R
tests/wcsam.R

data:
dps567.idx.rda
dps567.rda
hakeGSA7.idx.rda
hakeGSA7.rda
hke1567.idx.rda
hke1567.rda
mut09.idx.rda
mut09.rda
rfLen.rdata
southernHakeLen.rdata

inst/admb:
a4a.tpl

inst/bin:
linux
osx
windows

tests:
addition.R
l2a.R
m.R
mcmc.R
obserror.R
predict.R
residuals.R
sca.R
scas.R
scssr.R
simulate.R
wcsam.R
   185 R/FLCompMethods.R
   189 R/FLModelSimMethods.R
   117 R/SCAMCMC-class.R
   237 R/SCAPars-class.R
   189 R/a4aFit-class.R
   305 R/a4aFitCatchDiagn-class.R
   118 R/a4aFitMCMC-class.R
   117 R/a4aFitMCMCs-class.R
   175 R/a4aFitSA-class.R
    79 R/a4aFitSAs-class.R
   255 R/a4aFitresiduals-class.R
   143 R/a4aFits-class.R
   132 R/a4aGr-class.R
   156 R/a4aGr-methods.R
   178 R/a4aM-class.R
   239 R/a4aM-methods.R
   354 R/a4aStkParams-class.R
    98 R/a4amse-sa.R
   169 R/addition-methods.R
   130 R/coef-methods.R
   146 R/data.R
  1605 R/fittingFunctions.R
   331 R/gen-methods.R
   363 R/internal.R
   291 R/l2a-methods.R
    65 R/ma-methods.R
    99 R/predict-methods.R
    10 R/redfish-data.R
   186 R/setupModel.R
   303 R/simulate-methods.R
     9 R/southern_hake-data.R
   182 R/submodel-class.R
   235 R/submodels-class.R
   393 R/utilities.R
   136 R/vcov-methods.R
  7919 total
/bin/bash: line 1: R: command not found
```

## 3. 

```sh
R --version | head -1; mkdir -p ~/Rlib; echo 'R_LIBS_USER=~/Rlib' > ~/.Renviron; Rscript -e 'options(repos=c(CRAN="https://cloud.r-project.org")); install.packages(c("RTMB"), Ncpus=8, quiet=TRUE); library(RTMB); cat("RTMB OK\n")' 2>&1 | tail -5
```

Output:

```
R version 4.3.3 (2024-02-29) -- "Angel Food Cake"
A version of this package for your version of R might be available elsewhere,
see the ideas at
https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Installing-packages 
Error in library(RTMB) : there is no package called 'RTMB'
Execution halted
```

## 4. 

```sh
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq r-cran-iterators >/dev/null 2>&1; cd /tmp/claude-0 && R CMD INSTALL --no-docs --no-multiarch -l ~/Rlib RTMB/RTMB > rtmb.log 2>&1; echo rtmb $?; tail -3 rtmb.log; R CMD INSTALL --no-docs -l ~/Rlib FLCore > flcore.log 2>&1; echo flcore $?; tail -3 flcore.log
```

Output:

```
Command running in background with ID: be637uu28. Output is being written to: /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/be637uu28.output. You will be notified when it completes. To check interim output, use Read on that file path.
Session cwd remains /home/user/FLa4a; directory changes made by the backgrounded command do not apply to subsequent commands.
```

## 5. 

```sh
cat R/internal.R; grep -n "getX\|isPresenta4aSRmodel\|geta4aSRmodel" -r R | grep -v "^R/internal.R\|fittingFunctions" | head
```

Output:

```
###################################################################################
# internal functions
###################################################################################

# startup message
.onAttach <- function(libname, pkgname)
{
  ## TODO find out sep char for environment vars on macs
  sep <- if (os.type("linux") | os.type("osx")) ":" else if (os.type("windows")) ";" else ","
  path <- paste0(a4a.dir(), sep, Sys.getenv("PATH"))
  Sys.setenv(PATH=path)

  ## message with version number
  tbl <- library(help = FLa4a)$info[[1]]
  version <- gsub(" |[a-zA-z]|:", "", tbl[grep("Version:",tbl)])
  msg <- paste0("This is FLa4a ", version,". For overview type \'help(package=\"FLa4a\")\'\n")
  packageStartupMessage(msg)

  # check 64 bit platform in windows
  if(os.type("windows") && grepl("x86", sessionInfo()$running))
    stop("a4a executable in this package has been compiled for a 64 bit OS,
      please get the i386 version on the FLa4a release page at
      https://github.com/flr/FLa4a/releases")
  
  #
  check.executable()
}

# returns the location on the file system of the ADMB executable
a4a.dir <- function () 
{
  if (os.type("linux")) {
    fnm <- system.file("bin/linux", package = "FLa4a")
  }
  else if (os.type("osx")) {
    fnm <- system.file("bin/osx", package = "FLa4a")
  }
  else if (os.type("windows")) {
    fnm <- system.file("bin/windows", package = "FLa4a")
  }
  else {
    stop("Unknown OS")
  }
  if (file.exists(fnm)) {
    return(fnm)
  }
  else {
    stop(paste("FLa4a installation error; no such file", fnm))
  }
}


# returns TRUE if correct operating system is passed as an argument
#os.type <- function (type = c("linux", "mac", "windows", "else")) 
os.type <- function (type = c("linux", "windows", "osx", "else")) 
{
  type = match.arg(type)
  if (type == "windows") {
    return(.Platform$OS.type == "windows")
  }
#  else if (type == "mac") {
#   result = (file.info("/Library")$isdir && file.info("/Applications")$isdir)
#    if (i
... [truncated] ...
t relationship.")
  if (sum(a4as) == 0) "none()" else facs[a4as]
}

# -------------------------------------------------------------------
# generates catch.n and stock.n from f, m, ny1 and rec
# used by simulate and genFLStock
# -------------------------------------------------------------------

genStknCthn <- function(f, m, ny1, rec, plusgrp=TRUE){
    dms <- dims(f)
    stkn <- cthn <- f
    stkn[1,] <- rec
    stkn[-1,1] <- ny1[-1]

	# fill stock.n (waste space save time)
    Zs <- f + m
    for (a in 2:dms $ age) {
      stkn[a,-1] <- stkn[a-1, 1:(dms $ year-1)] * exp( - Zs[a-1, 1:(dms $ year-1)] )
    }
    # if plus group
    if (plusgrp) {
      for (y in 1:(dms $ year-1))
        stkn[a,y+1,] <- stkn[a,y+1,] + stkn[a, y,] * exp( - Zs[a, y,] )
    }

    # calculate catch
    zfrac <- f / Zs * (1 - exp(-Zs))
    cthn <- zfrac * stkn
    FLQuants(stock.n=stkn, catch.n=cthn)
}

R/gen-methods.R:148:      X <- getX(formula(object), df)
R/gen-methods.R:200:      srmodel <- geta4aSRmodel(srMod(object))
R/setupModel.R:2:#' @name getX
R/setupModel.R:3:#' @rdname getX-methods
R/setupModel.R:9:#' @note \code{getX} is intended to be used internally
R/setupModel.R:10:#' @aliases getX getX-methods
R/setupModel.R:11:setGeneric("getX", function(object, ...) standardGeneric("getX"))
R/setupModel.R:12:#' @rdname getX-methods
R/setupModel.R:13:setMethod("getX", "formula", function(object, df, newdf = df, tol = 1e-4) {
R/a4aStkParams-class.R:256:    srmodel <- geta4aSRmodel(srMod(from))
```

## 6. 

```sh
cat R/setupModel.R; cat tests/sca.R | head -60; cat README.md | head -40
```

Output:

```
#' @title Get model matrix
#' @name getX
#' @rdname getX-methods
#' @description Uses the user-specified formula to build a model matrix.
#' @template bothargs
#' @param df the data.frame to build the model matrix against.
#' @param newdf the data.frame to create the model matrix for.
#' @return a matrix.
#' @note \code{getX} is intended to be used internally
#' @aliases getX getX-methods
setGeneric("getX", function(object, ...) standardGeneric("getX"))
#' @rdname getX-methods
setMethod("getX", "formula", function(object, df, newdf = df, tol = 1e-4) {
    opts <- options(contrasts = c(unordered = "contr.sum", ordered = "contr.poly"))
  
    model <- object

    # drop unused factor levels
    facs <- which(sapply(df, is.factor))
    df[facs] <- lapply(df[facs], function(x) x[drop=TRUE])

    # quick fix for problems predicting with smooths...
    # this will fail in some instances when covariates are included, 
    olddf <- df
    df <- unique(df)
  
    model.type <- deparse(substitute(model))
  
    # step 1 - separate out elements
    facs <- strsplit(as.character(model)[length(model)], "[+]")[[1]]
    facs <- gsub("(^ )|( $)", "", facs) # remove leading and trailing spaces

    # some 'model builder' functions.  Here for now, but maybe move them somewhere else later
    # note they use df through their scope - so moving might be troublesome
    # they just need to return a character version of the formula element they code for
    trawl <- function(plateau, selectivity = "fixed", ...) {
      selectivity <- match.arg(selectivity, c("fixed","variable"))
      
      # implement plateau and calculate appropriate degrees of freedom for age
      if (missing(plateau)) {
        ka <- ceiling(0.5 * length(unique(df $ age)))
        var <- "age"
      } else {
        ka <- ceiling(0.5 * length(unique(replace(df $ age, df $ age > plateau, plateau))))
        var <- paste("replace(age, age >", plateau, ",", plateau, ")")
      }

      # apply a fixed or evolving selec
... [truncated] ...
 Repository: <https://github.com/flr/FLa4a/>
- Bug reports: <https://github.com/flr/FLa4a/issues>


[![FLa4a status badge](https://flr.r-universe.dev/badges/FLa4a)](https://flr.r-universe.dev/FLa4a)
![GitHub issues](https://img.shields.io/github/issues/flr/FLa4a)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/flr/FLa4a)

## Overview
FLa4a implements the Assesment For All (a4a) initiative stock assessment model, a simple and robust statistical catch-at-age model.

## Installation
To install this package, start R and enter:

    install.packages(c("copula","triangle", "coda"))

followed by

	install.packages("FLa4a", repos=c(FLR="https://flr.r-universe.dev", CRAN="https://cloud.r-project.org"))

## Documentation
- [Help pages](http://www.flrproject.org/FLa4a/reference/index.html)
- [Vignettes](http://www.flrproject.org/FLa4a/articles/index.html)

## References
- [Jardim, et.al, 2014](http://icesjms.oxfordjournals.org/content/early/2014/04/03/icesjms.fsu050.abstract)
- [Millar, et.al, 2014](http://icesjms.oxfordjournals.org/content/early/2014/03/31/icesjms.fsu043.abstract) 
- [Scott, et.al, 2016](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0154922)

## License
Copyright (c) 2012-2022 European Union. European Commission Joint Research Centre D.02. Released under the [EUPL 1.1](https://joinup.ec.europa.eu/community/eupl/home).

## Contact
You are welcome to:

- Submit suggestions and bug-reports at: <https://github.com/flr/FLa4a/issues>
```

## 7. 

```sh
grep -n "copula\|triangle\|rtriangle\|mvdc\|rMvdc" NAMESPACE R/*.R | head; DEBIAN_FRONTEND=noninteractive apt-get install -y -qq r-cran-coda r-cran-latticeextra r-cran-gridextra r-cran-mgcv >/dev/null 2>&1; echo $?; cat /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/be637uu28.output
```

Output:

```
NAMESPACE:4:import("triangle")
NAMESPACE:5:importFrom("copula",
NAMESPACE:8:  rMvdc,
NAMESPACE:9:  mvdc)
NAMESPACE:131:exportMethods(mvrtriangle)
R/FLModelSimMethods.R:2:#' @title Simulation with a copula model and triangular distributions
R/FLModelSimMethods.R:3:#' @description Simulates model parameters using elliptical copulas and triangular marginals.
R/FLModelSimMethods.R:6:#' @param ... arguments to be passed to the rMvdc and copula methods
R/FLModelSimMethods.R:8:#' @rdname mvrtriangle
R/FLModelSimMethods.R:25:#'   vbSim1 <- mvrtriangle(10000, vb)
0
```

## 8. 

```sh
S=/tmp/claude-0/ref; rm -rf $S; mkdir -p $S && cd /home/user/FLa4a && git archive master | tar -x -C $S && cd $S && sed -i '/^import("triangle")/d; /^importFrom("copula",/,/mvdc)/d' NAMESPACE && sed -i 's/^  triangle$//; s/^  copula,$//; s/  FLCore (>= 2.6.15),/  FLCore (>= 2.6.15)/' DESCRIPTION && grep -n -A12 "^Imports" DESCRIPTION && rm -f R/FLModelSimMethods.R && sed -i "/'FLModelSimMethods.R'/d" DESCRIPTION && sed -i '/mvrtriangle/d' NAMESPACE; head -12 NAMESPACE
```

Output:

```
14:Imports:
15-  methods,
16-  lattice,
17-  Matrix,
18-
19-  coda,
20-  grid,
21-  gridExtra,
22-  latticeExtra,
23-  mgcv
24-Depends:
25-  R (>= 4.0),
26-  FLCore (>= 2.6.15)
import("methods")
import("FLCore")
import("mgcv")
importFrom("graphics",
  abline, axis, legend, mtext, par)
importFrom("lattice",
  qqmath, panel.xyplot, panel.abline, prepanel.qqmathline, panel.qqmathline,
  panel.qqmath, panel.grid, panel.polygon, panel.segments)
importFrom("Matrix",
  bdiag,Diagonal,Matrix)
importClassesFrom("Matrix",
  dsCMatrix,Matrix)
Shell cwd was reset to /home/user/FLa4a
```

## 9. 

```sh
cd /tmp/claude-0/ref && sed -i '/^$/d' DESCRIPTION; grep -n "triangle\|copula\|FLModelSim\|mvrtriangle\|mvrcop" NAMESPACE R/*.R | head
```

Output:

```
NAMESPACE:123:exportMethods(mvrcop)
R/a4aGr-methods.R:45:	args$mu <- FLModelSim(model=grInvMod(mu), params=params(mu), vcov=vcov(mu), distr=distr(mu))
R/a4aGr-methods.R:52:#' @title mvrtriangle 
R/a4aGr-methods.R:53:#' @name mvrtriangle for a4aGr 
R/a4aGr-methods.R:54:#' @rdname mvrtriangle-a4aGr
R/a4aGr-methods.R:55:#' @aliases mvrtriangle,numeric,a4aGr-method
R/a4aGr-methods.R:56:#' @description Method to generate multivariate parameters with elliptical copulas and triangular marginals for \code{a4aGr} objects.
R/a4aGr-methods.R:59:#' @details The method is essentially a special case of \code{mvrcop}, where the copula is of type "ellipCopula" and family "t", and where the marginals are triangular.
R/a4aGr-methods.R:72:#' # Note that mvrtriangle is a special case of mvrcop
R/a4aGr-methods.R:74:#' vbObj1 <- mvrtriangle(10000, vbObj, paramMargins=pars, dispstr="ex", param=0)
Shell cwd was reset to /home/user/FLa4a
```

## 10. 

```sh
cd /tmp/claude-0/ref && sed -i '/mvrcop/d' NAMESPACE && python3 - <<'EOF'
import re
p='R/a4aGr-methods.R'
s=open(p).read()
# drop setMethod blocks for mvrtriangle / mvrcop
out=[];skip=0
for blk in re.split(r'\n(?=#\' @title|setMethod|setGeneric)', s):
    if re.search(r'set(Method|Generic)\("(mvrtriangle|mvrcop)"', blk): continue
    out.append(blk)
open(p,'w').write('\n'.join(out))
EOF
grep -n "mvr" R/*.R | grep -v "^R/[^:]*:[0-9]*:#" | head
```

Output:

```
R/a4aGr-methods.R:43:setMethod("mvrnorm", signature("numeric", "a4aGr"), function(n=1, mu) {
R/a4aGr-methods.R:47:	res <- do.call("mvrnorm", args)	
R/a4aM-methods.R:175:setMethod("mvrnorm", c(n="numeric", mu="a4aM", Sigma="missing",
R/a4aM-methods.R:180:	if(!is.empty(vcov(args$mu))) params(shape(mu)) <- params(do.call("mvrnorm", args))	
R/a4aM-methods.R:183:	if(!is.empty(vcov(args$mu))) params(level(mu)) <- params(do.call("mvrnorm", args))	
R/a4aM-methods.R:186:	if(!is.empty(vcov(args$mu))) params(trend(mu)) <- params(do.call("mvrnorm", args))	
R/gen-methods.R:105:    flq <- mvrnorm(niter * dim(mu)[2], rep(0, nrow(Rho)), log(cv^2+1) * Rho)
R/gen-methods.R:324:        flq <- mvrnorm(niter * dim(mu)[2], rep(0, nrow(Rho)), log(cv^2+1) * Rho)
R/internal.R:161:mvrEmpT <- function(n, mu, Sigma, tol = 1e-6, empirical=TRUE){
R/internal.R:164:			mm <- mvrnorm(n, mu, Sigma, tol=tol, empirical=T)
Shell cwd was reset to /home/user/FLa4a
```

## 11. 

```sh
sed -n 1,80p R/addition-methods.R; sed -n 1,80p R/a4aFit-class.R | grep -v "^#'"
```

Output:

```
#==================================================================== 
# "+" methods
#==================================================================== 

#' + methods
#' @name addition
#' @description Update \code{FLStock} and \code{FLIndex} objects with stock assessment results.
#' @param e1 the original \code{FLStock} or \code{FLIndex} object
#' @param e2 a \code{a4aFit} object from where the new \code{FLStock} or \code{FLIndex} slots will be extracted.
#' @details If both objects have the same number of iterations, the \code{FLStock} slots will be replaced by the \code{a4aFit} slots, in the case of 1 iter, or \code{a4aFitSA} slots, in the case of n iters. If one of the objects has 1 iter and the other n, the method will simulate using the fit results from the \code{a4aFitSA} object to update the slots of the \code{FLStock} object.
#' @rdname addition-methods
#' @aliases +,FLStock,a4aFit-method +,FLIndices,a4aFit-method
setMethod("+", c("FLStock", "a4aFit"), function(e1, e2)
{

  nit1 <- dims(e1)$iter
  nit2 <- dims(e2)$iter
  if(nit1>nit2) {
	e2 <- propagate(e2, nit1)
  } else if(nit1<nit2){
  	e1 <- propagate(e1, nit2)
  }

  stock.n(e1) <- stock.n(e2)
  landings.n(e1) <- landings.n(e1) * (catch.n(e2)/catch.n(e1))
  discards.n(e1) <- discards.n(e1) * (catch.n(e2)/catch.n(e1))
  catch.n(e1) <- catch.n(e2)
  harvest(e1) <- harvest(e2)
  
  catch(e1) <- computeCatch(e1, na.rm=FALSE)
  stock(e1) <- computeStock(e1, na.rm=FALSE)
  landings(e1) <- computeLandings(e1, na.rm=FALSE)
  discards(e1) <- computeDiscards(e1, na.rm=FALSE)
  
  e1
})

setMethod("+", c("FLIndices", "a4aFit"), function(e1, e2) 
{

  #niters <- dims(e1) $ iter
  #if (niters > 1) stop("adding a basic a4aFit object only makes sence with 1 iteration")

  for (i in seq(FLIndices)) {
    index(e1[[i]]) <- index(e2)[[i]]
    #catch.n(e1[[i]]) <- index(e1[[i]]) * effort(e1[[1]])
    #index.q(e1[[1]])
    #sel.pattern(e1[[1]]) 
    #??index.var(e1[[1]])
  }
    
  e1
})


#' + methods
#' @name addition
... [truncated] ...
1")

	# set same sizes
	n <- max(ns, nf)
	if(n>1 & ns==1){ 
		e1[1:n] <- e1[1]
		names(e1) <- rep(names(e1[1]), n)
		} else if(n>1 & nf==1){
		e2[1:n] <- e2[1]
		names(e2) <- rep(names(e2[1]), n)
		}

a4aFit <-
  setClass("a4aFit",
           contains = "FLComp",
           slots = c(call    = "call",
                     clock   = "numeric",
                     fitSumm = "array",
                     stock.n = "FLQuant",
                     harvest = "FLQuant",
                     catch.n = "FLQuant",
                     index   = "FLQuants"))

setGeneric("a4aFit")
 
setMethod("initialize", "a4aFit",
    function(.Object,
             ...,
             call, clock, fitSumm,
             stock.n, harvest, catch.n, index) {
      if (!missing(call)) .Object@call <- call
      if (!missing(clock)) .Object@clock   <- clock
      if (!missing(fitSumm)) .Object@fitSumm <- fitSumm
      if (!missing(stock.n)) .Object@stock.n <- stock.n
      if (!missing(harvest)) .Object@harvest <- harvest
      if (!missing(catch.n)) .Object@catch.n <- catch.n
      if (!missing(index)) .Object@index   <- index
      .Object <- callNextMethod(.Object, ...)
      .Object
    })

setValidity("a4aFit",
  function(object) {
    # All FLQuant objects must have same dimensions
    if (any(dim(object@harvest) != dim(object@stock.n)) ||
        any(dim(object@catch.n) != dim(object@stock.n)))
      "stock.n, catch.n and harvest slots must have same dimensions"
    else # Everything is fine
      TRUE
```

## 12. 

```sh
cd /tmp/claude-0/RTMB && git -c advice.detachedHead=false checkout -q v1.7 && MAKEFLAGS=-j8 R CMD INSTALL --no-docs --no-multiarch -l ~/Rlib RTMB > ../rtmb.log 2>&1; echo $?; tail -2 ../rtmb.log
```

Output:

```
Command running in background with ID: bk4nebi5j. Output is being written to: /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/bk4nebi5j.output. You will be notified when it completes. To check interim output, use Read on that file path.
Session cwd remains /home/user/FLa4a; directory changes made by the backgrounded command do not apply to subsequent commands.
```

## 13. 

```sh
mkdir -p /tmp/claude-0/reflib && cd /tmp/claude-0 && R CMD INSTALL --no-docs --no-test-load -l /tmp/claude-0/reflib ref > ref.log 2>&1; echo $?; tail -5 ref.log
```

Output:

```
1
  no existing definition for function 'pars2dim'
Error: unable to load R code in package 'FLa4a'
Execution halted
ERROR: lazy loading failed for package 'FLa4a'
* removing '/tmp/claude-0/reflib/FLa4a'
Shell cwd was reset to /home/user/FLa4a
```

## 14. 

```sh
cd /tmp/claude-0/ref && grep -n "pars2dim" R/*.R | head -3; grep -n "pars2dim" /tmp/claude-0/FLCore/R/*.R | head -3; grep -n "pars2dim" NAMESPACE
```

Output:

```
R/a4aGr-class.R:6:	v <- c(pars2dim(pars), grep("len", deparse(object@grInvMod)))
R/a4aM-class.R:8:	v1 <- c(level=pars2dim(lvl), shape=pars2dim(shp), trend=pars2dim(trd))
R/utilities.R:36:#' @rdname pars2dim-methods
128:exportMethods(pars2dim)
Shell cwd was reset to /home/user/FLa4a
```

## 15. 

```sh
cd /tmp/claude-0/ref && sed -i 's/^setMethod("pars2dim", "FLPar"/setGeneric("pars2dim", function(object, ...) standardGeneric("pars2dim"))\nsetMethod("pars2dim", "FLPar"/' R/utilities.R && cd .. && R CMD INSTALL --no-docs -l /tmp/claude-0/reflib ref > ref.log 2>&1; echo $?; grep -i "error" ref.log | head -5; tail -2 ref.log
```

Output:

```
0
** testing if installed package keeps a record of temporary installation path
* DONE (FLa4a)
Shell cwd was reset to /home/user/FLa4a
```

## 16. 

```sh
cd /tmp/claude-0 && cat > refrun.R <<'EOF'
.libPaths(c("/tmp/claude-0/reflib", .libPaths()))
suppressMessages(library(FLa4a))
data(ple4); data(ple4.index)
fit <- sca(ple4, ple4.index, fmodel=~factor(age)+factor(year), qmodel=list(~factor(age)), fit="assessment")
print(fitSumm(fit))
print(coef(fit)@stkmodel[1:5])
EOF
Rscript refrun.R 2>&1 | tail -30
```

Output:

```
                       iters
                                    1
  nopar                  1.480000e+02
  nlogl                 -1.012501e+02
  maxgrad                1.682387e-05
  nobs                   8.300000e+02
  gcv                    5.469390e-02
  convergence            0.000000e+00
  accrate                          NA
  nlogl fraction: comp1  6.177178e-01
  nlogl fraction: comp2  3.822822e-01
Error in h(simpleError(msg, call)) : 
  error in evaluating the argument 'x' in selecting a method for function 'print': no applicable method for `@` applied to an object of class "list"
Calls: print -> .handleSimpleError -> h
Execution halted
Shell cwd was reset to /home/user/FLa4a
```

## 17. 

```sh
cd /home/user/FLa4a/rtmb && sed -i 's/(Mesnil and Rochet, gamma = 0.05)/(Mesnil and Rochet, gamma = 0.1)/' R/srmodels.R; cat /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/bk4nebi5j.output
```

Output:

```
(Bash completed with no output)
```

## 18. 

```sh
cat /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/bk4nebi5j.output; cd /tmp/claude-0 && Rscript -e '
library(RTMB)
X <- matrix(rnorm(12),6,2); M <- rnorm(6)
f <- function(p) { "[<-" <- ADoverload("[<-")
  e <- X %*% p$b; Z <- exp(e) + M
  m <- matrix(Z, 3, 2)
  N <- matrix(0, 3, 2); N[1,] <- m[1,]; N[-1,1] <- m[-3,1]; N[3,2] <- logspace_add(N[3,1], m[3,2])
  s <- colSums(exp(m))
  REPORT(N)
  sum(s) + sum(N) + sum(dnorm(M, e[1:6], exp(p$b[1]), log=TRUE))
}
obj <- MakeADFun(f, list(b=c(0.1,0.2)), silent=TRUE)
print(obj$fn()); print(obj$gr()); print(obj$he()); print(obj$report()$N)
S <- Matrix::Matrix(X, sparse=TRUE)
g <- function(p) sum(exp(S %*% p$b)); o2 <- MakeADFun(g, list(b=c(.1,.2)), silent=TRUE); print(o2$gr())
'
```

Output:

```
0
** testing if installed package keeps a record of temporary installation path
* DONE (RTMB)

[exited with code 0]
[1] 18.48138
         [,1]      [,2]
[1,] 2.978984 -17.73586
          [,1]      [,2]
[1,]  27.03470 -13.61422
[2,] -13.61422  28.39172
         [,1]     [,2]
[1,] 1.151672 1.128488
[2,] 1.151672 0.000000
[3,] 1.437656 1.734376
         [,1]      [,2]
[1,] 1.878633 -3.131031
Shell cwd was reset to /home/user/FLa4a
```

## 19. 

```sh
cd /tmp/claude-0 && Rscript -e 'suppressMessages(library(FLCore)); for (g in c("stock.n","catch.n","harvest","index","coef","vcov","logLik","fitSumm","AIC","BIC","nobs")) cat(g, isGeneric(g), if (isGeneric(g)) paste(names(formals(getGeneric(g))), collapse=","), environmentName(environment(get(g))), "\n")' 2>&1
```

Output:

```
Exit code 1
stock.n TRUE object,...  
catch.n TRUE object,...  
harvest TRUE object,catch,...  
index TRUE object,...  
coef TRUE object,... stats 
vcov TRUE object,...  
logLik TRUE object,...  
Error in get(g) : object 'fitSumm' not found
Calls: cat -> environmentName -> environment -> get
Execution halted
```

## 20. 

```sh
cat > R/FLa4a-package.R <<'EOF'
#' FLa4a: a simple and robust statistical catch-at-age model
#'
#' Minimal implementation of the a4a stock assessment model using 'RTMB'.
#' The main function is [sca()].
#'
#' @import methods FLCore
#' @importFrom stats dnorm
#' @keywords internal
"_PACKAGE"
EOF
sed -i "s/^Collate:/Collate:\n  'FLa4a-package.R'/" DESCRIPTION
Rscript -e 'roxygen2::roxygenise()' 2>&1 | tail -15; cat NAMESPACE
```

Output:

```
First time using roxygen2. Upgrading automatically...
Setting `RoxygenNote` to "7.3.1"
i Loading FLa4a
Loading required package: FLCore
Loading required package: lattice
FLCore (Version 2.6.33, packaged: Tue Sep 29 16:08:55 2026)
Writing 'NAMESPACE'
Writing 'FLa4a-package.Rd'
Writing 'getX.Rd'
Writing 'breakpts.Rd'
Writing 'srmodels.Rd'
Writing 'defaultSubmodels.Rd'
Writing 'a4aFit-class.Rd'
Writing 'addition.Rd'
Writing 'sca.Rd'
# Generated by roxygen2: do not edit by hand

export(bevholt)
export(bevholtSV)
export(breakpts)
export(defaultFmod)
export(defaultN1mod)
export(defaultQmod)
export(defaultSRmod)
export(defaultVmod)
export(fitSumm)
export(geomean)
export(getX)
export(hockey)
export(ricker)
export(sca)
exportClasses(a4aFit)
exportMethods("+")
exportMethods(catch.n)
exportMethods(coef)
exportMethods(fitSumm)
exportMethods(harvest)
exportMethods(index)
exportMethods(logLik)
exportMethods(stock.n)
exportMethods(vcov)
import(FLCore)
import(methods)
importFrom(stats,dnorm)
```

## 21. 

```sh
sed -i 's/\bdnorm(/RTMB::dnorm(/g' R/model.R && sed -i "/@importFrom stats dnorm/d" R/FLa4a-package.R && grep -n "dnorm" R/model.R && Rscript -e 'roxygen2::roxygenise()' >/dev/null 2>&1 && R CMD INSTALL --no-docs -l ~/Rlib . > /tmp/claude-0/inst.log 2>&1; echo $?; tail -3 /tmp/claude-0/inst.log
```

Output:

```
64:  nllObs <- -dat$w * RTMB::dnorm(dat$obs, pred, sdObs, log = TRUE)
91:    nllSR <- -sum(RTMB::dnorm(logN[1, yrs], predLogR, sqrt(log(dat$srCV^2 + 1)), log = TRUE))
0
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (FLa4a)
```

## 22. 

```sh
cd /tmp/claude-0 && cat > cmp.R <<'EOF'
args <- commandArgs(TRUE)
lib <- if (args[1] == "ref") "/tmp/claude-0/reflib" else "~/Rlib"
.libPaths(c(lib, .libPaths()))
suppressMessages(library(FLa4a))
data(ple4); data(ple4.indices); data(ple4.index)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
bidx <- as(ple4.index, "FLIndexBiomass"); index(bidx) <- quantSums(index(ple4.index) * stock.wt(ple4)[1:10, ac(1996:2017)]); range(bidx)[c("startf","endf")] <- c(0.6, 0.7)
cases <- list(
  sep   = list(ple4, ple4.index, fmodel=~factor(age)+factor(year), qmodel=list(~factor(age))),
  smth  = list(ple4, idx, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4), ~s(age,k=3))),
  deflt = list(ple4, idx),
  bh    = list(ple4, ple4.index, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4)), srmodel=~bevholt(CV=0.3)),
  gm    = list(ple4, ple4.index, fmodel=~te(age,year,k=c(4,15)), qmodel=list(~s(age,k=4)), srmodel=~geomean(CV=0.5)),
  bio   = list(ple4, FLIndices(a=ple4.index, b=bidx), fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4), ~1))
)
res <- lapply(names(cases), function(n) {
  t <- system.time(fit <- suppressWarnings(do.call(sca, cases[[n]])))[3]
  s <- fitSumm(fit)
  data.frame(case=n, nopar=s["nopar",1], nlogl=s["nlogl",1], ssb2017=c(ssb(ple4+fit)[, "2017"]),
             fbar2017=c(fbar(ple4+fit)[, "2017"]), rec2017=c(stock.n(fit)[1, "2017"]), idxb=c(index(fit)[[length(index(fit))]][1,"2000"]), sec=t)
})
print(do.call(rbind, res), digits = 7, row.names = FALSE)
EOF
echo ADMB; Rscript cmp.R ref 2>&1 | tail -8; echo RTMB; Rscript cmp.R new 2>&1 | tail -8
```

Output:

```
ADMB
  case nopar      nlogl   ssb2017  fbar2017 rec2017     idxb   sec
   sep   148 -101.25012  656304.2 0.1455042 2283111 49680.75 2.266
  smth   100  351.80156  518838.6 0.1939408 1485931 22734.10 1.782
 deflt   260 -624.66877  745435.7 0.1993708 3009136 17613.53 6.848
    bh    98   34.79643  551430.1 0.1813140 1275109 50229.07 1.257
    gm   133 -233.21555 1157691.8 0.1448450 1527549 42539.66 1.701
   bio    98  -31.57419  620375.5 0.1599622 1798191 10299.46 1.522
RTMB
Error in advector(e2) : 
  Invalid argument to 'advector' (lost class attribute?)
Calls: lapply -> lapply -> FUN -> system.time
Timing stopped at: 0.593 0.024 0.62
Execution halted
Shell cwd was reset to /home/user/FLa4a
```

## 23. 

```sh
cd /tmp/claude-0 && Rscript -e 'suppressMessages(library(FLa4a)); data(ple4); data(ple4.index); options(error=function() traceback(3)); fit <- sca(ple4, ple4.index, fmodel=~factor(age)+factor(year), qmodel=list(~factor(age)))' 2>&1 | tail -20
```

Output:

```
           dims(x)$iter))))
       data <- a4aData(stk, idx, fmodel = fmodel, qmodel = qmodel, 
           vmodel = vmodel, n1model = n1model, srmodel = srmodel, 
           covar = covar, center = center)
       res <- fitA4a(data, fit = fit, verbose = verbose, control = control)
       c(res, list(data = data, quants = predictQuants(res, data, 
           stk, idx)))
   })
2: lapply(seq_len(nit), function(i) {
       stk <- iter(stock, min(i, d$iter))
       idx <- FLIndices(lapply(indices, function(x) iter(x, min(i, 
           dims(x)$iter))))
       data <- a4aData(stk, idx, fmodel = fmodel, qmodel = qmodel, 
           vmodel = vmodel, n1model = n1model, srmodel = srmodel, 
           covar = covar, center = center)
       res <- fitA4a(data, fit = fit, verbose = verbose, control = control)
       c(res, list(data = data, quants = predictQuants(res, data, 
           stk, idx)))
   })
1: sca(ple4, ple4.index, fmodel = ~factor(age) + factor(year), qmodel = list(~factor(age)))
Shell cwd was reset to /home/user/FLa4a
```

## 24. 

```sh
cd /tmp/claude-0 && Rscript -e 'suppressMessages(library(FLa4a)); data(ple4); data(ple4.index); d <- FLa4a:::a4aData(ple4, FLIndices(a=ple4.index), ~factor(age)+factor(year), list(~factor(age)), defaultVmod(ple4, FLIndices(a=ple4.index)), defaultN1mod(ple4), ~factor(year)); r <- tryCatch(RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, silent=TRUE), error=function(e) {print(sys.calls()); e}); print(r)' 2>&1 | grep -v "^\[\[" | tail -30
```

Output:

```
tryCatch(RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), 
    d$par, silent = TRUE), error = function(e) {
    print(sys.calls())
    e
})

tryCatchList(expr, classes, parentenv, handlers)

tryCatchOne(expr, names, parentenv, handlers[[1L]])

value[[3L]](cond)

<simpleError in advector(e2): Invalid argument to 'advector' (lost class attribute?)>
Shell cwd was reset to /home/user/FLa4a
```

## 25. 

```sh
cd /tmp/claude-0 && Rscript -e 'suppressMessages(library(FLa4a)); data(ple4); data(ple4.index); d <- FLa4a:::a4aData(ple4, FLIndices(a=ple4.index), ~factor(age)+factor(year), list(~factor(age)), defaultVmod(ple4, FLIndices(a=ple4.index)), defaultN1mod(ple4), ~factor(year)); withCallingHandlers(RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, silent=TRUE), error=function(e) {cs <- sys.calls(); for (c in tail(cs, 8)) print(deparse(c)[1])})' 2>&1 | tail -12
```

Output:

```
[1] "func(pl)"
[1] "FLa4a:::a4aNll(p, d$dat)"
[1] "Ops.advector(logN[-nA, y - 1], Z[-nA, y - 1])"
[1] "Arith2(advector(e1), advector(e2), .Generic)"
[1] "advector(e2)"
[1] "stop(\"Invalid argument to 'advector' (lost class attribute?)\")"
[1] ".handleSimpleError(function (e) "
[1] "h(simpleError(msg, call))"
Error in advector(e2) : 
  Invalid argument to 'advector' (lost class attribute?)
Calls: withCallingHandlers ... func -> <Anonymous> -> Ops.advector -> Arith2 -> advector
Execution halted
Shell cwd was reset to /home/user/FLa4a
```

## 26. 

```sh
cd /tmp/claude-0 && Rscript -e 'library(RTMB); M <- matrix(1,3,2); f <- function(p){ F <- exp(matrix(p$b, 3, 2)); Z <- F + M; print(class(Z)); print(class(Z[-3,1])); z2 <- M + F; print(class(z2)); sum(Z[-3,1]) }; o <- MakeADFun(f, list(b=rep(.1,6)), silent=TRUE)' 2>&1 | tail
```

Output:

```
[1] "advector"
[1] "advector"
[1] "advector"
Shell cwd was reset to /home/user/FLa4a
```

## 27. 

```sh
cd /home/user/FLa4a/rtmb && sed -i "s/^#' @import methods FLCore$/#' @import methods FLCore\n#' @importFrom RTMB MakeADFun ADoverload REPORT dnorm logspace_add matrix colSums/" R/FLa4a-package.R && sed -i 's/RTMB::\(dnorm\|logspace_add\|REPORT\|ADoverload\|MakeADFun\)/\1/g' R/model.R && grep -n "RTMB" R/*.R | grep -v "^R/FLa4a-package" ; Rscript -e 'roxygen2::roxygenise()' >/dev/null 2>&1; grep RTMB NAMESPACE; R CMD INSTALL --no-docs -l ~/Rlib . > /tmp/claude-0/inst.log 2>&1; echo $?; cd /tmp/claude-0 && Rscript cmp.R new 2>&1 | tail -8
```

Output:

```
R/data.R:78:  # data list for the RTMB model
R/model.R:1:# The a4a statistical catch-at-age model as an RTMB objective function.
R/sca.R:9:#' The model is written in R and differentiated with 'RTMB'. Each iteration
importFrom(RTMB,ADoverload)
importFrom(RTMB,MakeADFun)
importFrom(RTMB,REPORT)
importFrom(RTMB,colSums)
importFrom(RTMB,dnorm)
importFrom(RTMB,logspace_add)
importFrom(RTMB,matrix)
0
Error in names(par) <- data$pnames : 
  'names' attribute [150] must be the same length as the vector [148]
Calls: lapply -> lapply -> FUN -> system.time
Timing stopped at: 0.568 0.006 0.586
Execution halted
Shell cwd was reset to /home/user/FLa4a
```

## 28. 

```sh
cd /home/user/FLa4a/rtmb && python3 - <<'EOF'
p='R/data.R'
s=open(p).read()
old=s[s.index("  pnames <- c(\n"):s.index("  list(dat = dat, par = par")]
new='''  pn <- function(prefix, X) if (ncol(X)) paste0(prefix, colnames(X)) else character(0)
  pnames <- c(
    pn("fMod:", X$f),
    unlist(lapply(fleets[-1], function(f) pn(paste0("qMod:", f, ":"), X$q[[f]]))),
    unlist(lapply(fleets, function(f) pn(paste0("vMod:", f, ":"), X$v[[f]]))),
    pn("n1Mod:", X$n1),
    pn("rMod:", X$r),
    pn("sraMod:", X$sra),
    pn("srbMod:", X$srb)
  )

'''
s=s.replace(old,new)
open(p,'w').write(s)
EOF
R CMD INSTALL --no-docs -l ~/Rlib . > /tmp/claude-0/inst.log 2>&1; echo $?; cd /tmp/claude-0 && Rscript cmp.R new 2>&1 | tail -8
```

Output:

```
0
  case nopar      nlogl   ssb2017  fbar2017 rec2017     idxb   sec
   sep   148 -101.25012  656300.3 0.1455051 2283097 49680.87 0.952
  smth   100  351.80156  518838.5 0.1939410 1485934 22734.14 0.496
 deflt   260 -631.98746  906711.4 0.1674532 1148038 17865.39 5.549
    bh    98   34.79643  551429.9 0.1813140 1275110 50229.03 0.482
    gm   133 -233.21555 1157687.0 0.1448457 1527541 42539.68 0.531
   bio    98  -31.57419  620375.3 0.1599621 1798195 10299.48 0.467
Shell cwd was reset to /home/user/FLa4a
```

## 29. 

```sh
cd /tmp/claude-0 && cat > dflt.R <<'EOF'
args <- commandArgs(TRUE)
.libPaths(c(if (args[1] == "ref") "/tmp/claude-0/reflib" else "~/Rlib", .libPaths()))
suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
fit <- sca(ple4, ple4.indices[c("BTS-Combined (all)", "SNS")])
print(fitSumm(fit)[1:6,])
print(fit@call$fmodel); print(defaultFmod(ple4))
EOF
Rscript dflt.R ref 2>&1 | tail -9; Rscript dflt.R new 2>&1 | tail -9
```

Output:

```
        nopar         nlogl       maxgrad          nobs           gcv 
 2.600000e+02 -6.246688e+02  7.566148e-05  1.123000e+03  1.086148e-01 
  convergence 
 0.000000e+00 
NULL
~te(age, year, k = c(6, 30), bs = "tp") + s(age, k = 6)
<environment: 0x5580b68715a8>
       nopar        nlogl      maxgrad         nobs  convergence  nlogl:catch 
  260.000000  -631.987464     0.100396  1123.000000     0.000000 -1098.687729 
NULL
~te(age, year, k = c(6, 30), bs = "tp") + s(age, k = 6)
<environment: 0x55876671b8c8>
Shell cwd was reset to /home/user/FLa4a
```

## 30. 

```sh
cd /tmp/claude-0 && cat > dbg.R <<'EOF'
suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]; names(idx) <- c("a","b")
d <- FLa4a:::a4aData(ple4, idx, defaultFmod(ple4), defaultQmod(idx), defaultVmod(ple4, idx), defaultN1mod(ple4), ~factor(year))
obj <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, silent=TRUE)
opt <- nlminb(obj$par, obj$fn, obj$gr, control=list(eval.max=1e4, iter.max=1e4))
cat(opt$message, opt$objective, max(abs(obj$gr(opt$par))), "\n")
p <- opt$par
for (i in 1:6) { H <- obj$he(p); g <- drop(obj$gr(p)); p <- p - solve(H, g); cat(i, obj$fn(p), max(abs(obj$gr(p))), "\n") }
e <- eigen(obj$he(p), only.values=TRUE)$values; cat("cond", max(e)/min(e), "min eig", min(e), "\n")
EOF
Rscript dbg.R 2>&1 | tail -10
```

Output:

```
relative convergence (4) -631.9875 0.100396 
1 -631.9875 9.00512e-06 
2 -631.9875 8.273663e-08 
3 -631.9875 1.0159e-07 
4 -631.9875 6.088153e-08 
5 -631.9875 1.077631e-07 
6 -631.9875 5.041119e-08 
cond 13235674098 min eig 0.08263829
Shell cwd was reset to /home/user/FLa4a
```

## 31. 

```sh
cd /home/user/FLa4a/rtmb && sed -i 's/nlogl = obj$fn(par), maxgrad = max(abs(obj$gr(par))),/nlogl = obj$fn(par), maxgrad = maxgrad(par),/' R/model.R && grep -n "maxgrad" R/model.R && R CMD INSTALL --no-docs -l ~/Rlib . > /tmp/claude-0/inst.log 2>&1; cd /tmp/claude-0 && Rscript cmp.R new 2>&1 | tail -7; Rscript dflt.R new 2>&1 | sed -n 2p
```

Output:

```
113:  maxgrad <- function(p) max(abs(obj$gr(p)))
116:    if (is.null(step) || !is.finite(obj$fn(par - step)) || maxgrad(par - step) >= maxgrad(par)) break
135:       nlogl = obj$fn(par), maxgrad = maxgrad(par),
  case nopar      nlogl   ssb2017  fbar2017 rec2017     idxb   sec
   sep   148 -101.25012  656304.3 0.1455042 2283110 49680.81 1.255
  smth   100  351.80156  518838.2 0.1939410 1485932 22734.11 0.649
 deflt   260 -631.98746  906712.5 0.1674533 1148030 17865.39 6.751
    bh    98   34.79643  551429.9 0.1813140 1275110 50229.03 0.548
    gm   133 -233.21555 1157692.6 0.1448452 1527549 42539.61 0.816
   bio    98  -31.57419  620375.0 0.1599621 1798191 10299.47 0.613
 2.600000e+02 -6.319875e+02  8.273663e-08  1.123000e+03  0.000000e+00
Shell cwd was reset to /home/user/FLa4a
```

## 32. 

```sh
cd /tmp/claude-0 && cat > se.R <<'EOF'
args <- commandArgs(TRUE)
.libPaths(c(if (args[1] == "ref") "/tmp/claude-0/reflib" else "~/Rlib", .libPaths()))
suppressMessages(library(FLa4a)); data(ple4); data(ple4.index)
fit <- sca(ple4, ple4.index, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4)))
if (args[1] == "ref") { v <- fit@pars@stkmodel@vcov[,,1]; p <- fit@pars@stkmodel@coefficients[,1] } else { v <- vcov(fit)[,,1]; p <- coef(fit)[,1] }
i <- grep("fMod", names(diag(v)))[1:5]
print(round(cbind(est=c(p[i]), se=sqrt(diag(v))[i]), 6))
EOF
Rscript se.R ref 2>&1 | tail -6; Rscript se.R new 2>&1 | tail -6
```

Output:

```
                       est       se
fMod:(Intercept) -1.036095 0.025431
fMod:s(age).1    -0.227985 0.051228
fMod:s(age).2     0.882464 0.132656
fMod:s(age).3     1.789784 0.182402
fMod:s(age).4     0.305301 0.056650
                       est       se
fMod:(Intercept) -1.036095 0.025431
fMod:s(age).1    -0.227985 0.051228
fMod:s(age).2     0.882464 0.132656
fMod:s(age).3     1.789784 0.182402
fMod:s(age).4     0.305301 0.056650
Shell cwd was reset to /home/user/FLa4a
```

## 33. 

```sh
cd /home/user/FLa4a/rtmb && cat > tests/testthat.R <<'EOF'
library(testthat)
library(FLa4a)

test_check("FLa4a")
EOF
cat > tests/testthat/setup.R <<'EOF'
data(ple4, package = "FLCore", envir = environment())
data(ple4.index, package = "FLCore", envir = environment())
data(ple4.indices, package = "FLCore", envir = environment())
EOF
cat > tests/testthat/test-sca.R <<'EOF'
# Reference negative log-likelihoods were produced with the ADMB
# implementation of FLa4a 1.9.7 on the same data and submodels.

fmod <- ~ s(age, k = 5) + s(year, k = 20)
qmod <- list(~ s(age, k = 4))

test_that("separable model matches the ADMB implementation", {
  fit <- sca(ple4, ple4.index, fmodel = ~ factor(age) + factor(year),
             qmodel = list(~ factor(age)))
  expect_s4_class(fit, "a4aFit")
  expect_equal(fitSumm(fit)["nopar", 1], 148)
  expect_equal(fitSumm(fit)["nlogl", 1], -101.25012, tolerance = 1e-6)
  expect_equal(fitSumm(fit)["convergence", 1], 0)
  expect_lt(fitSumm(fit)["maxgrad", 1], 1e-4)
})

test_that("stock-recruitment models match the ADMB implementation", {
  bh <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, srmodel = ~ bevholt(CV = 0.3))
  expect_equal(fitSumm(bh)["nlogl", 1], 34.79643, tolerance = 1e-6)
  expect_true("nlogl:srr" %in% rownames(fitSumm(bh)))

  gm <- sca(ple4, ple4.index, fmodel = ~ te(age, year, k = c(4, 15)), qmodel = qmod,
            srmodel = ~ geomean(CV = 0.5))
  expect_equal(fitSumm(gm)["nlogl", 1], -233.21555, tolerance = 1e-6)
})

test_that("biomass indices match the ADMB implementation", {
  bidx <- as(ple4.index, "FLIndexBiomass")
  index(bidx) <- quantSums(index(ple4.index) * stock.wt(ple4)[1:10, ac(1996:2017)])
  range(bidx)[c("startf", "endf")] <- c(0.6, 0.7)
  fit <- sca(ple4, FLIndices(a = ple4.index, b = bidx), fmodel = fmod, qmodel = list(qmod[[1]], ~ 1))
  expect_equal(fitSumm(fit)["nlogl", 1], -31.57419, tolerance = 1e-6)
  expect_equal(dimnames(index(fit)$b)$age, "all")
})

test_that("fitted quantities are consistent", {
  fit <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod)
  expect_equal(dim(stock.n(fit)), dim(stock.n(ple4)))
  expect_equal(dimnames(index(fit)[[1]]), dimnames(index(ple4.index)))
  Z <- harvest(fit) + m(ple4)
  expect_equal(catch.n(fit), harvest(fit) / Z * (1 - exp(-Z)) * stock.n(fit))
  # survivors: N[a+1, y+1] = N[a, y] exp(-Z[a, y]) away from the plus group
  expect_equal(c(stock.n(fit)[2:9, -1]), c((stock.n(fit) * exp(-Z))[1:8, -dims(fit@stock.n)$year]))

  stk <- ple4 + fit
  expect_equal(stock.n(stk), stock.n(fit))
  expect_equal(harvest(stk), harvest(fit))
  expect_equal(c(catch(stk)), c(quantSums(catch.n(fit) * catch.wt(ple4))))

  expect_equal(dim(vcov(fit))[1:2], rep(fitSumm(fit)["nopar", 1], 2))
  expect_false(anyNA(vcov(fit)))
  expect_equal(c(AIC(fit)), 2 * fitSumm(fit)["nopar", 1] + 2 * fitSumm(fit)["nlogl", 1])
})

test_that("fit = 'MP' skips the covariance matrix", {
  fit <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, fit = "MP")
  expect_true(all(is.na(vcov(fit))))
  expect_false(anyNA(stock.n(fit)))
})

test_that("iterations are fitted independently", {
  stk <- propagate(ple4, 2)
  catch.n(stk)[, , , , , 2] <- catch.n(stk)[, , , , , 2] * 1.1
  fit <- sca(stk, ple4.index, fmodel = fmod, qmodel = qmod, fit = "MP")
  fit1 <- sca(ple4, ple4.index, fmodel = fmod, qmodel = qmod, fit = "MP")
  expect_equal(dims(stock.n(fit))$iter, 2)
  expect_equal(ncol(fitSumm(fit)), 2)
  expect_equal(c(stock.n(fit)[, , , , , 1]), c(stock.n(fit1)), tolerance = 1e-6)
  expect_false(isTRUE(all.equal(c(stock.n(fit)[, , , , , 1]), c(stock.n(fit)[, , , , , 2]))))

  expect_error(sca(stk, propagate(ple4.index, 3), fmodel = fmod, qmodel = qmod),
               "inconsistent number of iterations")
})

test_that("covariates can be used in submodels", {
  temp <- FLQuant(seq(-1, 1, length = dims(ple4)$year), dimnames = list(year = dimnames(ple4)$year))
  fit <- sca(ple4, ple4.index, fmodel = fmod, qmodel = list(~ s(age, k = 4) + temp),
             covar = list(temp = temp), fit = "MP")
  expect_true("qMod:index:temp" %in% dimnames(coef(fit))$params)
})

test_that("default submodels run", {
  fit <- sca(ple4, ple4.indices[c("BTS-Combined (all)", "SNS")], fit = "MP")
  expect_equal(fitSumm(fit)["convergence", 1], 0)
  expect_equal(names(index(fit)), c("BTS-Combined (all)", "SNS"))
})
EOF
cat > tests/testthat/test-getX.R <<'EOF'
df <- expand.grid(age = 1:10, year = 2000:2019)

test_that("getX builds factor and smoother designs", {
  X <- getX(~ factor(age), df)
  expect_equal(dim(X), c(200, 10))

  X <- getX(~ s(age, k = 4) + s(year, k = 6), df)
  expect_equal(dim(X), c(200, 9))
})

test_that("getX removes redundant columns", {
  expect_warning(X <- getX(~ factor(age) + factor(age):factor(year > 2000) , df[df$year > 2010, ]),
                 "redundant")
  expect_equal(qr(X)$rank, ncol(X))
})

test_that("duplicated rows do not change the smoother basis", {
  clamped <- transform(df, age = pmin(age, 6))
  X1 <- getX(~ s(age, k = 4), clamped)
  X2 <- getX(~ s(age, k = 4), unique(clamped[c("age")]))
  expect_equal(X1[!duplicated(clamped$age), ], X2, ignore_attr = TRUE)
})

test_that("breakpts cuts at the breakpoints", {
  expect_equal(levels(breakpts(2000:2010, 2005)), c("(1999,2005]", "(2005,2010]"))
})

test_that("srmodel parsing separates SR relationships from recruitment formulas", {
  expect_null(FLa4a:::parseSRmodel(~ s(year, k = 10))$sr)
  expect_equal(FLa4a:::parseSRmodel(~ bevholt(CV = 0.2))$sr$ID, 1L)
  expect_error(FLa4a:::parseSRmodel(~ bevholt() + year), "only term")
  expect_error(bevholt(CV = -1), "positive")
})
EOF
R CMD INSTALL --no-docs -l ~/Rlib . > /tmp/claude-0/inst.log 2>&1; Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -30
```

Output:

```
  4. |     +-testthat (local) .capture(...)
  5. |     | \-base::withCallingHandlers(...)
  6. |     \-rlang::eval_bare(quo_get_expr(.quo), quo_get_env(.quo))
  7. \-FLa4a::getX(...)
  8.   +-stats::model.matrix(formula, udf) at rtmb/R/formula.R:32:5
  9.   \-stats::model.matrix.default(formula, udf)
 10.     \-stats::`contrasts<-`(`*tmp*`, value = contr.funs[1 + isOF[nn]])

-- 2. Failure ('test-sca.R:41:3'): fitted quantities are consistent ------------
catch.n(fit) (`actual`) not equal to harvest(fit)/Z * (1 - exp(-Z)) * stock.n(fit) (`expected`).

`actual@units`:   "1000"
`expected@units`: "NA"  

-- 3. Error ('test-sca.R:77:3'): covariates can be used in submodels -----------
Error in `data.frame(age = df$age, year = as.numeric(as.character(df$year)), 
    value = df$data)`: arguments imply differing number of rows: 0, 61
Backtrace:
    x
 1. \-FLa4a::sca(...) at test-sca.R:77:3
 2.   +-base::lapply(...) at rtmb/R/sca.R:64:3
 3.   \-base::lapply(...)
 4.     \-FLa4a (local) FUN(X[[i]], ...)
 5.       \-FLa4a:::a4aData(...) at rtmb/R/sca.R:67:5
 6.         \-FLa4a:::addCovariates(...) at rtmb/R/data.R:44:3
 7.           \-base::data.frame(...) at rtmb/R/data.R:160:5

== DONE ========================================================================
Error: Test failures
Execution halted
```

## 34. 

```sh
python3 - <<'EOF'
p='R/data.R'; s=open(p).read()
s=s.replace("""    df <- data.frame(age = df$age, year = as.numeric(as.character(df$year)), value = df$data)""","""    df <- data.frame(age = df[[1]], year = as.numeric(as.character(df$year)), value = df$data)""")
open(p,'w').write(s)
p='tests/testthat/test-getX.R'; s=open(p).read()
s=s.replace("""getX(~ factor(age) + factor(age):factor(year > 2000) , df[df$year > 2010, ])""","""getX(~ age + I(2 * age) + year, df)""")
open(p,'w').write(s)
p='tests/testthat/test-sca.R'; s=open(p).read()
s=s.replace("""  expect_equal(catch.n(fit), harvest(fit) / Z * (1 - exp(-Z)) * stock.n(fit))""","""  expect_equal(c(catch.n(fit)), c(harvest(fit) / Z * (1 - exp(-Z)) * stock.n(fit)))""")
open(p,'w').write(s)
EOF
R CMD INSTALL --no-docs -l ~/Rlib . > /tmp/claude-0/inst.log 2>&1; Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -15
```

Output:

```
getX: ..........
sca: ...........................1..

== Failed ======================================================================
-- 1. Failure ('test-sca.R:79:3'): covariates can be used in submodels ---------
"qMod:index:temp" %in% dimnames(coef(fit))$params is not TRUE

`actual`:   FALSE
`expected`: TRUE 

== DONE ========================================================================
Error: Test failures
Execution halted
```

## 35. 

```sh
Rscript -e 'suppressMessages(library(FLa4a)); data(ple4); data(ple4.index); temp <- FLQuant(seq(-1, 1, length = dims(ple4)$year), dimnames = list(year = dimnames(ple4)$year)); fit <- sca(ple4, ple4.index, fmodel = ~ s(age, k = 5) + s(year, k = 20), qmodel = list(~ s(age, k = 4) + temp), covar = list(temp = temp), fit = "MP"); print(grep("qMod", dimnames(coef(fit))$params, value=TRUE)); print(names(index(fit)))' 2>&1 | tail -5
```

Output:

```
[1] "qMod:BTS-Combined (all):(Intercept)" "qMod:BTS-Combined (all):temp"       
[3] "qMod:BTS-Combined (all):s(age).1"    "qMod:BTS-Combined (all):s(age).2"   
[5] "qMod:BTS-Combined (all):s(age).3"   
[1] "BTS-Combined (all)"
```

## 36. 

```sh
sed -i 's/expect_true("qMod:index:temp" %in% dimnames(coef(fit))$params)/expect_true(any(grepl("^qMod:.*:temp$", dimnames(coef(fit))$params)))/' tests/testthat/test-sca.R && Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -4
```

Output:

```
sca: ..............................

== DONE ========================================================================
Keep up the good work.
```

## 37. 

```sh
cat > README.md <<'EOF'
# FLa4a (RTMB)

A minimal re-implementation of the [a4a](https://github.com/flr/FLa4a)
statistical catch-at-age model. The model is written in plain R and
differentiated with [RTMB](https://github.com/kaskr/RTMB), with no ADMB
executable and no C++ template.

## Installation

```r
install.packages(c("RTMB", "mgcv"))
install.packages("FLCore", repos = "https://flr.r-universe.dev")
remotes::install_github("colinpmillar/FLa4a", ref = "claude/peaceful-babbage-if9ubk", subdir = "rtmb")
```

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
EOF
cat > NEWS.md <<'EOF'
# FLa4a 2.0.0.9000

* Minimal rewrite: the model is implemented in R with RTMB, replacing the
  ADMB executable.
* `sca()` returns a single `a4aFit` class holding estimates, coefficients,
  covariance and fit summary; `fit = "assessment"` or `"MP"`.
* Dropped: MCMC, simulation/prediction, diagnostics, natural mortality,
  growth and length-to-age tools.
EOF
printf '^README\\.md$\n^NEWS\\.md$\n' > .Rbuildignore
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "warn\|writ"; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build --no-build-vignettes /home/user/FLa4a/rtmb >/dev/null 2>&1 && _R_CHECK_FORCE_SUGGESTS_=false R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A6 | head -60
```

Output:

```
* checking R files for syntax errors ... WARNING
Warning in Sys.setlocale("LC_CTYPE", "en_US.UTF-8") :
  OS reports request to set locale to "en_US.UTF-8" cannot be honored
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
--
* checking for missing documentation entries ... WARNING
Undocumented S4 methods:
  generic '+' and siglist 'FLStock,a4aFit'
All user-level objects in a package (including S4 classes and methods)
should have documentation entries.
See chapter 'Writing R documentation files' in the 'Writing R
Extensions' manual.
--
* checking Rd \usage sections ... WARNING
Undocumented arguments in documentation object 'a4aFit-class'
  'catch'

Objects in \usage without \alias in documentation object 'addition':
  '\S4method{+}{FLStock,a4aFit}'

--
Status: 3 WARNINGs
See
  '/tmp/claude-0/chk/FLa4a.Rcheck/00check.log'
for details.
Shell cwd was reset to /home/user/FLa4a
```

## 38. 

```sh
cd /home/user/FLa4a/rtmb && python3 - <<'EOF'
p='R/a4aFit-class.R'; s=open(p).read()
s=s.replace("""#' @name addition
#' @export
setMethod("+", c("FLStock", "a4aFit")""","""#' @name addition
#' @aliases +,FLStock,a4aFit-method
#' @export
setMethod("+", c("FLStock", "a4aFit")""")
s=s.replace("""#' @param object an `a4aFit`.
#' @param ... not used.""","""#' @param object an `a4aFit`.
#' @param catch,... not used.""")
open(p,'w').write(s)
EOF
Rscript -e 'roxygen2::roxygenise()' >/dev/null 2>&1; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a/rtmb >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A6 | head -30
```

Output:

```
Status: OK
Shell cwd was reset to /home/user/FLa4a
```

## 39. 

```sh
cd /home/user/FLa4a/rtmb && sed -n 1,100p R/model.R; wc -l R/*.R
```

Output:

```
# The a4a statistical catch-at-age model as an RTMB objective function.
#
# Linear predictors (log scale) come from the submodel design matrices:
#   log F    = Xf  %*% fpar     (age x year)
#   log q    = Xq  %*% qpar     (age x year, one block per index)
#   log sd   = Xv  %*% vpar     (age x year, one block per fleet)
#   log N1   = Xn1 %*% n1par    (first year, ages 2+)
#   log R    = Xr  %*% rpar     (first age, all years)
# Observations are lognormal. An optional stock-recruitment relationship
# adds a lognormal penalty on recruitment around the curve.
a4aNll <- function(par, dat) {
  "[<-" <- ADoverload("[<-")
  nA <- dat$nA
  nY <- dat$nY
  nC <- nA * nY

  #------------------------------------------------------------------
  # submodels
  #------------------------------------------------------------------
  logF <- matrix(dat$Xf %*% par$fpar, nA, nY)
  logQ <- dat$Xq %*% par$qpar
  logV <- dat$Xv %*% par$vpar
  M <- matrix(dat$M, nA, nY)
  F <- exp(logF)
  Z <- F + M

  #------------------------------------------------------------------
  # population
  #------------------------------------------------------------------
  logN <- matrix(0, nA, nY)
  logN[1, ] <- dat$Xr %*% par$rpar
  if (nA > 1) {
    logN[-1, 1] <- dat$Xn1 %*% par$n1par
    for (y in seq_len(nY)[-1]) {
      logN[-1, y] <- logN[-nA, y - 1] - Z[-nA, y - 1]
      if (dat$plusgroup)
        logN[nA, y] <- logspace_add(logN[nA, y], logN[nA, y - 1] - Z[nA, y - 1])
    }
  }

  #------------------------------------------------------------------
  # predicted observations
  #------------------------------------------------------------------
  fleet <- dat$fleet
  cell <- (dat$iy - 1) * nA + dat$ia
  pred <- numeric(length(dat$obs))

  isC <- fleet == 1
  pred[isC] <- logF[cell[isC]] - log(Z[cell[isC]]) + log(1 - exp(-Z[cell[isC]])) + logN[cell[isC]]

  isS <- !isC & !dat$biomass
  s <- fleet[isS] - 1
  pred[isS] <- logQ[(s - 1) * nC + cell[isS]] - Z[cell[isS]] * dat$stime[s] + logN[cell[isS]]

  
... [truncated] ...
---------------------------------------------
  if (dat$srID > 0) {
    ssb <- colSums(exp(logN - F * matrix(dat$fspwn, nA, nY) - M * matrix(dat$mspwn, nA, nY)) *
                     matrix(dat$matWt, nA, nY))
    # recruits in year y come from the ssb in year y - age of recruitment
    lag <- if (dat$srID == 4) 1 else dat$srAge
    yrs <- seq(1 + lag, nY)
    S <- if (dat$srID != 4) ssb[yrs - dat$srAge]
    a <- (dat$Xsra %*% par$rapar)[yrs]
    b <- if (length(par$rbpar)) (dat$Xsrb %*% par$rbpar)[yrs] else 0
    predLogR <- switch(dat$srID,
      a + log(S) - log(exp(b) + S),                                           # bevholt
      a + log(S) - exp(b) * S,                                                # ricker
      a + log(S + sqrt(exp(2 * b) + 0.0025) - sqrt((S - exp(b))^2 + 0.0025)), # hockey
      a,                                                                      # geomean
      {                                                                       # bevholtSV
        h <- 0.2 + 0.8 / (1 + exp(-a))
        v <- exp(b)
        log(6 * h * v * S) - log(dat$spr0 * ((h + 1) * v + (5 * h - 1) * S))
      })
    nllSR <- -sum(dnorm(logN[1, yrs], predLogR, sqrt(log(dat$srCV^2 + 1)), log = TRUE))
    nllComp[dat$nS + 2] <- nllSR
  }

  REPORT(logF)
  REPORT(logN)
  REPORT(logQ)
  REPORT(nllComp)
  sum(nllComp)
}
    9 R/FLa4a-package.R
  107 R/a4aFit-class.R
  181 R/data.R
   52 R/defaults.R
   69 R/formula.R
  137 R/model.R
  142 R/sca.R
   64 R/srmodels.R
  761 total
```

## 40. 

```sh
cd /tmp/claude-0 && cat > sr.R <<'EOF'
args <- commandArgs(TRUE)
.libPaths(c(if (args[1] == "ref") "/tmp/claude-0/reflib" else "~/Rlib", .libPaths()))
suppressMessages(library(FLa4a)); data(ple4); data(ple4.index)
for (sr in c(~ricker(CV=0.3), ~hockey(CV=0.3), ~bevholtSV(CV=0.3, SPR0=2)))
  cat(deparse(sr), fitSumm(suppressWarnings(sca(ple4, ple4.index, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4)), srmodel=sr)))[c("nlogl","convergence"),1], "\n")
EOF
Rscript sr.R ref 2>&1 | tail -3; Rscript sr.R new 2>&1 | tail -3
```

Output:

```
~ricker(CV = 0.3) 33.46262 0 
~hockey(CV = 0.3) 33.82151 0 
~bevholtSV(CV = 0.3, SPR0 = 2) NA 1 
~ricker(CV = 0.3) 33.46262 0 
~hockey(CV = 0.3) 33.70215 0 
~bevholtSV(CV = 0.3, SPR0 = 2) 124.5848 0
Shell cwd was reset to /home/user/FLa4a
```

## 41. 

```sh
cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && ls && LANG=C.UTF-8 LC_ALL=C.UTF-8 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status|tests" -A4 | head -20
```

Output:

```
FLa4a_2.0.0.9000.tar.gz
* checking for unstated dependencies in ‘tests’ ... OK
* checking tests ...
  Running ‘testthat.R’
 OK
* DONE

Status: OK
Shell cwd was reset to /home/user/FLa4a
```

## 42. 

```sh
mkdir -p /home/user/FLa4a/.devcontainer && cd /home/user/FLa4a/.devcontainer && cat > Dockerfile <<'EOF'
# R development environment for FLa4a (RTMB)
FROM rocker/r-ver:4.5

# system libraries needed to build R packages from source
RUN apt-get update && apt-get install -y --no-install-recommends \
      git libxml2-dev libcurl4-openssl-dev libssl-dev libfontconfig1-dev \
      libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# package dependencies (CRAN binaries come from Posit Package Manager via rocker's defaults)
RUN install2.r --error --skipinstalled --ncpus -1 \
      RTMB mgcv Matrix testthat roxygen2 devtools languageserver httpgd \
    && rm -rf /tmp/downloaded_packages

# FLCore from the FLR r-universe
RUN Rscript -e 'install.packages("FLCore", repos = c(FLR = "https://flr.r-universe.dev", CRAN = getOption("repos")))' \
    && Rscript -e 'library(FLCore); library(RTMB)'
EOF
cat > devcontainer.json <<'EOF'
{
  "name": "FLa4a (RTMB)",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "REditorSupport.r"
      ],
      "settings": {
        "r.plot.useHttpgd": true
      }
    }
  },
  "postCreateCommand": "R CMD INSTALL --no-docs .",
  "remoteUser": "root"
}
EOF
cd .. && printf '^\\.devcontainer$\n' >> .Rbuildignore && python3 -c "import json;json.load(open('.devcontainer/devcontainer.json'))" && echo json ok; docker info >/dev/null 2>&1 && echo docker-ok || echo no-daemon
```

Output:

```
json ok
no-daemon
```

## 43. 

```sh
git rm -q .devcontainer/Dockerfile && cat > .devcontainer/devcontainer.json <<'EOF'
{
  "name": "FLa4a (RTMB)",
  // Prebuilt Rocker image: R 4.5, compilers, the R language server and the
  // VS Code R extension. Nothing is built locally.
  "image": "ghcr.io/rocker-org/devcontainer/r-ver:4.5",
  // Installs package dependencies (binaries from Posit Package Manager) and FLa4a
  "postCreateCommand": "Rscript .devcontainer/setup.R"
}
EOF
cat > .devcontainer/setup.R <<'EOF'
# Run once when the dev container is created.
# CRAN packages come as Linux binaries from Posit Package Manager (the
# default repository in Rocker images); FLCore comes from the FLR r-universe.

options(Ncpus = parallel::detectCores())
repos <- c(FLR = "https://flr.r-universe.dev", getOption("repos"))

install.packages(c("RTMB", "mgcv", "Matrix", "testthat", "roxygen2", "devtools", "FLCore"),
                 repos = repos)

# install FLa4a itself so that library(FLa4a) works straight away
install.packages(".", repos = NULL, type = "source")
EOF
printf '* text=auto eol=lf\n*.rda binary\n*.png binary\n' > .gitattributes
printf '^\\.gitattributes$\n' >> .Rbuildignore
python3 - <<'EOF'
p='README.md'; s=open(p).read()
old=s[s.index("### Dev container"):s.index("## Usage")]
new="""### Dev container

The `.devcontainer/` folder uses the prebuilt
[Rocker](https://rocker-project.org) image `ghcr.io/rocker-org/devcontainer/r-ver:4.5`,
so nothing is built locally (this works with Docker Desktop on Windows). Open
the repository in VS Code and choose *Dev Containers: Reopen in Container*, or
open it in GitHub Codespaces. On first start `.devcontainer/setup.R` installs
RTMB, FLCore, mgcv, testthat, roxygen2 and devtools from binaries and installs
FLa4a. Then:

```r
devtools::load_all()   # or devtools::test(), devtools::check()
```

On Windows, `.gitattributes` keeps line endings as LF inside the container.

"""
open(p,'w').write(s.replace(old,new))
EOF
git add -A && git status --short
```

Output:

```
M  .Rbuildignore
D  .devcontainer/Dockerfile
M  .devcontainer/devcontainer.json
A  .devcontainer/setup.R
A  .gitattributes
M  README.md
```

## 44. 

```sh
git add --renormalize . && git status --short | wc -l && Rscript -e 'install.packages(".", repos = NULL, type = "source", lib = "~/Rlib")' 2>&1 | tail -1
```

Output:

```
6
* DONE (FLa4a)
```

## 45. 

```sh
git commit -q -m "Use a prebuilt Rocker image for the dev container

Replace the Dockerfile with ghcr.io/rocker-org/devcontainer/r-ver:4.5 so
nothing is built locally (e.g. Docker Desktop on Windows). Dependencies
are installed from binaries by .devcontainer/setup.R on creation, and
.gitattributes keeps LF line endings.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git push origin claude/peaceful-babbage-if9ubk 2>&1 | tail -1
```

Output:

```
   45d6223..cd129c8  claude/peaceful-babbage-if9ubk -> claude/peaceful-babbage-if9ubk
```

## 46. 

```sh
cd /tmp/claude-0 && Rscript -e 'suppressMessages(library(FLCore)); data(ple4.indices); for (n in names(ple4.indices)) cat(n, class(ple4.indices[[n]]), unlist(dims(ple4.indices[[n]])[c("min","max","minyear","maxyear")]), range(ple4.indices[[n]])[c("startf","endf")], "\n"); data(ple4); print(range(ple4)); cat(sapply(c("ggplot2","ggplotFL","lattice"), requireNamespace, quietly=TRUE))' 2>&1 | tail -12
```

Output:

```
BTS-Isis-early FLIndex 1 9 1985 1995 0.66 0.75 
BTS-Combined (ISIS and TRIDENS) FLIndex 1 9 1996 2017 0.66 0.75 
SNS FLIndex 1 7 1970 2017 0.66 0.75 
BTS-Combined (all) FLIndex 1 10 1996 2017 0.6453376 0.6453376 
IBTS_Q3 FLIndex 1 10 1996 2017 0.6278328 0.6278328 
IBTS_Q1 FLIndex 1 8 2007 2017 0.1038277 0.1038277 
      min       max plusgroup   minyear   maxyear   minfbar   maxfbar 
        1        10        10      1957      2017         2         6 
TRUE FALSE TRUE
Shell cwd was reset to /home/user/FLa4a
```

## 47. 

```sh
sed -i 's/srmodel = bquote(~ bevholt(CV = .(cv)))))/srmodel = eval(bquote(~ bevholt(CV = .(cv))))))/' examples/04-stock-recruitment.R && mkdir -p /tmp/claude-0/ex && for f in 01 02 03 04; do s=$(ls examples/$f-*.R); ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); t0 <- Sys.time(); source('$s', echo=FALSE, max.deparse.length=1e4); cat('TIME', format(Sys.time()-t0), '\n')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?"; grep -E "Error|Warning|TIME" /tmp/claude-0/ex/$f.log | head -5 ) & done; wait; ls /tmp/claude-0/ex | tr '\n' ' '
```

Output:

```
01 exit 0
TIME 14.29707 secs 
[1]   Done                    ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); t0 <- Sys.time(); source('$s', echo=FALSE, max.deparse.length=1e4); cat('TIME', format(Sys.time()-t0), '\n')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?"; grep -E "Error|Warning|TIME" /tmp/claude-0/ex/$f.log | head -5 )
03 exit 0
TIME 18.39478 secs 
04 exit 0
TIME 22.36883 secs 
02 exit 0
TIME 22.59005 secs 
[2]   Done                    ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); t0 <- Sys.time(); source('$s', echo=FALSE, max.deparse.length=1e4); cat('TIME', format(Sys.time()-t0), '\n')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?"; grep -E "Error|Warning|TIME" /tmp/claude-0/ex/$f.log | head -5 )
[3]-  Done                    ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); t0 <- Sys.time(); source('$s', echo=FALSE, max.deparse.length=1e4); cat('TIME', format(Sys.time()-t0), '\n')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?"; grep -E "Error|Warning|TIME" /tmp/claude-0/ex/$f.log | head -5 )
[4]+  Done                    ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); t0 <- Sys.time(); source('$s', echo=FALSE, max.deparse.length=1e4); cat('TIME', format(Sys.time()-t0), '\n')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?"; grep -E "Error|Warning|TIME" /tmp/claude-0/ex/$f.log | head -5 )
01-01.png 01-02.png 01-03.png 01-04.png 01.log 02-01.png 02-02.png 02-03.png 02-04.png 02-05.png 02.log 03-01.png 03-02.png 03.log 04-01.png 04.log
```

## 48. 

```sh
cd /home/user/FLa4a/examples && python3 - <<'EOF'
import re,glob
for p in sorted(glob.glob('0*.R')):
    lines=open(p).read().split('\n'); out=[]
    for l in lines:
        if re.match(r'^(fitTable|coefTable|fitSumm|sapply\(srfits|fit0$|fit1$|fit0@models|harvest\(fit1\)|stock\.n\(fit1\)|head\(coef|dim\(vcov|names\(ple4|ple4$)', l):
            l='print('+l+')'
        out.append(l)
    open(p,'w').write('\n'.join(out))
EOF
grep -n "^print(\|^system.time" 0*.R | cut -c1-110
```

Output:

```
01-getting-started.R:17:print(ple4)
01-getting-started.R:18:print(names(ple4.indices))
01-getting-started.R:29:print(fit0)
01-getting-started.R:32:print(fit0@models$fmodel)
01-getting-started.R:33:print(fit0@models$qmodel)
01-getting-started.R:46:print(fit1)
01-getting-started.R:49:print(harvest(fit1)[, ac(2010:2017)])
01-getting-started.R:50:print(stock.n(fit1)[, "2017"])
01-getting-started.R:53:print(head(coef(fit1)))
01-getting-started.R:54:print(dim(vcov(fit1)))
01-getting-started.R:80:print(fitSumm(fit1))
01-getting-started.R:81:print(fitTable(list(default = fit0, "te(age, year)" = fit1)))
01-getting-started.R:88:system.time(fitMP <- sca(ple4, indices, fmodel = ~ te(age, year, k = c(5, 20)), fit = 
02-smoothers.R:39:print(fitTable(ffits))
02-smoothers.R:64:print(fitTable(qfits))
02-smoothers.R:88:print(fitTable(rfits))
03-covariates.R:20:print(coefTable <- function(fit, pattern) {)
03-covariates.R:56:print(coefTable(fitTemp, "temp")   # simulated covariate: expect no clear effect)
03-covariates.R:61:print(coefTable(fitWt, "wtAnomaly"))
03-covariates.R:73:print(fitTable(list(base = fitBase, "+ temp" = fitTemp, "+ wtAnomaly" = fitWt,)
03-covariates.R:82:print(coefTable(fitF, "temp"))
03-covariates.R:88:print(coefTable(fitR, "temp"))
03-covariates.R:98:print(coefTable(fitBreak, "breakpts"))
03-covariates.R:99:print(fitTable(list(base = fitBase, "SNS q break in 1995" = fitBreak)))
04-stock-recruitment.R:30:print(sapply(srfits, function(f) round(fitSumm(f)[grep("nlogl", rownames(fitSumm(f))
```

## 49. 

```sh
python3 - <<'EOF'
p='03-covariates.R'; s=open(p).read()
s=s.replace('print(coefTable <- function(fit, pattern) {)','coefTable <- function(fit, pattern) {')
s=s.replace('print(coefTable(fitTemp, "temp")   # simulated covariate: expect no clear effect)','print(coefTable(fitTemp, "temp"))   # simulated covariate: expect no clear effect')
s=s.replace('print(fitTable(list(base = fitBase, "+ temp" = fitTemp, "+ wtAnomaly" = fitWt,)\n              "+ s(wtAnomaly)" = fitWtSmooth, "+ s(age, by = wtAnomaly)" = fitWtByAge))',
 'print(fitTable(list(base = fitBase, "+ temp" = fitTemp, "+ wtAnomaly" = fitWt,\n                    "+ s(wtAnomaly)" = fitWtSmooth, "+ s(age, by = wtAnomaly)" = fitWtByAge)))')
open(p,'w').write(s)
p='01-getting-started.R'; s=open(p).read()
s=s.replace('system.time(fitMP','print(system.time(fitMP').replace('fit = "MP"))\n','fit = "MP")))\n') if s.endswith('\n') else s
open(p,'w').write(s)
EOF
tail -1 01-getting-started.R; sed -n 28,32p 04-stock-recruitment.R; for f in 0*.R; do Rscript -e "invisible(parse('$f'))" || echo BAD $f; done
```

Output:

```
print(system.time(fitMP <- sca(ple4, indices, fmodel = ~ te(age, year, k = c(5, 20)), fit = "MP")))
# The SR penalty is an extra likelihood component (nlogl:srr), so compare
# the data components rather than the totals
print(sapply(srfits, function(f) round(fitSumm(f)[grep("nlogl", rownames(fitSumm(f))), 1], 2)))

# Recruitment against the SSB that produced it (recruits are age 1)
```

## 50. 

```sh
cd /home/user/FLa4a && rm -f /tmp/claude-0/ex/*; for f in 01 02 03 04; do s=$(ls examples/$f-*.R); ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); source('$s')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?" ) & done; wait; grep -il "error\|warn" /tmp/claude-0/ex/*.log; sed -n '/npar/,/^$/p' /tmp/claude-0/ex/02.log; cat /tmp/claude-0/ex/03.log | tail -45
```

Output:

```
01 exit 0
[1]   Done                    ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); source('$s')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?" )
03 exit 0
04 exit 0
02 exit 0
[2]   Done                    ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); source('$s')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?" )
[3]-  Done                    ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); source('$s')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?" )
[4]+  Done                    ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); source('$s')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?" )
/tmp/claude-0/ex/01.log
                                 npar   nlogl     AIC    dAIC      BIC    dBIC
te(age, year, k = c(5, 20))       178  -9.050 337.900   0.000 1232.129 112.750
s(age) + s(year) + ti(age, year)  123 127.729 501.457 163.557 1119.379   0.000
te(age, year, k = c(4, 10))       118 184.431 604.862 266.962 1197.665  78.286
factor(age) + factor(year)        148 282.835 861.670 523.770 1605.187 485.807
s(age) + s(year)                  102 345.992 895.984 558.084 1408.407 289.028
                                 maxgrad converged
te(age, year, k = c(5, 20))            0         1
s(age) + s(year) + ti(age, year)       0         1
te(age, year, k = c(4, 10))            0         1
factor(age) + factor(year)             0         1
s(age) + s(year)                       0         1
                npar   nlogl     AIC    dAIC      BIC    dBIC maxgrad converged
~ s(age, k = 5)  179  -9.058 339.884   0.000 1239.137  16.825       0         1
~ s(age, k = 3)  175  -3.423 343.154   3.270 1222.312   0.000       0         1
~ factor(age)    186 -10.932 350.136  10.252 1284.555  62.243       0         1
~ 1 (flat)       171 274.089 890.177 550.293 1749.240 526.928       0         1
                npar   nlogl      AIC   
... [truncated] ...
olt, bevholtSV, geomean, ricker

                             estimate    se      z
qMod:BTS-Combined (all):temp   -0.166 0.058 -2.886
                                  estimate    se      z
qMod:BTS-Combined (all):wtAnomaly   -0.717 0.198 -3.621
qMod:SNS:wtAnomaly                   0.013 0.283  0.045
                         npar   nlogl     AIC   dAIC      BIC  dBIC maxgrad
+ s(age, by = wtAnomaly)  181 -19.579 322.842  0.000 1232.143 1.508       0
+ s(wtAnomaly)            181 -19.238 323.525  0.682 1232.825 2.190       0
+ wtAnomaly               180 -16.502 326.996  4.154 1231.273 0.638       0
+ temp                    179 -13.309 331.382  8.540 1230.635 0.000       0
base                      178  -9.050 337.900 15.058 1232.129 1.494       0
                         converged
+ s(age, by = wtAnomaly)         1
+ s(wtAnomaly)                   1
+ wtAnomaly                      1
+ temp                           1
base                             1
          estimate    se     z
fMod:temp    0.012 0.024 0.488
          estimate   se     z
rMod:temp    0.104 0.05 2.086
                               estimate    se     z
qMod:SNS:breakpts(year, 1995)1    0.436 0.058 7.545
                    npar   nlogl     AIC   dAIC      BIC   dBIC maxgrad
SNS q break in 1995  179 -37.415 283.169  0.000 1182.422  0.000       0
base                 178  -9.050 337.900 54.731 1232.129 49.707       0
                    converged
SNS q break in 1995         1
base                        1
```

## 51. 

```sh
cd /home/user/FLa4a/examples && python3 - <<'EOF'
p='01-getting-started.R'; s=open(p).read()
s=s.replace('print(ple4)\n','summary(ple4)\n'); open(p,'w').write(s)
p='04-stock-recruitment.R'; s=open(p).read()
s=s.replace('print(sapply(srfits, function(f) round(fitSumm(f)[grep("nlogl", rownames(fitSumm(f))), 1], 2)))',
'''comps <- paste0("nlogl:", c("catch", names(indices), "srr"))
print(sapply(srfits, function(f) round(fitSumm(f)[, 1][comps], 2)))''')
open(p,'w').write(s)
p='03-covariates.R'; s=open(p).read()
s=s.replace('print(coefTable(fitTemp, "temp"))   # simulated covariate: expect no clear effect',
'''print(coefTable(fitTemp, "temp"))
# Note: temp is random noise, yet it may look "significant". The base model's
# residuals are correlated in time, so standard errors are optimistic and a
# trending covariate can soak up misfit. Test covariates with a hypothesis,
# not by trawling.''')
open(p,'w').write(s)
EOF
cd .. && Rscript -e "png('/tmp/claude-0/ex/04-%02d.png', width=900, height=650, res=110); source('examples/04-stock-recruitment.R')" 2>&1 | tail -6; Rscript -e "png('/tmp/claude-0/ex/01-%02d.png', width=900, height=650, res=110); source('examples/01-getting-started.R')" > /tmp/claude-0/ex/01.log 2>&1; wc -l < /tmp/claude-0/ex/01.log; grep -c Warning /tmp/claude-0/ex/01.log
```

Output:

```
                            free geomean bevholt  ricker  hockey
nlogl:catch              -473.92 -473.55 -473.62 -473.53 -473.55
nlogl:BTS-Combined (all)   73.77   75.89   75.45   76.46   75.89
nlogl:SNS                 391.09  389.36  389.78  388.88  389.36
<NA>                          NA   42.24   42.14   43.07   42.24
63000
1
```

## 52. 

```sh
python3 - <<'EOF'
p='R/a4aFit-class.R'; s=open(p).read()
s=s.replace('setMethod("show", "a4aFit"', "#' @rdname a4aFit-class\n#' @export\nsetMethod(\"show\", \"a4aFit\"",1)
open(p,'w').write(s)
p='examples/04-stock-recruitment.R'; s=open(p).read()
s=s.replace('print(sapply(srfits, function(f) round(fitSumm(f)[, 1][comps], 2)))',
'''tab <- sapply(srfits, function(f) round(fitSumm(f)[, 1][comps], 2))
rownames(tab) <- comps
print(tab)''')
open(p,'w').write(s)
EOF
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i writ; grep show NAMESPACE; R CMD INSTALL --no-docs -l ~/Rlib . >/dev/null 2>&1; Rscript -e "png('/tmp/claude-0/ex/01-%02d.png', width=900, height=650, res=110); source('examples/01-getting-started.R')" > /tmp/claude-0/ex/01.log 2>&1; wc -l < /tmp/claude-0/ex/01.log; sed -n '/a4aFit:/,/^$/p' /tmp/claude-0/ex/01.log | head -12; tail -12 /tmp/claude-0/ex/01.log
```

Output:

```
Writing 'NAMESPACE'
Writing 'a4aFit-class.Rd'
exportMethods(show)
63000
  nlogl:SNS                 3.910926e+02
              npar    nlogl      AIC     dAIC      BIC    dBIC maxgrad
default        260 -631.987 -743.975    0.000  562.202   0.000       0
te(age, year)  178   -9.050  337.900 1081.875 1232.129 669.927       0
              converged
default               1
te(age, year)         1
   user  system elapsed 
  1.823   0.000   1.837 
Warning messages:
1: the 'oldMethods' argument is deprecated, as it has been unused since R 1.7.0 
2: the 'oldMethods' argument is deprecated, as it has been unused since R 1.7.0
```

## 53. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -3; Rscript -e 'suppressMessages(library(FLa4a)); print(existsMethod("show","a4aFit")); print(existsMethod("print","FLComp")); showMethods("print")' 2>&1 | tail -8
```

Output:

```
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (FLa4a)
x="FLArray"
x="FLComp"
x="FLPar"
x="diagonalMatrix"
x="logical"
    (inherited from: x="ANY")
x="sparseMatrix"
```

## 54. 

```sh
python3 - <<'EOF'
p='R/a4aFit-class.R'; s=open(p).read()
anchor="#' Update stocks and indices with fit results"
s=s.replace(anchor, """#' @rdname a4aFit-class
#' @param x an `a4aFit`.
#' @export
setMethod("print", "a4aFit", function(x, ...) show(x))

"""+anchor,1)
open(p,'w').write(s)
p='tests/testthat/test-sca.R'; s=open(p).read()
s=s.replace("""  expect_false(anyNA(vcov(fit)))""","""  expect_false(anyNA(vcov(fit)))
  expect_output(print(fit), "a4aFit")
  expect_lt(length(capture.output(print(fit))), 20)""")
open(p,'w').write(s)
EOF
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "writ\|warn"; R CMD INSTALL --no-docs -l ~/Rlib . >/dev/null 2>&1; Rscript -e "png('/tmp/claude-0/ex/01-%02d.png', width=900, height=650, res=110); source('examples/01-getting-started.R')" > /tmp/claude-0/ex/01.log 2>&1; wc -l < /tmp/claude-0/ex/01.log; sed -n '/^a4aFit/,/^$/p' /tmp/claude-0/ex/01.log | head -14
```

Output:

```
Writing 'NAMESPACE'
Writing 'a4aFit-class.Rd'
113
a4aFit: PLE 
  ages: 1 - 10   years: 1957 - 2017   iters: 1 
  fleets: catch, BTS-Combined (all), SNS 

a4aFit: PLE 
  ages: 1 - 10   years: 1957 - 2017   iters: 1 
  fleets: catch, BTS-Combined (all), SNS
```

## 55. 

```sh
cd /home/user/FLa4a/examples && python3 - <<'EOF'
p='helpers.R'; s=open(p).read()
s=s.replace('''  op <- par(mfrow = c(2, 2), mar = c(3, 4, 2, 1), oma = c(0, 0, if (nzchar(main)) 2 else 0, 0))''',
'''  op <- par(mfrow = c(2, 2), mar = c(3, 5, 2, 1), oma = c(0, 0, if (nzchar(main)) 2 else 0, 0))''')
s=s.replace('''    matplot(years, vals, type = "l", lty = 1, lwd = 2, col = cols, ylim = c(0, max(vals, na.rm = TRUE)),
            xlab = "", ylab = p, main = p, las = 1)''','''    matplot(years, vals, type = "l", lty = 1, lwd = 2, col = cols, ylim = c(0, max(vals, na.rm = TRUE)),
            xlab = "", ylab = "", main = p, las = 1, yaxt = "n")
    at <- pretty(c(0, max(vals, na.rm = TRUE)))
    axis(2, at = at, labels = format(at, big.mark = ",", scientific = FALSE, trim = TRUE), las = 1)''')
s=s.replace('''plotResiduals <- function(obs, fitted, main = "log residuals") {''','''plotResiduals <- function(obs, fitted, main = "log residuals") {
  main <- paste0(main, "  (blue: observed > fitted, red: observed < fitted)")''')
s=s.replace('''       xlab = "", ylab = "age", main = main, las = 1)
  legend("topleft", c("observed > fitted", "observed < fitted"), pt.bg = c("#2166AC", "#B2182B"),
         pch = 21, col = NA, bty = "n", cex = 0.8, horiz = TRUE)
}''','''       xlab = "", ylab = "age", main = main, las = 1, cex.main = 0.9)
}''')
open(p,'w').write(s)
EOF
cd .. && Rscript -e "png('/tmp/claude-0/ex/01-%02d.png', width=900, height=650, res=110); source('examples/01-getting-started.R')" > /dev/null 2>&1; echo $?
```

Output:

```
0
```

## 56. 

```sh
for f in 02 03 04; do s=$(ls examples/$f-*.R); ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); source('$s')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?" ) & done; wait 2>/dev/null; echo done
```

Output:

```
03 exit 0
04 exit 0
02 exit 0
done
```

## 57. 

```sh
cd /home/user/FLa4a && Rscript -e 'suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices); idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
for (cv in c(0.2, 0.1, 0.05)) { f <- sca(ple4, idx, fmodel = ~ te(age, year, k = c(5, 20)), qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)), srmodel = eval(bquote(~ bevholt(CV = .(cv))))); s <- fitSumm(f)[,1]; cat(cv, round(s[c("nlogl","maxgrad","convergence","nlogl:catch","nlogl:srr")],3), round(c(coef(f)[grep("sr", dimnames(coef(f))$params),1]),3), "\n") }' 2>&1 | tail -3
```

Output:

```
0.2 112.28 0 0 -467.516 112.815 3.577 -0.15 
0.1 329.433 0 0 -314.402 179.498 3.947 1.048 
0.05 596.472 0 0 122.597 -34.162 3.889 1.212
```

## 58. 

```sh
cd /home/user/FLa4a/examples && python3 - <<'EOF'
p='04-stock-recruitment.R'; s=open(p).read()
start=s.index("# Recruitment against the SSB that produced it")
s=s[:start]+'''# Fitted stock-recruitment curves. The SR parameters are estimated on the
# model's internal scale, where numbers are divided by exp(centering), so
# SSB is scaled down and predicted recruitment scaled back up. The formulas
# match those in R/model.R.
srCurve <- function(fit, S) {
  p <- c(coef(fit)[, 1])
  names(p) <- dimnames(coef(fit))$params
  a <- p[["sraMod:(Intercept)"]]
  b <- if ("srbMod:(Intercept)" %in% names(p)) p[["srbMod:(Intercept)"]] else 0
  sc <- exp(c(fit@centering["catch", 1]))
  s <- S / sc
  logR <- switch(as.character(fit@models$srmodel[[2]][[1]]),
    bevholt = a + log(s) - log(exp(b) + s),
    ricker  = a + log(s) - exp(b) * s,
    hockey  = a + log(s + sqrt(exp(2 * b) + 0.0025) - sqrt((s - exp(b))^2 + 0.0025)),
    geomean = rep(a, length(s)))
  exp(logR) * sc
}

stks <- lapply(srfits, function(f) ple4 + f)
cols <- fitCols(length(stks))
ssbLag <- function(s) yearly(ssb(s))[-dims(s)$year]   # recruits are age 1: pair with last year's SSB
recLag <- function(s) yearly(rec(s))[-1]

par(mfrow = c(1, 2), mar = c(4, 5, 2, 1))
S <- seq(0, 1.1 * max(ssbLag(stks$free)), length = 200)
plot(ssbLag(stks$free) / 1000, recLag(stks$free) / 1e6, pch = 16, col = "grey60", las = 1,
     xlim = range(S) / 1000, ylim = c(0, max(recLag(stks$free)) / 1e6),
     xlab = "SSB (thousand t)", ylab = "recruits at age 1 (millions)", main = "Fitted SR curves")
for (i in 2:length(srfits)) lines(S / 1000, srCurve(srfits[[i]], S) / 1e6, col = cols[i], lwd = 2)
legend("topright", c("free recruitment", names(srfits)[-1]), col = c("grey60", cols[-1]),
       pch = c(16, NA), lwd = c(NA, 2), bty = "n", cex = 0.8)

# A smaller CV pulls recruitment towards the curve. If it is too small the
# curve dominates and the fit to the catches degrades.
cvs <- c(1, 0.4, 0.2, 0.1)
cvfits <- lapply(cvs, function(cv) sca(ple4, indices, fmodel = fmod, qmodel = qmod,
                                        srmodel = eval(bquote(~ bevholt(CV = .(cv))))))
tab <- sapply(cvfits, function(f) round(fitSumm(f)[comps, 1], 1))
dimnames(tab) <- list(comps, paste("CV =", cvs))
print(tab)

years <- as.numeric(dimnames(ple4)$year)
recs <- sapply(cvfits, function(f) yearly(stock.n(f)[1, ])) / 1e6
matplot(years, recs, type = "l", lty = 1, lwd = 2, col = fitCols(length(cvs)), las = 1,
        xlab = "", ylab = "recruits (millions)", main = "bevholt: effect of CV")
legend("topright", paste("CV =", cvs), col = fitCols(length(cvs)), lwd = 2, bty = "n", cex = 0.8)
'''
open(p,'w').write(s)
EOF
cd .. && Rscript -e "png('/tmp/claude-0/ex/04-%02d.png', width=900, height=650, res=110); source('examples/04-stock-recruitment.R')" 2>&1 | tail -12
```

Output:

```
    bevholt, bevholtSV, geomean, ricker

                            free geomean bevholt  ricker  hockey
nlogl:catch              -473.92 -473.55 -473.62 -473.53 -473.55
nlogl:BTS-Combined (all)   73.77   75.89   75.45   76.46   75.89
nlogl:SNS                 391.09  389.36  389.78  388.88  389.36
nlogl:srr                     NA   42.24   42.14   43.07   42.24
                         CV = 1 CV = 0.4 CV = 0.2 CV = 0.1
nlogl:catch              -473.9   -473.6   -467.5   -314.4
nlogl:BTS-Combined (all)   74.1     75.4     80.0     75.2
nlogl:SNS                 390.8    389.8    387.0    389.2
nlogl:srr                  53.8     42.1    112.8    179.5
```

## 59. 

```sh
python3 - <<'EOF'
p='examples/04-stock-recruitment.R'; s=open(p).read()
s=s.replace('''       pch = c(16, NA), lwd = c(NA, 2), bty = "n", cex = 0.8)''','''       pch = c(16, rep(NA, length(srfits) - 1)), lwd = c(NA, rep(2, length(srfits) - 1)),
       bty = "n", cex = 0.8)''')
open(p,'w').write(s)
EOF
for f in 02 04; do s=$(ls examples/$f-*.R); ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); source('$s')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $?" ) & done; wait 2>/dev/null
```

Output:

```
04 exit 0
02 exit 0
```

## 60. 

```sh
sed -i 's|^# source("examples/helpers.R")$|# source("examples/helpers.R")\n\noptions(scipen = 10)  # plain numbers on axes|' examples/helpers.R && head -5 examples/helpers.R && cat > examples/README.md <<'EOF'
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
EOF
printf '^examples$\n' >> .Rbuildignore
python3 - <<'EOF'
p='README.md'; s=open(p).read()
s=s.replace("## Code layout","See [`examples/`](examples) for worked examples with plots: getting started,\nsmoothers, covariates and stock-recruitment models.\n\n## Code layout",1)
open(p,'w').write(s)
EOF
cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A4 | head
```

Output:

```
# Plotting helpers shared by the examples (base graphics only).
# source("examples/helpers.R")

options(scipen = 10)  # plain numbers on axes

Status: OK
Shell cwd was reset to /home/user/FLa4a
```

## 61. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . >/dev/null 2>&1; for f in 01 02 03 04; do s=$(ls examples/$f-*.R); ( Rscript -e "png('/tmp/claude-0/ex/$f-%02d.png', width=900, height=650, res=110); t0<-Sys.time(); source('$s'); cat('TIME', round(as.numeric(Sys.time()-t0, units='secs')), 's\n')" > /tmp/claude-0/ex/$f.log 2>&1; echo "$f exit $? $(grep TIME /tmp/claude-0/ex/$f.log) $(grep -c '^Error' /tmp/claude-0/ex/$f.log) errors" ) & done; wait 2>/dev/null; git status --short
```

Output:

```
01 exit 0 TIME 14 s 0 errors
03 exit 0 TIME 17 s 0 errors
04 exit 0 TIME 20 s 0 errors
02 exit 0 TIME 21 s 0 errors
 M .Rbuildignore
 M NAMESPACE
 M R/a4aFit-class.R
 M README.md
 M man/a4aFit-class.Rd
 M tests/testthat/test-sca.R
?? examples/
```

## 62. 

```sh
git add R/a4aFit-class.R NAMESPACE man/a4aFit-class.Rd tests/testthat/test-sca.R && git commit -q -m "Export show and print methods for a4aFit

print(fit) dispatched to FLCore's FLComp method and dumped every slot;
it now shows the short fit summary.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git add examples .Rbuildignore README.md && git commit -q -m "Add worked examples with plots

examples/ holds four scripts on ple4: getting started, smoothers in the
submodels, covariates (year-only and age x year; linear, smooth and
varying-coefficient effects) and stock-recruitment models, plus base
graphics helpers. Excluded from the package build.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git push origin claude/peaceful-babbage-if9ubk 2>&1 | tail -1
```

Output:

```
   cd129c8..257c460  claude/peaceful-babbage-if9ubk -> claude/peaceful-babbage-if9ubk
```

## 63. 

```sh
cd /tmp/claude-0 && git clone -q --depth 1 https://github.com/r-lib/pkgdepends.git 2>&1 | tail -1; grep -rn -i "config/needs" pkgdepends/R/*.R | head -8; grep -rn "sysreqs_can_install\|can_install <-" pkgdepends/R/*.R | head -5
```

Output:

```
pkgdepends/R/assertions.R:210:         {.code config/needs/*} types"
pkgdepends/R/dep-utils.R:180:  grep("^config/needs/", x, value = TRUE, ignore.case = TRUE)
pkgdepends/R/resolution.R:727:  x[!grepl("^config/needs", x, ignore.case = TRUE)]
pkgdepends/R/resolution.R:730:# TODO: Parse remotes and Config/Needs/* fields
pkgdepends/R/scan-deps-dep-types.R:17:  tps[fields == "Config/Needs/coverage"] <- "test"
pkgdepends/R/type-installed.R:112:    grep("^config/needs/", all_fields, value = TRUE)
pkgdepends/R/type-installed.R:222:# TODO: parse Remotes and Config/Needs/* fields
pkgdepends/R/install-plan.R:319:  can_install <- which(
Shell cwd was reset to /home/user/FLa4a
```

## 64. 

```sh
cd /tmp/claude-0 && sed -n 195,215p pkgdepends/R/assertions.R; git clone -q --depth 1 https://github.com/r-lib/pak.git 2>&1|tail -1; grep -n "local_install_dev_deps <- \|Config/Needs\|dependencies = " pak/R/local.R | head; grep -rn "sysreqs_is_supported\|sudo" pkgdepends/R/sysreqs*.R | head -8
```

Output:

```
      (is.list(x) &&
        all(names(x) == c("direct", "indirect")) &&
        all(valid(unlist(x))))
  ) {
    return(TRUE)
  }

  structure(
    FALSE,
    msg = c(
      "{.arg {(.arg)}} must be one of the following: {.code NA},
         {.code TRUE}, {.code FALSE}, a character vector of dependency types,
         a named list with entries {.code direct} and {.code indirect},
         both character vectors of dependency types.",
      "i" = "valid dependency types are: {.val {dep_types}}, and
         {.code config/needs/*} types"
    ),
    env = environment()
  )
}

39:  dependencies = NA
53:      dependencies = dependencies,
107:  dependencies = NA
122:      dependencies = dependencies,
153:local_install_dev_deps <- function(
158:  dependencies = TRUE
173:      dependencies = dependencies,
207:local_deps <- function(root = ".", upgrade = TRUE, dependencies = NA) {
209:  pkg_deps(ref, upgrade = upgrade, dependencies = dependencies)
215:local_deps_tree <- function(root = ".", upgrade = TRUE, dependencies = NA) {
pkgdepends/R/sysreqs.R:9:sysreqs_is_supported <- function(sysreqs_platform = NULL) {
pkgdepends/R/sysreqs.R:521:  sudo <- config$get("sysreqs_sudo")
pkgdepends/R/sysreqs.R:555:    if (sudo) {
pkgdepends/R/sysreqs.R:556:      sh <- "sudo" # nocov
pkgdepends/R/sysreqs.R:594:can_sudo_without_pw <- function() {
pkgdepends/R/sysreqs.R:600:      processx::run("sudo", c("-s", "id"))
pkgdepends/R/sysreqsdocs.R:29:#' sysreqs_is_supported(sysreqs_platform = NULL)
pkgdepends/R/sysreqsdocs.R:37:#' @name sysreqs_is_supported
Shell cwd was reset to /home/user/FLa4a
```

## 65. 

```sh
sed -i 's/^Config\/testthat\/edition: 3$/Config\/testthat\/edition: 3\nConfig\/Needs\/dev: devtools, roxygen2/' DESCRIPTION && grep -n "Config" DESCRIPTION && cat > .devcontainer/setup.R <<'EOF'
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
EOF
Rscript -e 'invisible(parse(".devcontainer/setup.R")); d <- read.dcf("DESCRIPTION"); print(d[, "Config/Needs/dev"])'
```

Output:

```
26:Config/testthat/edition: 3
27:Config/Needs/dev: devtools, roxygen2
    Config/Needs/dev 
"devtools, roxygen2"
```

## 66. 

```sh
python3 - <<'EOF'
p='README.md'; s=open(p).read()
old=s[s.index("open it in GitHub Codespaces. On first start"):s.index("```r\ndevtools::load_all()")]
new="""open it in GitHub Codespaces. On first start `.devcontainer/setup.R` uses
[pak](https://pak.r-lib.org) to install the requirements declared in
`DESCRIPTION` (imports, `Suggests` and the dev tools listed under
`Config/Needs/dev`: devtools and roxygen2) as binaries, together with the
system libraries they need, and then installs FLa4a. Then:

"""
s=s.replace(old,new)
open(p,'w').write(s)
EOF
sed -n '/### Dev container/,/^On Windows/p' README.md; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 R CMD check --no-manual --no-tests FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A4 | head
```

Output:

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
Status: OK
Shell cwd was reset to /home/user/FLa4a
```

## 67. 

```sh
git add DESCRIPTION .devcontainer/setup.R README.md && git status --short && git commit -q -m "Install dev requirements with pak in the dev container

Declare devtools and roxygen2 under Config/Needs/dev in DESCRIPTION and
install all declared requirements (imports, suggests, dev tools) with pak,
which also installs the system libraries they need.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git push origin claude/peaceful-babbage-if9ubk 2>&1 | tail -1
```

Output:

```
M  .devcontainer/setup.R
M  DESCRIPTION
M  README.md
   257c460..aee8d37  claude/peaceful-babbage-if9ubk -> claude/peaceful-babbage-if9ubk
```

## 68. 

```sh
cd /tmp/claude-0 && Rscript -e 'suppressMessages(library(FLCore)); for (g in c("predict","simulate")) cat(g, isGeneric(g), if (isGeneric(g)) paste(names(formals(getGeneric(g))), collapse=","), "\n")
library(mgcv); options(contrasts = c(unordered = "contr.sum", ordered = "contr.poly"))
df <- expand.grid(age=1:10, year=1957:2017); df$temp <- rnorm(nrow(df))
f <- ~ te(age, year, k=c(5,20)) + s(temp, k=4) + factor(age)
G <- gam(update(f, .y ~ .), data=cbind(.y=1, df), fit=FALSE)
b <- gam(update(f, .y ~ .), data=cbind(.y=1, df), sp = rep(1, length(G$sp)))
Xp <- predict(b, df, type="lpmatrix"); cat("same X:", max(abs(Xp - G$X)), identical(colnames(Xp), G$term.names), "\n")
df2 <- df; df2$temp <- df$temp + 1; X2 <- predict(b, df2, type="lpmatrix"); cat("changed cols:", sum(colSums(abs(X2-Xp))>1e-12), "\n")
print(object.size(b), units="Kb")'
```

Output:

```
predict TRUE object,... 
simulate FALSE 
Loading required package: nlme
This is mgcv 1.9-1. For overview type 'help("mgcv-package")'.
same X: 1.154654e-11 TRUE 
changed cols: 3 
877.2 Kb
Shell cwd was reset to /home/user/FLa4a
```

## 69. 

```sh
cd /tmp/claude-0 && Rscript -e 'suppressMessages(library(mgcv)); options(contrasts = c(unordered = "contr.sum", ordered = "contr.poly"))
df <- expand.grid(age=1:10, year=1957:2017); df$temp <- rnorm(nrow(df))
f <- ~ te(age, year, k=c(5,20)) + s(temp, k=4) + factor(age)
b <- gam(update(f, .y ~ .), data=cbind(.y=1, df), sp = rep(1, 4))
Xp <- predict(b, df, type="lpmatrix")
keep <- c("coefficients","smooth","nsdf","pterms","xlevels","contrasts","pred.formula","model","terms","Xcentre","var.summary","offset","family","formula","assign","cmX","paraPen")
s <- b[intersect(names(b), keep)]; class(s) <- class(b)
s$model <- s$model[0, , drop=FALSE]
X2 <- tryCatch(predict(s, df, type="lpmatrix"), error=function(e) conditionMessage(e))
if (is.character(X2)) print(X2) else cat("diff", max(abs(X2-Xp)), "\n"); print(object.size(s), units="Kb")
for (nm in names(s)) cat(nm, format(object.size(s[[nm]]), units="Kb"), "; ")
p <- predict(gam(.y ~ factor(age) + year, data=cbind(.y=1,df)), df, type="lpmatrix"); print(head(colnames(p)))'
```

Output:

```
diff 0 
404.6 Kb
coefficients 9 Kb ; family 34.7 Kb ; nsdf 0.1 Kb ; smooth 324.6 Kb ; formula 2.5 Kb ; var.summary 0.7 Kb ; cmX 2.6 Kb ; model 9 Kb ; terms 6.6 Kb ; pred.formula 2.7 Kb ; pterms 4.2 Kb ; assign 0.1 Kb ; contrasts 0.4 Kb ; xlevels 1 Kb ; offset 4.8 Kb ; [1] "(Intercept)"  "factor(age)1" "factor(age)2" "factor(age)3" "factor(age)4"
[6] "factor(age)5"
Shell cwd was reset to /home/user/FLa4a
```

## 70. 

```sh
python3 - <<'EOF'
p='R/formula.R'; s=open(p).read()
i=s.index("hasSmooth <- function"); j=s.index("}\n", i)+2
s=s[:i]+s[j:].lstrip("\n")
open(p,'w').write(s)
EOF
sed -n '/^# Evaluate/,$p' R/formula.R | tail -25; sed -n 1,80p R/data.R
```

Output:

```
slimGam <- function(g) {
  keep <- c("coefficients", "smooth", "nsdf", "pterms", "xlevels", "contrasts", "pred.formula",
            "model", "terms", "Xcentre", "var.summary", "offset", "family", "formula",
            "assign", "cmX", "paraPen")
  out <- g[intersect(names(g), keep)]
  out$model <- out$model[0, , drop = FALSE]
  class(out) <- class(g)
  out
}

#' Breakpoints
#'
#' Cuts a numeric covariate into a factor at the given breakpoints; useful
#' inside submodel formulas, e.g. `~ factor(breakpts(year, 2000))`.
#'
#' @param var numeric vector.
#' @param breaks numeric vector of breakpoints (intervals are right closed).
#' @return a factor.
#' @export
breakpts <- function(var, breaks) {
  if (min(var, na.rm = TRUE) < min(breaks)) breaks <- c(min(var, na.rm = TRUE) - 1, breaks)
  if (max(var, na.rm = TRUE) > max(breaks)) breaks <- c(breaks, max(var, na.rm = TRUE))
  labels <- paste0("(", breaks[-length(breaks)], ",", breaks[-1], "]")
  cut(var, breaks = breaks, labels = labels)
}
# Assemble the data and design matrices for a single iteration.
#
# All age x year quantities are stored as vectors in column-major (age
# fastest) order so that they can be reshaped to nage x nyear matrices,
# the same layout as an FLQuant.
a4aData <- function(stock, indices, fmodel, qmodel, vmodel, n1model, srmodel,
                    covar = NULL, center = TRUE) {

  ages  <- as.numeric(dimnames(stock.n(stock))$age)
  years <- as.numeric(dimnames(stock.n(stock))$year)
  nA <- length(ages)
  nY <- length(years)
  fleets <- c("catch", names(indices))
  isBiomass <- vapply(indices, is, logical(1), "FLIndexBiomass")

  #------------------------------------------------------------------
  # observations
  #------------------------------------------------------------------
  catchVar <- if (is(catch.n(stock), "FLQuantDistr")) var(catch.n(stock)) else NULL
  obsList <- c(list(obsFrame(catch.n(stock), catchVar, ages, years)),
               lapply(indices, function(x) obsFrame(index(x), i
... [truncated] ...
---
  grid <- addCovariates(expand.grid(age = ages, year = years), covar)

  # age range covered by each index; smoothers are not extrapolated beyond it
  idxAges <- lapply(indices, function(x) {
    rng <- range(x)[c("min", "max")]
    if (any(is.na(rng))) range(ages) else rng
  })
  fleetGrid <- function(i) {
    if (i == 1 || isBiomass[i - 1]) return(grid)
    g <- grid
    g$age <- pmin(pmax(g$age, idxAges[[i - 1]][1]), idxAges[[i - 1]][2])
    g
  }

  sr <- parseSRmodel(srmodel)
  recGrid <- grid[grid$age == ages[1], , drop = FALSE]

  X <- list(
    f  = getX(fmodel, grid),
    q  = lapply(seq_along(indices), function(i) getX(qmodel[[i]], fleetGrid(i + 1))),
    v  = lapply(seq_along(fleets), function(i) getX(vmodel[[i]], fleetGrid(i))),
    n1 = if (nA > 1) getX(n1model, grid[grid$year == years[1] & grid$age > ages[1], , drop = FALSE])
         else matrix(0, 0, 0),
    r  = getX(sr$rmodel, recGrid),
    sra = if (!is.null(sr$sr)) getX(sr$sr$a, recGrid) else matrix(0, nY, 0),
    srb = if (!is.null(sr$sr$b)) getX(sr$sr$b, recGrid) else matrix(0, nY, 0)
  )
  names(X$q) <- fleets[-1]
  names(X$v) <- fleets

  if (!is.null(sr$sr) && ncol(X$sra) + ncol(X$srb) > nY)
    stop("stock-recruitment model is over parameterised")

  #------------------------------------------------------------------
  # data list for the RTMB model
  #------------------------------------------------------------------
  bmask <- sapply(idxAges, function(r) as.numeric(ages >= r[1] & ages <= r[2]))
```

## 71. 

```sh
python3 - <<'EOF'
p='R/data.R'; s=open(p).read()
s=s.replace('''# All age x year quantities are stored as vectors in column-major (age
# fastest) order so that they can be reshaped to nage x nyear matrices,
# the same layout as an FLQuant.
a4aData <- function(stock, indices, fmodel, qmodel, vmodel, n1model, srmodel,
                    covar = NULL, center = TRUE) {''','''# All age x year quantities are stored as vectors in column-major (age
# fastest) order so that they can be reshaped to nage x nyear matrices,
# the same layout as an FLQuant.
#
# `designs` and `centering` come from an earlier fit: the design matrices are
# then evaluated with the fitted bases (so the fitted parameters still apply,
# e.g. at new covariate values) and the fitted centering is reused.
a4aData <- function(stock, indices, fmodel, qmodel, vmodel, n1model, srmodel,
                    covar = NULL, center = TRUE, designs = NULL, centering = NULL) {''')
s=s.replace('''  centering <- vapply(obsList, function(x) mean(log(x$obs)), numeric(1))
  if (!isTRUE(center)) centering[] <- 0
  names(centering) <- fleets
''','''  if (is.null(centering)) {
    centering <- vapply(obsList, function(x) mean(log(x$obs)), numeric(1))
    if (!isTRUE(center)) centering[] <- 0
  }
  centering <- stats::setNames(as.numeric(centering), fleets)
''')
old=s[s.index("  X <- list(\n    f  = getX("):s.index("  names(X$q) <- fleets[-1]")]
new='''  # build each design, or evaluate a stored one at the (possibly new) data
  des <- function(formula, df, stored) {
    if (is.null(stored)) a4aDesign(formula, df) else list(X = predictDesign(stored, df), design = stored)
  }
  n1Grid <- grid[grid$year == years[1] & grid$age > ages[1], , drop = FALSE]
  D <- list(
    f  = des(fmodel, grid, designs$f),
    q  = lapply(seq_along(indices), function(i) des(qmodel[[i]], fleetGrid(i + 1), designs$q[[i]])),
    v  = lapply(seq_along(fleets), function(i) des(vmodel[[i]], fleetGrid(i), designs$v[[i]])),
    n1 = if (nA > 1) des(n1model, n1Grid, designs$n1),
    r  = des(sr$rmodel, recGrid, designs$r),
    sra = if (!is.null(sr$sr)) des(sr$sr$a, recGrid, designs$sra),
    srb = if (!is.null(sr$sr$b)) des(sr$sr$b, recGrid, designs$srb)
  )
  getMat <- function(d, nrow) if (is.null(d)) matrix(0, nrow, 0) else d$X
  X <- list(f = D$f$X, q = lapply(D$q, `[[`, "X"), v = lapply(D$v, `[[`, "X"),
            n1 = getMat(D$n1, 0), r = D$r$X, sra = getMat(D$sra, nY), srb = getMat(D$srb, nY))
  designs <- list(f = D$f$design, q = lapply(D$q, `[[`, "design"), v = lapply(D$v, `[[`, "design"),
                  n1 = D$n1$design, r = D$r$design, sra = D$sra$design, srb = D$srb$design)
'''
s=s.replace(old,new)
s=s.replace('''  list(dat = dat, par = par, pnames = pnames, centering = centering,
       ages = ages, years = years, fleets = fleets, nobs = nrow(obs))''','''  list(dat = dat, par = par, pnames = pnames, centering = centering, designs = designs,
       obs = obs[c("fleet", "year", "age")],
       ages = ages, years = years, fleets = fleets, nobs = nrow(obs))''')
open(p,'w').write(s)
EOF
grep -n "list(dat = dat" -A3 R/data.R; grep -n "n1 = if (nA > 1) getX\|getX(" R/data.R
```

Output:

```
135:  list(dat = dat, par = par, pnames = pnames, centering = centering, designs = designs,
136-       obs = obs[c("fleet", "year", "age")],
137-       ages = ages, years = years, fleets = fleets, nobs = nrow(obs))
138-}
```

## 72. 

```sh
sed -i 's/    out\[cbind(ia, iy, 1, 1, 1, 1)\] <- y\[rows\]/    out@.Data[cbind(ia, iy, 1, 1, 1, 1)] <- y[rows]/' R/simulate.R && sed -i "s/^  RTMB$/  RTMB,\n  MASS/; s/^  'sca.R'$/  'sca.R'\n  'simulate.R'/" DESCRIPTION && sed -n '/^Imports/,/^Suggests/p;/^Collate/,$p' DESCRIPTION && Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -iv "^$\|loading\|lattice\|FLCore (" ; grep -n "simulate\|predict" NAMESPACE; R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1
```

Output:

```
Imports:
  methods,
  stats,
  Matrix,
  mgcv,
  RTMB,
  MASS
Suggests:
Collate:
  'FLa4a-package.R'
  'formula.R'
  'srmodels.R'
  'defaults.R'
  'data.R'
  'model.R'
  'a4aFit-class.R'
  'sca.R'
  'simulate.R'
RoxygenNote: 7.3.1
Writing 'NAMESPACE'
Writing 'getX.Rd'
Writing 'a4aFit-class.Rd'
Writing 'sca.Rd'
Writing 'predict-a4aFit.Rd'
Writing 'simulate-a4aFit.Rd'
25:exportMethods(predict)
28:exportMethods(simulate)
* DONE (FLa4a)
```

## 73. 

```sh
Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -15
```

Output:

```
getX: ..........
sca: ................................

== DONE ========================================================================
```

## 74. 

```sh
cd /tmp/claude-0 && cat > sim1.R <<'EOF'
suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
yrs <- dimnames(ple4)$year
set.seed(1); temp <- FLQuant(rnorm(length(yrs)), dimnames = list(year = yrs))
fit <- sca(ple4, idx, fmodel = ~ s(age, k = 5) + s(year, k = 20) + temp,
           qmodel = list(~ s(age, k = 5) + s(temp, k = 3), ~ s(age, k = 4)), covar = list(temp = temp))
print(fit); cat("fit size:", format(object.size(fit), units = "Mb"), "\n")
t0 <- Sys.time(); p0 <- predict(fit, ple4, idx); cat("predict secs", round(as.numeric(Sys.time() - t0), 2), "\n")
cat("reproduces fit:", max(abs(c(p0$stock.n / stock.n(fit)) - 1)), max(abs(c(p0$index[[1]] / index(fit)[[1]]) - 1), na.rm=TRUE), "\n")
p1 <- predict(fit, ple4, idx, covar = list(temp = temp + 1))
b <- c(coef(fit)["fMod:temp", 1]); cat("F ratio", range(c(p1$harvest / p0$harvest)), "exp(beta)", exp(b), "\n")
cat("SNS index unchanged ratio range:", range(c(p1$index[[2]] / p0$index[[2]] * p0$stock.n[1:7, ac(1970:2017)]/p1$stock.n[1:7, ac(1970:2017)] ), na.rm=TRUE), "\n")
t0 <- Sys.time(); s <- simulate(fit, nsim = 20, seed = 2, stock = ple4, indices = idx); cat("simulate 20 secs", round(as.numeric(Sys.time() - t0), 2), "\n")
cat(dims(s$stock)$iter, dims(s$indices[[1]])$iter, "NA pattern same:", identical(is.na(c(index(s$indices[[2]])[, , , , , 1])), is.na(c(index(idx[[2]])))), "\n")
r <- log(catch.n(s$stock) / propagate(catch.n(fit), 20)); cat("catch log resid mean", mean(r), "sd", sd(c(r)), "\n")
refit <- sca(s$stock[, , , , , 1:3], FLIndices(lapply(s$indices, function(x) x[, , , , , 1:3])), fmodel = fit@models$fmodel, qmodel = fit@models$qmodel, covar = list(temp = temp), fit = "MP")
cat("true beta", b, "refit", c(coef(refit)["fMod:temp", ]), "\n")
EOF
Rscript sim1.R 2>&1 | tail -16
```

Output:

```
a4aFit: PLE 
  ages: 1 - 10   years: 1957 - 2017   iters: 1 
  fleets: catch, BTS-Combined (all), SNS 

    
iter nopar    nlogl      maxgrad nobs convergence
   1   105 339.9854 8.905765e-12 1123           0
fit size: 0.7 Mb 
predict secs 0.16 
reproduces fit: 0 0 
F ratio 0.9913823 0.9913823 exp(beta) 0.9913823 
SNS index unchanged ratio range: 1.000632 1.00513 
simulate 20 secs 1.81 
20 20 NA pattern same: TRUE 
catch log resid mean 0.001171444 sd 0.224949 
true beta -0.008655064 refit -0.00132015 -0.003437998 -0.01061417
Shell cwd was reset to /home/user/FLa4a
```

## 75. 

```sh
Rscript -e 'testthat::test_local(".", filter = "simulate", reporter = "summary")' 2>&1 | tail -25
```

Output:

```
simulate: ...................1.......

== Failed ======================================================================
-- 1. Error ('test-simulate.R:59:3'): simulate responds to new covariates, per s
Error in `propagate(temp, 2) + FLQuant(c(0, 1), dim = c(1, 1, 1, 1, 1, 
    2))`: non-conformable arrays
Backtrace:
    x
 1. +-stats::simulate(...) at test-simulate.R:59:3
 2. +-FLa4a::simulate(...)
 3. | \-FLa4a (local) .local(object, nsim, seed, ...)
 4. |   \-base::vapply(covar, function(x) dims(x)$iter, numeric(1)) at FLa4a/R/simulate.R:63:3
 5. +-propagate(temp, 2) + ... at FLa4a/R/simulate.R:63:3
 6. \-propagate(temp, 2) + ...

== DONE ========================================================================
Error: Test failures
Execution halted
```

## 76. 

```sh
python3 - <<'EOF'
p='tests/testthat/test-simulate.R'; s=open(p).read()
s=s.replace("""  s <- simulate(fit, nsim = 2, seed = 1, stock = ple4, indices = ple4.index,
                covar = list(temp = propagate(temp, 2) + FLQuant(c(0, 1), dim = c(1, 1, 1, 1, 1, 2))))""","""  temp2 <- propagate(temp, 2)
  temp2[, , , , , 2] <- temp + 1
  s <- simulate(fit, nsim = 2, seed = 1, stock = ple4, indices = ple4.index, covar = list(temp = temp2))""")
open(p,'w').write(s)
EOF
Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -8
```

Output:

```
getX: ..........
sca: ................................
simulate: ............................

== DONE ========================================================================
```

## 77. 

```sh
cat >> examples/helpers.R <<'EOF'

# Median and 90% band over simulations (iterations) of one age of an
# FLQuant, for several scenarios, with optional observed points.
plotEnvelope <- function(sims, age = 1, obs = NULL, main = "", ylab = "") {
  cols <- fitCols(length(sims))
  q <- lapply(sims, function(x) {
    m <- matrix(c(x[as.character(age), ]), nrow = dim(x)[2])
    t(apply(m, 1, quantile, c(0.05, 0.5, 0.95), na.rm = TRUE))
  })
  years <- as.numeric(dimnames(sims[[1]])$year)
  ylim <- range(unlist(q), if (!is.null(obs)) c(obs[as.character(age), ]), na.rm = TRUE)
  plot(NULL, xlim = range(years), ylim = ylim, las = 1, xlab = "", ylab = ylab, main = main)
  for (i in seq_along(q)) {
    ok <- !is.na(q[[i]][, 2])
    polygon(c(years[ok], rev(years[ok])), c(q[[i]][ok, 1], rev(q[[i]][ok, 3])),
            col = grDevices::adjustcolor(cols[i], 0.25), border = NA)
    lines(years[ok], q[[i]][ok, 2], col = cols[i], lwd = 2)
  }
  if (!is.null(obs)) points(years, c(obs[as.character(age), ]), pch = 16, cex = 0.6)
  legend("topleft", c(names(sims), if (!is.null(obs)) "observed"), col = c(cols, "black"),
         lwd = c(rep(2, length(sims)), NA), pch = c(rep(NA, length(sims)), if (!is.null(obs)) 16),
         bty = "n", cex = 0.8)
}
EOF
echo ok
```

Output:

```
ok
[This command modified 1 file you've previously read: examples/helpers.R. Call Read before editing.]
```

## 78. 

```sh
python3 - <<'EOF'
p='examples/05-simulate-covariates.R'; s=open(p).read()
s=s.replace("""sims$stock            # FLStock with 200 iterations; catch.n are simulated
sims$indices          # FLIndices with 200 iterations""","""print(dims(sims$stock)$iter)              # FLStock: catch.n simulated, stock.n/harvest true
print(dims(index(sims$indices[[1]]))$iter) # FLIndices of simulated indices""")
s=s.replace("""range(p1$harvest / p0$harvest)
exp(p[["fMod:temp"]])""","""print(range(p1$harvest / p0$harvest))
print(exp(p[["fMod:temp"]]))""")
s=s.replace("""summary(est)
mean(abs(est - log(1.2)) < 2 * estSE)   # coverage of approximate 95% intervals""","""print(summary(est))
print(mean(abs(est - log(1.2)) < 2 * estSE))   # coverage of approximate 95% intervals""")
s=s.replace("""for (i in seq_along(est)) lines(yrs, yearly(fbar(ple4 + iter(refits, i))), col = "grey70")""","""fbarRange <- ac(range(ple4)["minfbar"]:range(ple4)["maxfbar"])
for (i in seq_along(est)) lines(yrs, yearly(quantMeans(harvest(refits)[fbarRange, , , , , i])), col = "grey70")""")
open(p,'w').write(s)
EOF
rm -f /tmp/claude-0/ex/05*; Rscript -e "png('/tmp/claude-0/ex/05-%02d.png', width=900, height=650, res=110); t0<-Sys.time(); source('examples/05-simulate-covariates.R'); cat('TIME', round(as.numeric(Sys.time()-t0, units='secs')), 's\n')" 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -30; ls /tmp/claude-0/ex/05*
```

Output:

```
a4aFit: PLE 
  ages: 1 - 10   years: 1957 - 2017   iters: 1 
  fleets: catch, BTS-Combined (all), SNS 
    
iter nopar     nlogl              maxgrad nobs convergence
   1   180 -16.91479 0.000000000009682921 1123           0
                                  estimate    se
fMod:temp                            0.017 0.019
qMod:BTS-Combined (all):wtAnomaly   -0.719 0.191
[1] 200
[1] 200
[1] 1.017539 1.017539
[1] 1.017539
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.1341  0.1685  0.1887  0.1832  0.1993  0.2167 
[1] 0.8
TIME 116 s
/tmp/claude-0/ex/05-01.png
/tmp/claude-0/ex/05-02.png
/tmp/claude-0/ex/05-03.png
```

## 79. 

```sh
python3 - <<'EOF'
p='examples/05-simulate-covariates.R'; s=open(p).read()
s=s.replace("""par(mfrow = c(2, 2), mar = c(3, 4, 2, 1))
for (a in c(2, 6)) {
  plotEnvelope(list(simulated""","""par(mfrow = c(2, 2), mar = c(3, 5, 2, 1))
for (a in c(2, 6)) {
  plotEnvelope(list(simulated""")
old=s[s.index("par(mfrow = c(2, 2), mar = c(3, 4, 2, 1))\nfor (a in c(2, 6)) {\n  plotEnvelope(list(fitted"):s.index("# Covariates can also differ")]
new='''# The expected change is small next to observation error, so show both the
# simulated envelopes and the expected ratio scenario / fitted
par(mfrow = c(1, 2), mar = c(3, 5, 2, 1))
plotEnvelope(list(fitted = index(sims$indices[[bts]]), scenario = index(simsS$indices[[bts]])),
             age = 6, main = paste(bts, "age 6"), ylab = "index")
ratios <- cbind("BTS index, age 2" = c(p1$index[[bts]]["2", ] / p0$index[[bts]]["2", ]),
                "BTS index, age 6" = c(p1$index[[bts]]["6", ] / p0$index[[bts]]["6", ]),
                "catch, age 2" = c(p1$catch.n["2", ac(1996:2017)] / p0$catch.n["2", ac(1996:2017)]),
                "catch, age 6" = c(p1$catch.n["6", ac(1996:2017)] / p0$catch.n["6", ac(1996:2017)]))
matplot(1996:2017, ratios, type = "l", lty = c(1, 1, 2, 2), lwd = 2, col = fitCols(2)[c(1, 2, 1, 2)],
        las = 1, xlab = "", ylab = "scenario / fitted", main = "Expected change (predict)")
abline(h = 1, col = "grey60")
legend("left", colnames(ratios), lty = c(1, 1, 2, 2), lwd = 2, col = fitCols(2)[c(1, 2, 1, 2)],
       bty = "n", cex = 0.8)

'''
s=s.replace(old,new)
s=s.replace("sims <- simulate(fit, nsim = 200","sims <- simulate(fit, nsim = 100").replace("simsP <- simulate(fit, nsim = 200","simsP <- simulate(fit, nsim = 100").replace("simsS <- simulate(fit, nsim = 200","simsS <- simulate(fit, nsim = 100")
s=s.replace("""# Run from the repository root:  source("examples/05-simulate-covariates.R")""","""# Run from the repository root:  source("examples/05-simulate-covariates.R")
# (takes about 1-2 minutes, mostly the refits in part 4)""")
open(p,'w').write(s)
EOF
rm -f /tmp/claude-0/ex/05*; Rscript -e "png('/tmp/claude-0/ex/05-%02d.png', width=900, height=650, res=110); t0<-Sys.time(); source('examples/05-simulate-covariates.R'); cat('TIME', round(as.numeric(Sys.time()-t0, units='secs')), 's\n')" 2>&1 | grep -E "TIME|Error|Warn"
```

Output:

```
TIME 87 s
```

## 80. 

```sh
sed -i 's/^legend("left", colnames(ratios)/legend("bottomright", colnames(ratios)/' examples/05-simulate-covariates.R && python3 - <<'EOF'
p='examples/README.md'; s=open(p).read()
s=s.replace("""| `helpers.R` |""","""| `05-simulate-covariates.R` | `predict()` and `simulate()` from a covariate model: predictive checks, covariate scenarios (including per-simulation covariates), parameter uncertainty, and refitting simulated data to check an effect is recoverable |
| `helpers.R` |""")
s=s.replace("Each script takes 10-30 seconds.","Scripts 01-04 take 10-30 seconds each; 05 takes 1-2 minutes.")
open(p,'w').write(s)

p='README.md'; s=open(p).read()
s=s.replace("""stk <- ple4 + fit
AIC(fit)
```""","""stk <- ple4 + fit
AIC(fit)
```

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
```""")
s=s.replace("""| `R/defaults.R` | default submodels |""","""| `R/simulate.R` | `predict()` and `simulate()`: the fitted model at new covariate values, with observation error |
| `R/defaults.R` | default submodels |""")
s=s.replace("""| `R/formula.R` | `getX()`: formula to design matrix (mgcv smoothers supported) |""","""| `R/formula.R` | submodel designs: formula to design matrix (mgcv smoothers supported), re-evaluable at new data with the fitted basis |""")
s=s.replace("""Compared with FLa4a 1.9.x, this version drops MCMC, `simulate`/`predict`,
residual""","""Compared with FLa4a 1.9.x, this version drops MCMC, residual""")
open(p,'w').write(s)

p='NEWS.md'; s=open(p).read()
s=s.replace("# FLa4a 2.0.0.9000\n","""# FLa4a 2.0.0.9000

* New `predict()` and `simulate()` methods for `a4aFit`. They evaluate the
  fitted model at new covariate values (smoothers keep their fitted bases)
  and simulate catch and survey indices with lognormal observation error,
  optionally with parameter uncertainty. Simulations are returned as an
  `FLStock` and `FLIndices` with `nsim` iterations, ready to refit.
* Covariates may have iterations, matched to the data's iterations in
  `sca()` and to simulations in `simulate()`.
* Fits store their submodel designs and covariates.
""",1)
s=s.replace("* Dropped: MCMC, simulation/prediction, diagnostics","* Dropped: MCMC, diagnostics")
open(p,'w').write(s)
EOF
grep -n "Not (yet)" -A5 README.md; cat NEWS.md
```

Output:

```
99:## Not (yet) included
100-
101-Compared with FLa4a 1.9.x, this version drops MCMC, residual and diagnostic classes, `a4aM`/growth/length-to-age tools, multiple
102-units/seasons/areas, and the `trawl()` formula helper. The next step is
103-efficient sparse estimation of penalised 1D and 2D smoothers.
104-
# FLa4a 2.0.0.9000

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
```

## 81. 

```sh
python3 - <<'EOF'
p='README.md'; s=open(p).read()
s=s.replace("""units/seasons/areas, and the `trawl()` formula helper. The next step is""","""units/seasons/areas, and the `trawl()` formula helper. `predict()` and
`simulate()` cover the fitted ages and years (no projections yet), and
recruitment follows its fitted values unless its submodel uses covariates.
The next step is""")
open(p,'w').write(s)
EOF
python3 - <<'EOF' > /tmp/claude-0/readme_snip.R
s=open('/home/user/FLa4a/README.md').read()
i=s.index("### Simulation with covariates"); b=s.index("```r",i)+4; e=s.index("```",b)
print("suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)\n"+s[b:e]+"\nprint(dims(sim$stock)$iter); print(fitSumm(refit)['convergence',1:3])")
EOF
Rscript /tmp/claude-0/readme_snip.R 2>&1 | tail -3; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A6 | head -20
```

Output:

```
[1] 100
1 2 3 
0 0 0 
* checking dependencies in R code ... NOTE
Namespace in Imports field not imported from: ‘MASS’
  All declared Imports should be used.
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
--
Status: 1 NOTE
See
  ‘/tmp/claude-0/chk/FLa4a.Rcheck/00check.log’
for details.
Shell cwd was reset to /home/user/FLa4a
```

## 82. 

```sh
python3 - <<'EOF'
p='R/simulate.R'; s=open(p).read()
old=s[s.index("    pars <- MASS::mvrnorm(nsim, par, V)"):s.index("  }\n\n  stk <- propagate(stock, nsim)")]
new="""    # multivariate normal draws: par + L z with V = L L'
    z <- matrix(stats::rnorm(nsim * length(par)), length(par), nsim)
    pars <- t(par + t(chol(V)) %*% z)
"""
s=s.replace(old,new)
open(p,'w').write(s)
p='DESCRIPTION'; s=open(p).read()
s=s.replace("  RTMB,\n  MASS\n","  RTMB\n")
open(p,'w').write(s)
EOF
sed -n '/if (sample.pars) {/,/^  }/p' R/simulate.R; grep -n -A7 "^Imports" DESCRIPTION; R CMD INSTALL --no-docs -l ~/Rlib . >/dev/null 2>&1; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A6 | head -12
```

Output:

```
  if (sample.pars) {
    V <- vcov(object)[, , 1]
    if (anyNA(V)) stop("sample.pars needs a covariance matrix: fit with fit = \"assessment\"")
    # multivariate normal draws: par + L z with V = L L'
    z <- matrix(stats::rnorm(nsim * length(par)), length(par), nsim)
    pars <- t(par + t(chol(V)) %*% z)
  }
16:Imports:
17-  methods,
18-  stats,
19-  Matrix,
20-  mgcv,
21-  RTMB
22-Suggests:
23-  testthat (>= 3.0.0)
Status: OK
Shell cwd was reset to /home/user/FLa4a
```

## 83. 

```sh
rm -f /tmp/claude-0/ex/05*; Rscript -e "png('/tmp/claude-0/ex/05-%02d.png', width=900, height=650, res=110); source('examples/05-simulate-covariates.R')" 2>&1 | grep -E "Error|Warn|^\[1\]|Min|0\.1" ; ls /tmp/claude-0/ex/05*; git status --short
```

Output:

```
qMod:BTS-Combined (all):wtAnomaly   -0.719 0.191
[1] 100
[1] 100
[1] 1.017539 1.017539
[1] 1.017539
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.1341  0.1685  0.1887  0.1832  0.1993  0.2167 
[1] 0.8
/tmp/claude-0/ex/05-01.png
/tmp/claude-0/ex/05-02.png
/tmp/claude-0/ex/05-03.png
 M DESCRIPTION
 M NAMESPACE
 M NEWS.md
 M R/a4aFit-class.R
 M R/data.R
 M R/formula.R
 M R/model.R
 M R/sca.R
 M README.md
 M examples/README.md
 M examples/helpers.R
 M man/a4aFit-class.Rd
 M man/getX.Rd
 M man/sca.Rd
?? R/simulate.R
?? examples/05-simulate-covariates.R
?? man/predict-a4aFit.Rd
?? man/simulate-a4aFit.Rd
?? tests/testthat/test-simulate.R
```

## 84. 

```sh
git add R man NAMESPACE DESCRIPTION NEWS.md README.md tests && git commit -q -m "Add predict and simulate for fits with covariates

Submodels now keep a design object (the fitted mgcv basis and retained
columns) so their design matrices can be re-evaluated at new covariate
values with the same knots and parameters. Fits store these designs and
their covariates.

- predict(fit, stock, indices, covar): expected F, numbers, catch and
  indices under new covariate values
- simulate(fit, nsim, seed, stock, indices, covar, sample.pars): lognormal
  catch and index observations at the observed cells, optionally with
  parameter uncertainty and per-simulation covariates; returns an FLStock
  and FLIndices with nsim iterations, ready to refit with sca()
- covariates may have iterations, matched to data iterations in sca()

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git add examples && git commit -q -m "Add simulation example with covariate scenarios

examples/05-simulate-covariates.R fits a covariate model, simulates
catches and indices (predictive check), simulates a covariate scenario,
and refits data simulated with a known effect to check it is recoverable.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git push origin claude/peaceful-babbage-if9ubk 2>&1 | tail -1; git log --oneline -3
```

Output:

```
   aee8d37..fd71dc4  claude/peaceful-babbage-if9ubk -> claude/peaceful-babbage-if9ubk
fd71dc4 Add simulation example with covariate scenarios
ce2b91b Add predict and simulate for fits with covariates
aee8d37 Install dev requirements with pak in the dev container
```

## 85. 

```sh
cd /home/user/FLa4a/examples && grep -n "plot\|par(\|matplot\|legend\|lines(\|points(\|abline\|segments\|for (" 0*.R | grep -v "^.*:#" 
```

Output:

```
01-getting-started.R:62:plotSummary(list(default = stk0, "te(age, year)" = stk1), main = "North Sea plaice")
01-getting-started.R:65:par(mfrow = c(1, 1))
01-getting-started.R:66:plotAgeYear(harvest(fit1), main = "F at age: te(age, year, k = c(5, 20))")
01-getting-started.R:72:plotIndexFit(index(indices[[1]]), index(fit1)[[1]], main = names(indices)[1])
01-getting-started.R:75:par(mfrow = c(2, 1), mar = c(3, 4, 2, 1))
01-getting-started.R:76:plotResiduals(catch.n(ple4), catch.n(fit1), main = "catch: log residuals")
01-getting-started.R:77:plotResiduals(index(indices[[1]]), index(fit1)[[1]], main = paste(names(indices)[1], ": log residuals"))
02-smoothers.R:43:op <- par(mfrow = c(3, 2), mar = c(3, 4, 2, 1))
02-smoothers.R:44:for (n in names(ffits)) plotAgeYear(harvest(ffits[[n]]), main = n, zlim = zlim)
02-smoothers.R:45:par(op)
02-smoothers.R:48:plotSelectivity(ffits, years = c(1970, 1995, 2015))
02-smoothers.R:51:plotSummary(lapply(ffits, function(f) ple4 + f), main = "fmodel comparison")
02-smoothers.R:75:matplot(1:10, qAtAge, type = "l", lty = 1, lwd = 2, col = fitCols(ncol(qAtAge)), las = 1,
02-smoothers.R:77:legend("topleft", colnames(qAtAge), col = fitCols(ncol(qAtAge)), lwd = 2, bty = "n")
02-smoothers.R:92:matplot(years, recs, type = "l", lty = 1, lwd = 2, col = fitCols(ncol(recs)), las = 1,
02-smoothers.R:94:legend("topright", colnames(recs), col = fitCols(ncol(recs)), lwd = 2, bty = "n")
03-covariates.R:42:par(mfrow = c(2, 1), mar = c(3, 4, 2, 1))
03-covariates.R:43:plot(as.numeric(years), c(temp), type = "l", lwd = 2, las = 1, xlab = "", ylab = "anomaly",
03-covariates.R:45:plotAgeYear(wtAnomaly, main = "wtAnomaly: log stock weight anomaly (age x year)")
03-covariates.R:105:plotSummary(list(base = ple4 + fitBase, "+ wtAnomaly" = ple4 + fitWt,
04-stock-recruitment.R:59:par(mfrow = c(1, 2), mar = c(4, 5, 2, 1))
04-stock-recruitment.R:61:plot(ssbLag(stks$free) / 1000, recLag(stks$free) / 1e6, pch = 16, col = "grey60", las = 1,
04-stock-recruitment.R:64:for (i
... [truncated] ...
, 2, 1))
05-simulate-covariates.R:90:plotEnvelope(list(fitted = index(sims$indices[[bts]]), scenario = index(simsS$indices[[bts]])),
05-simulate-covariates.R:96:matplot(1996:2017, ratios, type = "l", lty = c(1, 1, 2, 2), lwd = 2, col = fitCols(2)[c(1, 2, 1, 2)],
05-simulate-covariates.R:98:abline(h = 1, col = "grey60")
05-simulate-covariates.R:99:legend("bottomright", colnames(ratios), lty = c(1, 1, 2, 2), lwd = 2, col = fitCols(2)[c(1, 2, 1, 2)],
05-simulate-covariates.R:105:for (i in 1:50) {
05-simulate-covariates.R:127:par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
05-simulate-covariates.R:128:plot(seq_along(est), est, ylim = range(est - 2 * estSE, est + 2 * estSE), pch = 16, las = 1,
05-simulate-covariates.R:130:segments(seq_along(est), est - 2 * estSE, seq_along(est), est + 2 * estSE)
05-simulate-covariates.R:131:abline(h = log(1.2), col = fitCols(1), lwd = 2)
05-simulate-covariates.R:132:legend("topleft", c("estimate +/- 2 se", "true value"), pch = c(16, NA), lwd = c(1, 2),
05-simulate-covariates.R:136:plot(yrs, yearly(fbar(simsR$stock[, , , , , 1])), type = "n", las = 1, xlab = "", ylab = "Fbar",
05-simulate-covariates.R:139:for (i in seq_along(est)) lines(yrs, yearly(quantMeans(harvest(refits)[fbarRange, , , , , i])), col = "grey70")
05-simulate-covariates.R:140:lines(yrs, yearly(fbar(simsR$stock[, , , , , 1])), col = fitCols(1), lwd = 2)
05-simulate-covariates.R:141:legend("topleft", c("refits", "truth"), col = c("grey70", fitCols(1)), lwd = c(1, 2), bty = "n", cex = 0.8)
```

## 86. 

```sh
sed -n 60,78p 01-getting-started.R; echo ----; sed -n 40,52p 02-smoothers.R; sed -n 73,95p 02-smoothers.R; echo ----; sed -n 40,46p 03-covariates.R; sed -n 103,107p 03-covariates.R
```

Output:

```
stk1 <- ple4 + fit1

plotSummary(list(default = stk0, "te(age, year)" = stk1), main = "North Sea plaice")

# Fishing mortality at age and year
par(mfrow = c(1, 1))
plotAgeYear(harvest(fit1), main = "F at age: te(age, year, k = c(5, 20))")

#---------------------------------------------------------------------
# 4. How well does the model fit the data?
#---------------------------------------------------------------------
# fitted vs observed survey indices
plotIndexFit(index(indices[[1]]), index(fit1)[[1]], main = names(indices)[1])

# residuals for the catch and the first survey
par(mfrow = c(2, 1), mar = c(3, 4, 2, 1))
plotResiduals(catch.n(ple4), catch.n(fit1), main = "catch: log residuals")
plotResiduals(index(indices[[1]]), index(fit1)[[1]], main = paste(names(indices)[1], ": log residuals"))

----

# F surfaces on a common colour scale
zlim <- c(0, max(sapply(ffits, function(f) max(harvest(f)))))
op <- par(mfrow = c(3, 2), mar = c(3, 4, 2, 1))
for (n in names(ffits)) plotAgeYear(harvest(ffits[[n]]), main = n, zlim = zlim)
par(op)

# selectivity in three years: only the non-separable models let it change
plotSelectivity(ffits, years = c(1970, 1995, 2015))

# stock trajectories
plotSummary(lapply(ffits, function(f) ple4 + f), main = "fmodel comparison")

  c((index(f)[[bts]] / (stock.n(f)[ages, years] * exp(-Z * t_bts)))[, "2010"])
})
matplot(1:10, qAtAge, type = "l", lty = 1, lwd = 2, col = fitCols(ncol(qAtAge)), las = 1,
        xlab = "age", ylab = "catchability", main = paste("Catchability at age:", bts))
legend("topleft", colnames(qAtAge), col = fitCols(ncol(qAtAge)), lwd = 2, bty = "n")

#---------------------------------------------------------------------
# 3. Recruitment: free, or a smooth trend
#---------------------------------------------------------------------
rmodels <- list(
  "factor(year)"    = ~ factor(year),
  "s(year, k = 30)" = ~ s(year, k = 30),
  "s(year, k = 10)" = ~ s(year, k = 10)
)
rfits <- lapply(rmodels, function(rm) sca(ple4, indices, fmodel = fm, qmodel = qmod, srmodel = rm))
print(fitTable(rfits))

years <- as.numeric(dimnames(ple4)$year)
recs <- sapply(rfits, function(f) yearly(stock.n(f)[1, ]))
matplot(years, recs, type = "l", lty = 1, lwd = 2, col = fitCols(ncol(recs)), las = 1,
        xlab = "", ylab = "recruits (thousands)", main = "Recruitment submodels")
legend("topright", colnames(recs), col = fitCols(ncol(recs)), lwd = 2, bty = "n")
----
wtAnomaly <- lw %-% yearMeans(lw)

par(mfrow = c(2, 1), mar = c(3, 4, 2, 1))
plot(as.numeric(years), c(temp), type = "l", lwd = 2, las = 1, xlab = "", ylab = "anomaly",
     main = "temp (simulated, year only)")
plotAgeYear(wtAnomaly, main = "wtAnomaly: log stock weight anomaly (age x year)")

print(fitTable(list(base = fitBase, "SNS q break in 1995" = fitBreak)))

plotSummary(list(base = ple4 + fitBase, "+ wtAnomaly" = ple4 + fitWt,
                 "SNS q break" = ple4 + fitBreak), main = "Covariate models")
```

## 87. 

```sh
sed -n 57,83p 04-stock-recruitment.R; echo ----; sed -n 56,101p 05-simulate-covariates.R; sed -n 124,142p 05-simulate-covariates.R
```

Output:

```
recLag <- function(s) yearly(rec(s))[-1]

par(mfrow = c(1, 2), mar = c(4, 5, 2, 1))
S <- seq(0, 1.1 * max(ssbLag(stks$free)), length = 200)
plot(ssbLag(stks$free) / 1000, recLag(stks$free) / 1e6, pch = 16, col = "grey60", las = 1,
     xlim = range(S) / 1000, ylim = c(0, max(recLag(stks$free)) / 1e6),
     xlab = "SSB (thousand t)", ylab = "recruits at age 1 (millions)", main = "Fitted SR curves")
for (i in 2:length(srfits)) lines(S / 1000, srCurve(srfits[[i]], S) / 1e6, col = cols[i], lwd = 2)
legend("topright", c("free recruitment", names(srfits)[-1]), col = c("grey60", cols[-1]),
       pch = c(16, rep(NA, length(srfits) - 1)), lwd = c(NA, rep(2, length(srfits) - 1)),
       bty = "n", cex = 0.8)

# A smaller CV pulls recruitment towards the curve. If it is too small the
# curve dominates and the fit to the catches degrades.
cvs <- c(1, 0.4, 0.2, 0.1)
cvfits <- lapply(cvs, function(cv) sca(ple4, indices, fmodel = fmod, qmodel = qmod,
                                        srmodel = eval(bquote(~ bevholt(CV = .(cv))))))
tab <- sapply(cvfits, function(f) round(fitSumm(f)[comps, 1], 1))
dimnames(tab) <- list(comps, paste("CV =", cvs))
print(tab)

years <- as.numeric(dimnames(ple4)$year)
recs <- sapply(cvfits, function(f) yearly(stock.n(f)[1, ])) / 1e6
matplot(years, recs, type = "l", lty = 1, lwd = 2, col = fitCols(length(cvs)), las = 1,
        xlab = "", ylab = "recruits (millions)", main = "bevholt: effect of CV")
legend("topright", paste("CV =", cvs), col = fitCols(length(cvs)), lwd = 2, bty = "n", cex = 0.8)
----
print(dims(sims$stock)$iter)              # FLStock: catch.n simulated, stock.n/harvest true
print(dims(index(sims$indices[[1]]))$iter) # FLIndices of simulated indices

bts <- names(indices)[1]
par(mfrow = c(2, 2), mar = c(3, 5, 2, 1))
for (a in c(2, 6)) {
  plotEnvelope(list(simulated = catch.n(sims$stock)), age = a, obs = catch.n(ple4),
               main = paste("catch at age", a), ylab = "thousands")
  plotEnvelope(list(simulated = index(sims$in
... [truncated] ...
matplot(1996:2017, ratios, type = "l", lty = c(1, 1, 2, 2), lwd = 2, col = fitCols(2)[c(1, 2, 1, 2)],
        las = 1, xlab = "", ylab = "scenario / fitted", main = "Expected change (predict)")
abline(h = 1, col = "grey60")
legend("bottomright", colnames(ratios), lty = c(1, 1, 2, 2), lwd = 2, col = fitCols(2)[c(1, 2, 1, 2)],
       bty = "n", cex = 0.8)

print(summary(est))
print(mean(abs(est - log(1.2)) < 2 * estSE))   # coverage of approximate 95% intervals

par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(seq_along(est), est, ylim = range(est - 2 * estSE, est + 2 * estSE), pch = 16, las = 1,
     xlab = "simulation", ylab = "estimated temp effect on log F", main = "Refitted effect")
segments(seq_along(est), est - 2 * estSE, seq_along(est), est + 2 * estSE)
abline(h = log(1.2), col = fitCols(1), lwd = 2)
legend("topleft", c("estimate +/- 2 se", "true value"), pch = c(16, NA), lwd = c(1, 2),
       col = c("black", fitCols(1)), bty = "n", cex = 0.8)

yrs <- as.numeric(years)
plot(yrs, yearly(fbar(simsR$stock[, , , , , 1])), type = "n", las = 1, xlab = "", ylab = "Fbar",
     ylim = c(0, 1), main = "Fbar: truth and refits")
fbarRange <- ac(range(ple4)["minfbar"]:range(ple4)["maxfbar"])
for (i in seq_along(est)) lines(yrs, yearly(quantMeans(harvest(refits)[fbarRange, , , , , i])), col = "grey70")
lines(yrs, yearly(fbar(simsR$stock[, , , , , 1])), col = fitCols(1), lwd = 2)
legend("topleft", c("refits", "truth"), col = c("grey70", fitCols(1)), lwd = c(1, 2), bty = "n", cex = 0.8)
```

## 88. 

```sh
python3 - <<'EOF'
p='05-simulate-covariates.R'; s=open(p).read()
i=s.index('savePng("effect-recovery", {\n')+len('savePng("effect-recovery", {\n'); j=s.rindex("})")
body="\n".join(("  "+l if l.strip() else l) for l in s[i:j].rstrip("\n").split("\n"))+"\n"
s=s[:i]+body+s[j:]
open(p,'w').write(s)
EOF
tail -18 05-simulate-covariates.R; cd .. && printf '\n# plots written by the examples\nexamples/*/\n' >> .gitignore && tail -3 .gitignore
```

Output:

```
yrs <- as.numeric(years)
fbarRange <- ac(range(ple4)["minfbar"]:range(ple4)["maxfbar"])
savePng("effect-recovery", {
  par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
  plot(seq_along(est), est, ylim = range(est - 2 * estSE, est + 2 * estSE), pch = 16, las = 1,
       xlab = "simulation", ylab = "estimated temp effect on log F", main = "Refitted effect")
  segments(seq_along(est), est - 2 * estSE, seq_along(est), est + 2 * estSE)
  abline(h = log(1.2), col = fitCols(1), lwd = 2)
  legend("topleft", c("estimate +/- 2 se", "true value"), pch = c(16, NA), lwd = c(1, 2),
         col = c("black", fitCols(1)), bty = "n", cex = 0.8)

  plot(yrs, yearly(fbar(simsR$stock[, , , , , 1])), type = "n", las = 1, xlab = "", ylab = "Fbar",
       ylim = c(0, 1), main = "Fbar: truth and refits")
  for (i in seq_along(est)) lines(yrs, yearly(quantMeans(harvest(refits)[fbarRange, , , , , i])), col = "grey70")
  lines(yrs, yearly(fbar(simsR$stock[, , , , , 1])), col = fitCols(1), lwd = 2)
  legend("topleft", c("refits", "truth"), col = c("grey70", fitCols(1)), lwd = c(1, 2), bty = "n", cex = 0.8)
})

# plots written by the examples
examples/*/
```

## 89. 

```sh
rm -f Rplots.pdf; for f in 01 02 03 04 05; do s=$(ls examples/$f-*.R); ( Rscript -e "source('$s')" > /tmp/claude-0/ex/run$f.log 2>&1; echo "$f exit $? $(grep -c '^Error' /tmp/claude-0/ex/run$f.log) errors" ) & done; wait 2>/dev/null; ls Rplots.pdf 2>&1; find examples -name "*.png" | sort; grep -h "^saved" /tmp/claude-0/ex/run01.log; git status --short
```

Output:

```
01 exit 0 0 errors
03 exit 0 0 errors
02 exit 0 0 errors
04 exit 0 0 errors
05 exit 0 0 errors
ls: cannot access 'Rplots.pdf': No such file or directory
examples/01-getting-started/F-at-age.png
examples/01-getting-started/index-fit.png
examples/01-getting-started/residuals.png
examples/01-getting-started/stock-summary.png
examples/02-smoothers/F-surfaces.png
examples/02-smoothers/catchability.png
examples/02-smoothers/recruitment.png
examples/02-smoothers/selectivity.png
examples/02-smoothers/stock-summary.png
examples/03-covariates/covariates.png
examples/03-covariates/stock-summary.png
examples/04-stock-recruitment/cv-effect.png
examples/04-stock-recruitment/sr-curves.png
examples/05-simulate-covariates/effect-recovery.png
examples/05-simulate-covariates/predictive-check.png
examples/05-simulate-covariates/scenario.png
saved examples/01-getting-started/stock-summary.png
saved examples/01-getting-started/F-at-age.png
saved examples/01-getting-started/index-fit.png
saved examples/01-getting-started/residuals.png
 M .gitignore
 M examples/01-getting-started.R
 M examples/02-smoothers.R
 M examples/03-covariates.R
 M examples/04-stock-recruitment.R
 M examples/05-simulate-covariates.R
 M examples/helpers.R
```

## 90. 

```sh
cd /tmp/claude-0 && Rscript -e '
suppressMessages({library(RTMB); library(Matrix); library(mgcv)})
set.seed(1); n <- 200; x <- sort(runif(n)); y <- sin(2*pi*x) + rnorm(n, 0, 0.3)
sm <- smoothCon(s(x, k = 20, bs = "ps"), data.frame(x = x), absorb.cons = TRUE)[[1]]
X <- sm$X; S <- as(Matrix(sm$S[[1]], sparse = TRUE), "CsparseMatrix")
e <- eigen(sm$S[[1]], symmetric = TRUE); N <- e$vectors[, e$values < max(e$values) * 1e-8, drop = FALSE]
NN <- as(Matrix(tcrossprod(N), sparse = TRUE), "CsparseMatrix")
cat("k", ncol(X), "null", ncol(N), "\n")
f <- function(p) {
  getAll(p)
  Q <- exp(loglam) * S + NN
  mu <- a + X %*% u
  -sum(dnorm(y, mu, exp(logsd), log = TRUE)) - (dgmrf(u, 0, Q, log = TRUE) + 0.5 * sum((t(N) %*% u)^2))
}
obj <- MakeADFun(f, list(a = 0, u = numeric(ncol(X)), loglam = 0, logsd = 0), random = "u", silent = TRUE)
opt <- nlminb(obj$par, obj$fn, obj$gr)
cat("RTMB loglam", opt$par["loglam"], "sd", exp(opt$par["logsd"]), "\n")
g <- gam(y ~ s(x, k = 20, bs = "ps"), method = "REML")
cat("mgcv REML log sp (scaled by 1/sigma2):", log(g$sp / g$sig2), " sd", sqrt(g$sig2), "\n")
sr <- sdreport(obj, getJointPrecision = TRUE); cat("joint prec dim", dim(sr$jointPrecision), "\n")
'
```

Output:

```
k 19 null 1 
RTMB loglam 6.201504 sd 0.2955044 
mgcv REML log sp (scaled by 1/sigma2): 6.202401  sd 0.2962805 
joint prec dim 22 22
Shell cwd was reset to /home/user/FLa4a
```

## 91. 

```sh
sed -n 20,70p R/formula.R && sed -n 55,140p R/data.R
```

Output:

```
# Build the design matrix of a submodel together with a design object that
# can re-evaluate it for new data (e.g. new covariate values) with the same
# basis and columns: see predictDesign().
a4aDesign <- function(formula, df, tol = 1e-4) {
  opts <- options(contrasts = c(unordered = "contr.sum", ordered = "contr.poly"))
  on.exit(options(opts))

  key <- do.call(paste, df)
  udf <- df[!duplicated(key), , drop = FALSE]

  # A gam fitted to a constant response holds the basis; the fit itself is
  # irrelevant, so smoothing parameters are fixed to avoid estimating them.
  f <- stats::reformulate(deparse1(formula[[length(formula)]]), response = ".y")
  environment(f) <- asNamespace("FLa4a")
  gdata <- cbind(.y = 1, udf)
  nsp <- length(mgcv::gam(f, data = gdata, fit = FALSE)$sp)
  g <- mgcv::gam(f, data = gdata, sp = if (nsp) rep(1, nsp))

  design <- list(gam = slimGam(g), keep = NULL, formula = formula)
  X <- predictDesign(design, udf)

  # drop redundant columns
  qrX <- qr(X)
  drop <- qrX$pivot[abs(diag(qrX$qr)) < tol]
  if (length(drop)) {
    warning(deparse1(formula), " has ", length(drop), " redundant parameter(s), removing: ",
            paste(colnames(X)[drop], collapse = ", "), call. = FALSE)
  }
  design$keep <- setdiff(seq_len(ncol(X)), drop)

  list(X = X[match(key, do.call(paste, udf)), design$keep, drop = FALSE], design = design)
}

# Evaluate a submodel design matrix at new data.
predictDesign <- function(design, df) {
  X <- mgcv::predict.gam(design$gam, df, type = "lpmatrix", na.action = stats::na.pass)
  if (anyNA(X)) stop("NAs in covariates used by ", deparse1(design$formula), call. = FALSE)
  if (!is.null(design$keep)) X <- X[, design$keep, drop = FALSE]
  attr(X, "model.offset") <- NULL
  rownames(X) <- NULL
  X
}

# Keep only what predict.gam(type = "lpmatrix") needs.
slimGam <- function(g) {
  keep <- c("coefficients", "smooth", "nsdf", "pterms", "xlevels", "contrasts", "pred.formula",
            "model", "terms", "Xcentre", "var.summary",
... [truncated] ...
k)),
    matWt = c(mat(stock) * stock.wt(stock)), stkWt = c(stock.wt(stock)),
    stime = vapply(indices, surveyTime, numeric(1)),
    bmask = matrix(bmask, nA, length(indices)),
    plusgroup = !is.na(range(stock)["plusgroup"]),
    Xf = X$f, Xq = blockDiag(X$q), Xv = blockDiag(X$v), Xn1 = X$n1, Xr = X$r,
    Xsra = X$sra, Xsrb = X$srb,
    srID = if (is.null(sr$sr)) 0L else sr$sr$ID,
    srCV = if (is.null(sr$sr)) 0 else sr$sr$srrCV,
    spr0 = if (is.null(sr$sr)) 1 else sr$sr$SPR0,
    srAge = ages[1]
  )
  if (any(is.na(dat$M))) stop("m(stock) has missing values")

  par <- list(
    fpar  = numeric(ncol(X$f)),
    qpar  = numeric(ncol(dat$Xq)),
    vpar  = numeric(ncol(dat$Xv)),
    n1par = numeric(ncol(X$n1)),
    rpar  = numeric(ncol(X$r)),
    rapar = numeric(ncol(X$sra)),
    rbpar = numeric(ncol(X$srb))
  )

  pn <- function(prefix, X) if (ncol(X)) paste0(prefix, colnames(X)) else character(0)
  pnames <- c(
    pn("fMod:", X$f),
    unlist(lapply(fleets[-1], function(f) pn(paste0("qMod:", f, ":"), X$q[[f]]))),
    unlist(lapply(fleets, function(f) pn(paste0("vMod:", f, ":"), X$v[[f]]))),
    pn("n1Mod:", X$n1),
    pn("rMod:", X$r),
    pn("sraMod:", X$sra),
    pn("srbMod:", X$srb)
  )

  list(dat = dat, par = par, pnames = pnames, centering = centering, designs = designs,
       obs = obs[c("fleet", "year", "age")],
       ages = ages, years = years, fleets = fleets, nobs = nrow(obs))
}

# Observations of one fleet as a data.frame (age is NA for biomass indices).
```

## 92. 

```sh
sed -n 1,35p R/model.R; sed -n 60,72p R/model.R; sed -n 76,90p R/model.R
```

Output:

```
# The a4a statistical catch-at-age model as an RTMB objective function.
#
# Linear predictors (log scale) come from the submodel design matrices:
#   log F    = Xf  %*% fpar     (age x year)
#   log q    = Xq  %*% qpar     (age x year, one block per index)
#   log sd   = Xv  %*% vpar     (age x year, one block per fleet)
#   log N1   = Xn1 %*% n1par    (first year, ages 2+)
#   log R    = Xr  %*% rpar     (first age, all years)
# Observations are lognormal. An optional stock-recruitment relationship
# adds a lognormal penalty on recruitment around the curve.
a4aNll <- function(par, dat) {
  "[<-" <- ADoverload("[<-")
  nA <- dat$nA
  nY <- dat$nY
  nC <- nA * nY

  #------------------------------------------------------------------
  # submodels
  #------------------------------------------------------------------
  logF <- matrix(dat$Xf %*% par$fpar, nA, nY)
  logQ <- dat$Xq %*% par$qpar
  logV <- dat$Xv %*% par$vpar
  M <- matrix(dat$M, nA, nY)
  F <- exp(logF)
  Z <- F + M

  #------------------------------------------------------------------
  # population
  #------------------------------------------------------------------
  logN <- matrix(0, nA, nY)
  logN[1, ] <- dat$Xr %*% par$rpar
  if (nA > 1) {
    logN[-1, 1] <- dat$Xn1 %*% par$n1par
    for (y in seq_len(nY)[-1]) {
      logN[-1, y] <- logN[-nA, y - 1] - Z[-nA, y - 1]
    pred[i] <- log(sum(B * dat$bmask[, s]))
  }

  sdObs <- exp(logV[(fleet - 1) * nC + cell])
  nllObs <- -dat$w * dnorm(dat$obs, pred, sdObs, log = TRUE)
  # likelihood components: one per fleet, plus one for the SR model
  nllComp <- numeric(dat$nS + 1 + (dat$srID > 0))
  for (f in seq_len(dat$nS + 1)) nllComp[f] <- sum(nllObs[fleet == f])

  #------------------------------------------------------------------
  # stock-recruitment relationship
  #------------------------------------------------------------------
  if (dat$srID > 0) {
    lag <- if (dat$srID == 4) 1 else dat$srAge
    yrs <- seq(1 + lag, nY)
    S <- if (dat$srID != 4) ssb[yrs - dat$srAge]
    a <- (dat$Xsra %*% par$rapar)[yrs]
    b <- if (length(par$rbpar)) (dat$Xsrb %*% par$rbpar)[yrs] else 0
    predLogR <- switch(dat$srID,
      a + log(S) - log(exp(b) + S),                                           # bevholt
      a + log(S) - exp(b) * S,                                                # ricker
      a + log(S + sqrt(exp(2 * b) + 0.0025) - sqrt((S - exp(b))^2 + 0.0025)), # hockey
      a,                                                                      # geomean
      {                                                                       # bevholtSV
        h <- 0.2 + 0.8 / (1 + exp(-a))
        v <- exp(b)
        log(6 * h * v * S) - log(dat$spr0 * ((h + 1) * v + (5 * h - 1) * S))
      })
```

## 93. 

```sh
python3 - <<'EOF'
p='R/model.R'; s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a[:50]
    s=s.replace(a,b)
rep('''# Linear predictors (log scale) come from the submodel design matrices:
#   log F    = Xf  %*% fpar     (age x year)
#   log q    = Xq  %*% qpar     (age x year, one block per index)
#   log sd   = Xv  %*% vpar     (age x year, one block per fleet)
#   log N1   = Xn1 %*% n1par    (first year, ages 2+)
#   log R    = Xr  %*% rpar     (first age, all years)
# Observations are lognormal. An optional stock-recruitment relationship
# adds a lognormal penalty on recruitment around the curve.
a4aNll <- function(par, dat) {
  "[<-" <- ADoverload("[<-")
  nA <- dat$nA
  nY <- dat$nY
  nC <- nA * nY

  #------------------------------------------------------------------
  # submodels
  #------------------------------------------------------------------
  logF <- matrix(dat$Xf %*% par$fpar, nA, nY)
  logQ <- dat$Xq %*% par$qpar
  logV <- dat$Xv %*% par$vpar''','''# Linear predictors (log scale) come from the submodel design matrices:
#   log F    = Xf  %*% fpar  + Zf  %*% re[if]    (age x year)
#   log q    = Xq  %*% qpar  + Zq  %*% re[iq]    (age x year, one block per index)
#   log sd   = Xv  %*% vpar  + Zv  %*% re[iv]    (age x year, one block per fleet)
#   log N1   = Xn1 %*% n1par + Zn1 %*% re[in1]   (first year, ages 2+)
#   log R    = Xr  %*% rpar  + Zr  %*% re[ir]    (first age, all years)
# X holds unpenalised columns and Z the columns of penalised smoothers,
# whose coefficients `re` are random effects with a Gaussian prior of
# precision sum_j lambda_j S_j (see penaltyNll()).
# Observations are lognormal. An optional stock-recruitment relationship
# adds a lognormal penalty on recruitment around the curve.
a4aNll <- function(par, dat) {
  "[<-" <- ADoverload("[<-")
  nA <- dat$nA
  nY <- dat$nY
  nC <- nA * nY
  lp <- function(key, b) {
    eta <- dat[[paste0("X", key)]] %*% b
    i <- dat[[paste0("i", key)]]
    if (length(i)) eta <- eta + dat[[paste0("Z", key)]] %*% par$re[i]
    eta
  }

  #------------------------------------------------------------------
  # submodels
  #------------------------------------------------------------------
  logF <- matrix(lp("f", par$fpar), nA, nY)
  logQ <- lp("q", par$qpar)
  logV <- lp("v", par$vpar)''')
rep('''  logN[1, ] <- dat$Xr %*% par$rpar
  if (nA > 1) {
    logN[-1, 1] <- dat$Xn1 %*% par$n1par''','''  logN[1, ] <- lp("r", par$rpar)
  if (nA > 1) {
    logN[-1, 1] <- lp("n1", par$n1par)''')
rep('''  # likelihood components: one per fleet, plus one for the SR model
  nllComp <- numeric(dat$nS + 1 + (dat$srID > 0))''','''  # likelihood components: one per fleet, then the SR model and smoothers
  nllComp <- numeric(dat$nS + 1 + (dat$srID > 0) + (length(dat$blocks) > 0))''')
rep('''    a <- (dat$Xsra %*% par$rapar)[yrs]
    b <- if (length(par$rbpar)) (dat$Xsrb %*% par$rbpar)[yrs] else 0''','''    a <- lp("sra", par$rapar)[yrs]
    b <- if (length(par$rbpar) || length(dat$isrb)) lp("srb", par$rbpar)[yrs] else 0''')
rep('''  REPORT(logF)''','''  #------------------------------------------------------------------
  # penalised smoothers
  #------------------------------------------------------------------
  if (length(dat$blocks)) nllComp[length(nllComp)] <- penaltyNll(par, dat$blocks)

  REPORT(logF)''')
s=s.replace('''# Fit the model to one iteration of data.''','''# Negative log prior of the penalised smoothers. Each block's coefficients u
# have an (improper) Gaussian prior with precision Q = sum_j lambda_j S_j,
#   log p(u) = 0.5 log|Q|+ - 0.5 u' Q u - r/2 log(2 pi),   r = rank(Q),
# with a flat prior on the null space of Q (the unpenalised directions).
# The pseudo-determinant is |Q + N N'| for N an orthonormal basis of the
# null space, so dgmrf() on the sparse Q + N N' gives the density once the
# N N' term of its quadratic form is added back.
penaltyNll <- function(par, blocks) {
  nll <- 0
  for (b in blocks) {
    u <- par$re[b$idx]
    Q <- exp(par$loglambda[b$lam[1]]) * b$S[[1]]
    for (j in seq_along(b$S)[-1]) Q <- Q + exp(par$loglambda[b$lam[j]]) * b$S[[j]]
    if (ncol(b$N)) {
      Nu <- t(b$N) %*% u
      nll <- nll - dgmrf(u, 0, Q + b$NN, log = TRUE) - 0.5 * sum(Nu * Nu) -
        0.5 * ncol(b$N) * log(2 * pi)
    } else {
      nll <- nll - dgmrf(u, 0, Q, log = TRUE)
    }
  }
  nll
}

# Fit the model to one iteration of data.''')
open(p,'w').write(s)
EOF
sed -i "s/^#' @importFrom RTMB MakeADFun ADoverload REPORT dnorm logspace_add matrix colSums$/#' @importFrom RTMB MakeADFun ADoverload REPORT dnorm dgmrf logspace_add matrix colSums sdreport/" R/FLa4a-package.R; grep importFrom R/FLa4a-package.R; sed -n '/^# Fit the model to one iteration/,$p' R/model.R
```

Output:

```
#' @importFrom RTMB MakeADFun ADoverload REPORT dnorm dgmrf logspace_add matrix colSums sdreport
# Fit the model to one iteration of data. Returns estimates, the covariance
# matrix of the parameters (fit = "assessment") and the reported quantities.
fitA4a <- function(data, fit = "assessment", verbose = FALSE, control = list()) {
  dat <- data$dat
  obj <- MakeADFun(function(p) a4aNll(p, dat), data$par, silent = !verbose)

  opt <- stats::nlminb(obj$par, obj$fn, obj$gr,
                       control = utils::modifyList(list(eval.max = 1e4, iter.max = 1e4), control))
  par <- opt$par

  # a few Newton steps to polish the optimum
  maxgrad <- function(p) max(abs(obj$gr(p)))
  for (i in 1:3) {
    step <- tryCatch(solve(obj$he(par), drop(obj$gr(par))), error = function(e) NULL)
    if (is.null(step) || !is.finite(obj$fn(par - step)) || maxgrad(par - step) >= maxgrad(par)) break
    par <- par - step
  }
  names(par) <- data$pnames

  convergence <- opt$convergence
  vcov <- NULL
  if (fit == "assessment") {
    H <- obj$he(par)
    vcov <- tryCatch(chol2inv(chol(H)), error = function(e) NULL)
    if (is.null(vcov)) {
      warning("Hessian is not positive definite", call. = FALSE)
      vcov <- matrix(NA_real_, length(par), length(par))
      convergence <- 1L
    }
    dimnames(vcov) <- list(data$pnames, data$pnames)
  }

  list(par = par, vcov = vcov, report = obj$report(par),
       nlogl = obj$fn(par), maxgrad = maxgrad(par),
       convergence = convergence)
}
```

## 94. 

```sh
python3 - <<'EOF'
p='R/sca.R'; s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a[:50]
    s=s.replace(a,b)
rep("""#' The model is written in R and differentiated with 'RTMB'. Each iteration
#' of `stock` and `indices` is fitted independently.
#'""","""#' The model is written in R and differentiated with 'RTMB'. Each iteration
#' of `stock` and `indices` is fitted independently.
#'
#' By default smoothers are unpenalised regression splines whose flexibility
#' is set by the basis dimension `k`. With `penalise`, smoothers are
#' penalised and their smoothing parameters are estimated: the smoother
#' coefficients are random effects with a Gaussian prior whose precision is
#' the smoothing-parameter weighted sum of the smoother's penalty matrices
#' (as in 'mgcv'), integrated out with the Laplace approximation, and the
#' log smoothing parameters maximise the marginal likelihood (as REML). `k`
#' then only needs to be large enough. This works for `s()` (e.g. P-splines,
#' `bs = "ps"`), `te()`, `ti()` and `t2()`; `fx = TRUE` keeps a smoother
#' unpenalised.
#'""")
rep("""#' @param verbose logical, print optimiser output.""","""#' @param penalise `TRUE` to penalise the smoothers of all submodels, or the
#'   names of the submodels to penalise, e.g. `"fmodel"` or
#'   `c("fmodel", "srmodel")`. Default `FALSE`.
#' @param verbose logical, print optimiser output.""")
rep("""#' @return an [a4aFit-class] object.""","""#' @return an [a4aFit-class] object. For penalised fits, `fitSumm()`
#'   reports the effective degrees of freedom of each smoother (`edf:`), the
#'   marginal negative log-likelihood (`nlogl:marginal`), and `nopar` counts
#'   unpenalised parameters plus the smoothers' effective degrees of freedom,
#'   so that `AIC()` is a conditional AIC. The log smoothing parameters are in
#'   `smoothing()`.""")
rep("""#' stk <- ple4 + fit
#' @export""","""#' stk <- ple4 + fit
#'
#' # penalised smoothers: a flexible basis, smoothness estimated
#' pfit <- sca(ple4, ple4.index,
#'             fmodel = ~ te(age, year, k = c(6, 30), bs = "ps"),
#'             qmodel = list(~ s(age, k = 6, bs = "ps")), penalise = TRUE)
#' smoothing(pfit)
#' @export""")
rep("""                covar = NULL, fit = c("assessment", "MP"), center = TRUE,
                verbose = FALSE, control = list()) {

  fit <- match.arg(fit)""","""                covar = NULL, fit = c("assessment", "MP"), center = TRUE,
                penalise = FALSE, verbose = FALSE, control = list()) {

  fit <- match.arg(fit)
  penalise <- penaliseKeys(penalise)""")
rep("""                    center = center)
    res <- fitA4a(""","""                    center = center, penalise = penalise)
    res <- fitA4a(""")
rep("""    design = first$data$designs, covar = covar)

  summNames <- c("nopar", "nlogl", "maxgrad", "nobs", "convergence",
                 paste0("nlogl:", c(fleets, if (length(first$report$nllComp) > length(fleets)) "srr")))""","""    design = first$data$designs, covar = covar,
    smoothing = matrix(NA_real_, length(first$loglambda), nit,
                       dimnames = list(names(first$loglambda), iter = seq_len(nit))))

  penalised <- length(first$edf) > 0
  comps <- c(fleets, if (first$data$dat$srID > 0) "srr", if (penalised) "smooth")
  summNames <- c("nopar", "nlogl", "maxgrad", "nobs", "convergence", paste0("nlogl:", comps),
                 if (penalised) c("nlogl:marginal", paste0("edf:", names(first$edf))))""")
rep("""    out@fitSumm[, i] <- c(length(f$par), f$nlogl, f$maxgrad, f$data$nobs, f$convergence,
                          f$report$nllComp)""","""    out@smoothing[, i] <- f$loglambda
    out@fitSumm[, i] <- c(f$nopar, f$nlogl, f$maxgrad, f$data$nobs, f$convergence,
                          f$report$nllComp, if (penalised) c(f$objective, f$edf))""")
rep("""# Indices as a named FLIndices""","""# Submodel keys (as used by a4aData) to penalise, from sca()'s `penalise`.
penaliseKeys <- function(penalise) {
  keys <- list(fmodel = "f", qmodel = "q", vmodel = "v", n1model = "n1", srmodel = c("r", "sra", "srb"))
  if (isTRUE(penalise)) return(unlist(keys, use.names = FALSE))
  if (isFALSE(penalise) || !length(penalise)) return(character(0))
  bad <- setdiff(penalise, names(keys))
  if (length(bad)) stop("penalise must be TRUE, FALSE or submodel names: ", paste(names(keys), collapse = ", "))
  unlist(keys[penalise], use.names = FALSE)
}

# Indices as a named FLIndices""")
open(p,'w').write(s)

p='R/a4aFit-class.R'; s=open(p).read()
s=s.replace("""#' @slot covar the covariates used in the fit.
#' @export""","""#' @slot covar the covariates used in the fit.
#' @slot smoothing log smoothing parameters of penalised smoothers
#'   (penalty x iter); empty for unpenalised fits.
#' @export""")
s=s.replace("""            models = "list", design = "list", covar = "list"))""","""            models = "list", design = "list", covar = "list", smoothing = "matrix"))""")
s=s.replace("""#' @rdname a4aFit-class
#' @details `logLik()` returns""","""#' @rdname a4aFit-class
#' @export
setGeneric("smoothing", function(object, ...) standardGeneric("smoothing"))
#' @rdname a4aFit-class
#' @export
setMethod("smoothing", "a4aFit", function(object) object@smoothing)

#' @rdname a4aFit-class
#' @details `logLik()` returns""")
open(p,'w').write(s)
EOF
grep -n "logLik" -A6 R/a4aFit-class.R | head -12
```

Output:

```
66:#' @details `logLik()` returns the maximised log-likelihood (one value per
67-#'   iteration), so `AIC()` and `BIC()` work on fits.
68-#' @export
69:setMethod("logLik", "a4aFit", function(object, ...) {
70-  structure(-object@fitSumm["nlogl", ],
71-            df = object@fitSumm["nopar", 1], nobs = object@fitSumm["nobs", 1],
72:            class = "logLik")
73-})
74-
75-#' @rdname a4aFit-class
76-#' @export
77-setMethod("show", "a4aFit", function(object) {
```

## 95. 

```sh
python3 - <<'EOF'
p='R/simulate.R'; s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a[:50]
    s=s.replace(a,b)
rep("""  predictQuants(list(report = m$obj$report(m$par)), m$data""","""  predictQuants(list(report = m$report(m$par)), m$data""")
rep("""    rep <- m$obj$report(pars[i, ])""","""    rep <- m$report(pars[i, ])""")
rep("""  list(data = data, obj = obj, par = c(coef(object)[, 1]))""","""  # evaluate the model at a coefficient vector (in design column order), with
  # penalised smoother coefficients and log smoothing parameters as fitted
  lam <- if (length(object@smoothing)) object@smoothing[, 1] else numeric(0)
  report <- function(coefs) {
    p <- numeric(length(obj$par))
    p[data$colmap$pos] <- coefs
    p[length(p) - length(lam) + seq_along(lam)] <- lam
    obj$report(p)
  }
  list(data = data, report = report, par = c(coef(object)[, 1]))""")
open(p,'w').write(s)
EOF
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "writ\|warn\|error"; R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1; Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -15
```

Output:

```
Writing 'NAMESPACE'
Writing 'NAMESPACE'
Writing 'a4aFit-class.Rd'
Writing 'sca.Rd'
* DONE (FLa4a)
getX: ..........
sca: ................................
simulate: ............................

== DONE ========================================================================
```

## 96. 

```sh
cd /tmp/claude-0 && cat > pen1.R <<'EOF'
suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
tm <- function(expr) { t0 <- Sys.time(); r <- expr; cat(sprintf("  [%.1fs]\n", as.numeric(Sys.time() - t0, units = "secs"))); r }
cat("1D: F ~ s(age) + s(year, k=40, ps) penalised\n")
f1 <- tm(sca(ple4, idx, fmodel = ~ s(age, k = 6) + s(year, k = 40, bs = "ps"),
          qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)), penalise = "fmodel"))
print(t(fitSumm(f1))); print(smoothing(f1))
cat("2D: F ~ te(age, year, k=c(6,30), ps) penalised\n")
f2 <- tm(sca(ple4, idx, fmodel = ~ te(age, year, k = c(6, 30), bs = "ps"),
          qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)), penalise = "fmodel"))
print(t(fitSumm(f2))); print(smoothing(f2)); cat("vcov NA:", anyNA(vcov(f2)), "\n")
cat("unpenalised te k=c(5,20) AIC", AIC(sca(ple4, idx, fmodel = ~ te(age, year, k = c(5, 20)), qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)))), " penalised AIC", AIC(f2), "\n")
EOF
Rscript pen1.R 2>&1 | tail -40
```

Output:

```
1D: F ~ s(age) + s(year, k=40, ps) penalised
  [28.6s]
    
iter    nopar    nlogl     maxgrad nobs convergence nlogl:catch
   1 104.3332 304.0873 0.005903092 1123           0   -240.3768
    
iter nlogl:BTS-Combined (all) nlogl:SNS nlogl:smooth nlogl:marginal
   1                 171.3883  373.0758    -46.36417       373.4644
    
iter edf:fMod:s(age) edf:fMod:s(year)
   1        4.953583          20.3796
              iter
                       1
  fMod:s(age)  -1.373102
  fMod:s(year)  7.446447
2D: F ~ te(age, year, k=c(6,30), ps) penalised
  [556.6s]
    
iter   nopar     nlogl     maxgrad nobs convergence nlogl:catch
   1 233.544 -387.1785 0.003897549 1123           1   -846.1763
    
iter nlogl:BTS-Combined (all) nlogl:SNS nlogl:smooth nlogl:marginal
   1                 67.92157  391.0763    -90.92437        27.7724
    
iter edf:fMod:te(age,year)
   1               154.544
                     iter
                              1
  fMod:te(age,year):1 -8.713400
  fMod:te(age,year):2  3.246158
vcov NA: FALSE 
unpenalised te k=c(5,20) AIC 337.9002  penalised AIC -307.2691
Shell cwd was reset to /home/user/FLa4a
```

## 97. 

```sh
cd /tmp/claude-0 && cat > prof.R <<'EOF'
suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- FLa4a:::prepIndices(ple4.indices[c("BTS-Combined (all)", "SNS")])
d <- FLa4a:::a4aData(ple4, idx, ~ te(age, year, k = c(6, 30), bs = "ps"), list(~ s(age, k = 5), ~ s(age, k = 4)),
  defaultVmod(ple4, idx), defaultN1mod(ple4), ~ factor(year), penalise = "f")
cat("n re", length(d$par$re), " n fixed", length(unlist(d$par)) - length(d$par$re), "\n")
print(names(formals(RTMB::MakeADFun)))
tm <- function(label, expr) { t0 <- Sys.time(); r <- expr; cat(sprintf("%-28s %.2fs\n", label, as.numeric(Sys.time() - t0, units = "secs"))); invisible(r) }
tm("tape (no random)", o0 <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, silent = TRUE))
tm("fn+gr (no random) x10", for (i in 1:10) { o0$fn(); o0$gr() })
tm("tape (random)", o1 <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, random = "re", silent = TRUE))
tm("fn (random) first", o1$fn())
tm("fn (random) again", o1$fn())
tm("gr (random)", o1$gr())
tm("spHess", H <- o1$env$spHess(o1$env$last.par, random = TRUE)); cat("H nnz fraction", length(H@x) / prod(dim(H)), "\n")
EOF
Rscript prof.R 2>&1 | tail -14
```

Output:

```
The server-side auto mode classifier gave no verdict (error), so auto mode cannot determine the safety of Bash. This is a transient failure of the check, not a judgment about the action: a later response may get a verdict. You may try the action again once, as-is. Repeated attempts are slowed by a growing delay, and after 10 responses in a row without a verdict the turn stops. If it keeps failing, continue with other tasks that don't require this action and come back to it later. Note: reading files, searching code, and other read-only operations do not require the classifier and can still be used.
```

## 98. 

```sh
cd /tmp/claude-0 && Rscript prof.R 2>&1 | tail -14
```

Output:

```
The server-side auto mode classifier gave no verdict (error), so auto mode cannot determine the safety of Bash. This is a transient failure of the check, not a judgment about the action: a later response may get a verdict. You may try the action again once, as-is. Repeated attempts are slowed by a growing delay, and after 10 responses in a row without a verdict the turn stops. If it keeps failing, continue with other tasks that don't require this action and come back to it later. Note: reading files, searching code, and other read-only operations do not require the classifier and can still be used.
```

## 99. 

```sh
cd /tmp/claude-0 && Rscript prof.R 2>&1 | tail -14
```

Output:

```
The server-side auto mode classifier gave no verdict (error), so auto mode cannot determine the safety of Bash. This is a transient failure of the check, not a judgment about the action: a later response may get a verdict. You may try the action again once, as-is. Repeated attempts are slowed by a growing delay, and after 10 responses in a row without a verdict the turn stops. If it keeps failing, continue with other tasks that don't require this action and come back to it later. Note: reading files, searching code, and other read-only operations do not require the classifier and can still be used.
```

## 100. 

```sh
cd /tmp/claude-0 && Rscript prof.R 2>&1 | tail -14
```

Output:

```
The server-side auto mode classifier gave no verdict (error), so auto mode cannot determine the safety of Bash. This is a transient failure of the check, not a judgment about the action: a later response may get a verdict. You may try the action again once, as-is. Repeated attempts are slowed by a growing delay, and after 10 responses in a row without a verdict the turn stops. If it keeps failing, continue with other tasks that don't require this action and come back to it later. Note: reading files, searching code, and other read-only operations do not require the classifier and can still be used.
```

## 101. 

```sh
cd /tmp/claude-0 && Rscript prof.R 2>&1 | tail -14
```

Output:

```
n re 179  n fixed 81 
 [1] "func"          "parameters"    "random"        "profile"      
 [5] "integrate"     "intern"        "map"           "ADreport"     
 [9] "silent"        "ridge.correct" "..."          
tape (no random)             0.28s
fn+gr (no random) x10        0.06s
tape (random)                0.43s
fn (random) first            47.49s
fn (random) again            0.01s
gr (random)                  0.62s
spHess                       0.00s
H nnz fraction 0.5027933
Shell cwd was reset to /home/user/FLa4a
```

## 102. 

```sh
cd /tmp/claude-0 && Rscript prof2.R 1d 2>&1 | tail -8
```

Output:

```
stage 1 (lambda fixed, no Laplace)   0.57s
stage 2a Laplace (warm start)       18.52s
  obj 373.4644 conv 0 relative convergence (4) iters 297 
  loglam -1.373099 7.446453 
stage 2b Laplace + profile          10.74s
  obj 373.8711 conv 0 relative convergence (4) iters 7 npar outer 2 
  loglam -1.373067 7.479254
Shell cwd was reset to /home/user/FLa4a
```

## 103. 

```sh
cd /tmp/claude-0 && timeout 900 Rscript prof2.R 2>&1 | tail -8
```

Output:

```
Command did not complete within its 600s timeout and was moved to the background (ID: bxti774vs). Output is being written to: /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/bxti774vs.output. You will be notified when it completes. To check interim output, use Read on that file path.
Session cwd remains /home/user/FLa4a; directory changes made by the backgrounded command do not apply to subsequent commands.
```

## 104. 

```sh
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "writ\|warn\|error"; R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && timeout 1200 Rscript /tmp/claude-0/pen2.R 2>&1 | tail -14
```

Output:

```
Writing 'NAMESPACE'
Writing 'sca.Rd'
* DONE (FLa4a)
1D efs                        6.5s
   loglambda: -1.372 7.349  edf: 4.96 20.98  marginal: 373.905  AIC: 814.7  conv: 0  maxgrad: 0.0013 
1D laplace                   20.7s
   loglambda: -1.373 7.446  edf: 4.95 20.38  marginal: 373.464  AIC: 816.8  conv: 0  maxgrad: 24 
2D efs                      273.8s
   loglambda: -8.81 2.592  edf: 163.56  marginal: 108.29  AIC: -611.2  conv: 1  maxgrad: 0.64 
2D efs, all submodels       100.0s
   loglambda: -8.812 6.287 7.153 1.86 0.547 25 1.443  edf: 65.04 2.16 3.11 1.79 1 35.73  marginal: 742.251  AIC: 1232.9  conv: 1  maxgrad: 1.5
```

## 105. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && timeout 1200 Rscript /tmp/claude-0/pen2.R 2>&1 | tail -10
```

Output:

```
* DONE (FLa4a)
1D efs                        9.9s
   loglambda: -1.372 7.349  edf: 4.96 20.98  marginal: 373.906  AIC: 814.7  conv: 0  maxgrad: 1.9e-12 
1D laplace                   26.4s
   loglambda: -1.373 7.446  edf: 4.95 20.38  marginal: 373.464  AIC: 816.8  conv: 0  maxgrad: 0.00097 
Error in while (!(fn(x - t * step) <= f0) && t > 1e-04) t <- t/2 : 
  missing value where TRUE/FALSE needed
Calls: tm ... lapply -> FUN -> fitA4a -> fitSmoothing -> fitGivenLambda
Execution halted
```

## 106. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && Rscript /tmp/claude-0/prof3.R 2>&1 | tail -8
```

Output:

```
* DONE (FLa4a)
fn                          0.003s
gr                          0.008s
he                          2.901s
he again                    2.168s
n par 260 
Object of class='Tape'
 : R^260 -> R^1
```

## 107. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && Rscript /tmp/claude-0/hess.R 2>&1 | tail -9
```

Output:

```
* DONE (FLa4a)
dense AD Hessian            2.540s
build sparse Hessian tape   1.348s
sparse Hessian (1st)        0.268s
sparse Hessian (2nd)        0.447s
max abs difference 1344  relative 5.161121e-15 
objective at p equal after refactor check: 7.188205e+13
```

## 108. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && timeout 1500 Rscript /tmp/claude-0/pen2.R 2>&1 | tail -10
```

Output:

```
* DONE (FLa4a)
1D efs                        4.9s
   loglambda: -1.372 7.349  edf: 4.96 20.98  marginal: 373.906  AIC: 814.7  conv: 0  maxgrad: 8.1e-12 
1D laplace                   22.0s
   loglambda: -1.373 7.446  edf: 4.95 20.38  marginal: 373.464  AIC: 816.8  conv: 0  maxgrad: 0.001 
2D efs                       72.0s
Warning message:
Hessian is not positive definite 
   loglambda: -8.031 3.228  edf: 155.1  marginal: 119.157  AIC: -369.8  conv: 1  maxgrad: 4300 
2D efs, all submodels        31.8s
   loglambda: -8.85 6.327 7.155 1.858 0.594 25 1.444  edf: 64.64 2.16 3.11 1.78 1 35.73  marginal: 742.21  AIC: 1233.5  conv: 0  maxgrad: 1.5e-08
```

## 109. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && timeout 1500 Rscript /tmp/claude-0/pen3.R 2>&1 | tail -14
```

Output:

```
* DONE (FLa4a)
    
iter    nopar     nlogl      maxgrad nobs convergence nlogl:catch
   1 242.5549 -548.1877 3.211115e-07 1123           0    -1017.15
    
iter nlogl:BTS-Combined (all) nlogl:SNS nlogl:smooth nlogl:marginal
   1                 75.77963  393.1825    -42.09134        108.363
    
iter edf:fMod:te(age,year)
   1              163.5549
                     iter
                              1
  fMod:te(age,year):1 -8.810276
  fMod:te(age,year):2  2.592502
catch residual sd 0.1321507
```

## 110. 

```sh
timeout 1500 Rscript /tmp/claude-0/pen3.R 2>&1 | grep secs
```

Output:

```
secs 61.6
```

## 111. 

```sh
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "writ\|warn\|error"; R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1; timeout 1500 Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -25
```

Output:

```
* DONE (FLa4a)
getX: ..........
penalised: .........12...........
sca: ................................
simulate: ............................

== Failed ======================================================================
-- 1. Failure ('test-penalised.R:25:3'): unpenalised smoothers and submodels are
rownames(smoothing(f1)) (`actual`) not equal to c("fMod:s(year)", "qMod:index:s(age)") (`expected`).

    actual                           | expected               
[1] "fMod:s(year)"                   | "fMod:s(year)"      [1]
[2] "qMod:BTS-Combined (all):s(age)" - "qMod:index:s(age)" [2]
[3] "vMod:catch:s(age)"              -                        
[4] "n1Mod:s(age)"                   -                        

-- 2. Failure ('test-penalised.R:28:3'): unpenalised smoothers and submodels are
rownames(smoothing(f2)) (`actual`) not equal to "qMod:index:s(age)" (`expected`).

`actual`:   "qMod:BTS-Combined (all):s(age)"
`expected`: "qMod:index:s(age)"             

== DONE ========================================================================
Error: Test failures
Execution halted
```

## 112. 

```sh
timeout 1500 Rscript -e 'testthat::test_local(".", filter = "penalised", reporter = "summary")' 2>&1 | tail -6
```

Output:

```
penalised: ......................

== DONE ========================================================================
```

## 113. 

```sh
timeout 1500 Rscript -e "t0 <- Sys.time(); source('examples/06-penalised-smoothers.R'); cat('TIME', round(as.numeric(Sys.time() - t0, units = 'secs')), 's\n')" 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -40
```

Output:

```
k = 40, unpenalised 122.000 331.529 907.059 15.922 1519.957 112.069       0
k = 10, unpenalised  92.000 386.762 957.525 66.388 1419.711  11.822       0
                    converged
k = 40, penalised           1
k = 40, unpenalised         1
k = 10, unpenalised         1
              iter
                       1
  fMod:s(age)  -1.173816
  fMod:s(year)  7.511441
 edf:fMod:s(age) edf:fMod:s(year) 
        3.963858        19.897685 
                   efs   laplace
fMod:s(age)  -1.173816 -1.202086
fMod:s(year)  7.511441  7.612812
saved examples/06-penalised-smoothers/fbar-1d.png
saved examples/06-penalised-smoothers/F-age4-uncertainty.png
                                            npar   nlogl      AIC    dAIC
te(age, year, k = c(5, 20)), unpenalised 178.000  -9.050  337.900   0.000
te(age, year, k = c(6, 30)), penalised   116.413 500.314 1233.454 895.554
                                              BIC    dBIC maxgrad converged
te(age, year, k = c(5, 20)), unpenalised 1232.129   0.000       0         1
te(age, year, k = c(6, 30)), penalised   1818.283 586.153       0         1
                               loglambda
fMod:te(age,year):1                -8.85
fMod:te(age,year):2                 6.33
qMod:BTS-Combined (all):s(age)      7.16
qMod:SNS:s(age)                     1.86
vMod:catch:s(age)                   0.59
n1Mod:s(age)                       25.00
rMod:s(year)                        1.44
             edf:fMod:te(age,year) edf:qMod:BTS-Combined (all):s(age) 
                             64.64                               2.16 
               edf:qMod:SNS:s(age)              edf:vMod:catch:s(age) 
                              3.11                               1.78 
                  edf:n1Mod:s(age)                   edf:rMod:s(year) 
                              1.00                              35.73 
saved examples/06-penalised-smoothers/F-surfaces-2d.png
saved examples/06-penalised-smoothers/stock-summary.png
TIME 81 s
```

## 114. 

```sh
cd /tmp/claude-0 && timeout 1400 Rscript pen4.R > pen4.log 2>&1; cat pen4.log | tail -20
```

Output:

```
Command running in background with ID: bikpswf4s. Output is being written to: /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/bikpswf4s.output. You will be notified when it completes. To check interim output, use Read on that file path.
Session cwd remains /home/user/FLa4a; directory changes made by the backgrounded command do not apply to subsequent commands.
```

## 115. 

```sh
python3 - <<'EOF'
p='README.md'; s=open(p).read()
old="""For penalised smoothers, mgcv's identifiability constraint makes P-spline
bases dense (keeping them sparse is a possible next step), and when the
observation variance is also estimated a very flexible F surface can trade
off against catch observation error.
"""
new="""For penalised smoothers, mgcv's identifiability constraint makes P-spline
bases dense (keeping them sparse is a possible next step). With a single
penalised `te(age, year)` F surface, the marginal likelihood for ple4
favours very little smoothing across ages, so F follows the catch data
closely; separable main effects plus a penalised `ti(age, year)`
interaction are faster and better behaved (see `examples/06-penalised-smoothers.R`).
"""
assert s.count(old)==1
open(p,'w').write(s.replace(old,new))
EOF
rm -rf examples/06-penalised-smoothers; timeout 1400 Rscript -e "t0 <- Sys.time(); source('examples/06-penalised-smoothers.R'); cat('TIME', round(as.numeric(Sys.time() - t0, units = 'secs')), 's\n')" 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -22
```

Output:

```
        3.963858        19.897685 
                   efs   laplace
fMod:s(age)  -1.173816 -1.202113
fMod:s(year)  7.511441  7.612823
saved examples/06-penalised-smoothers/fbar-1d.png
saved examples/06-penalised-smoothers/F-age4-uncertainty.png
                                               npar   nlogl     AIC    dAIC
s(age) + s(year) + ti(age, year), penalised 151.344 -34.807 233.073   0.000
te(age, year, k = c(5, 20)), unpenalised    178.000  -9.050 337.900 104.827
                                                 BIC    dBIC maxgrad converged
s(age) + s(year) + ti(age, year), penalised  993.387   0.000       0         1
te(age, year, k = c(5, 20)), unpenalised    1232.129 238.742       0         1
                    loglambda
fMod:s(age)              0.16
fMod:s(year)             5.77
fMod:ti(age,year):1     -3.93
fMod:ti(age,year):2      1.86
      edf:fMod:s(age)      edf:fMod:s(year) edf:fMod:ti(age,year) 
                 4.97                 22.17                 45.20 
saved examples/06-penalised-smoothers/F-surfaces-2d.png
saved examples/06-penalised-smoothers/stock-summary.png
TIME 59 s
```

## 116. 

```sh
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "writ\|warn\|error"; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 timeout 1800 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status|examples|tests" -A5 | head -30
```

Output:

```
Writing 'sca.Rd'
* checking for unstated dependencies in examples ... OK
* checking examples ... OK
* checking for unstated dependencies in ‘tests’ ... OK
* checking tests ...
  Running ‘testthat.R’
 OK
* DONE

Status: OK
Shell cwd was reset to /home/user/FLa4a
```

## 117. 

```sh
git status --short && git add R man NAMESPACE NEWS.md README.md tests && git commit -q -m "Add penalised smoothers with estimated smoothing parameters

sca(..., penalise = TRUE) (or naming submodels) penalises s(), te(), ti()
and t2() smoothers. Their coefficients get a Gaussian prior with precision
sum_j lambda_j S_j (mgcv's penalty matrices; flat on the null space, with
the pseudo-determinant from RTMB's sparse dgmrf), and the smoothing
parameters maximise the Laplace approximation of the marginal likelihood:

- sp.method = \"efs\" (default): extended Fellner-Schall updates (Wood and
  Fasiolo 2017) with warm-started Newton inner fits
- sp.method = \"laplace\": RTMB's Laplace approximation with the smoother
  coefficients as random effects, started from the Fellner-Schall fit

The likelihood is now computed from the submodels' linear predictors, so
the Hessian is A' H_eta A + Q_lambda with H_eta a sparse Hessian (from a
sparse Hessian tape) of the likelihood in the linear predictors, several
times faster than the dense AD Hessian.

Fits report log smoothing parameters (smoothing()), effective degrees of
freedom and the marginal likelihood (fitSumm()); AIC() is a conditional
AIC. predict() and simulate() work with penalised fits. Unpenalised fits
are unchanged.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git add examples && git commit -q -m "Add penalised smoothers example

examples/06-penalised-smoothers.R compares unpenalised and penalised 1D
and 2D F smoothers, Fellner-Schall and Laplace estimates, and shows
uncertainty from the posterior covariance.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git push origin claude/peaceful-babbage-if9ubk 2>&1 | tail -1
```

Output:

```
 M NAMESPACE
 M NEWS.md
 M R/FLa4a-package.R
 M R/a4aFit-class.R
 M R/data.R
 M R/formula.R
 M R/model.R
 M R/sca.R
 M R/simulate.R
 M README.md
 M examples/README.md
 M man/a4aFit-class.Rd
 M man/sca.Rd
?? examples/06-penalised-smoothers.R
?? tests/testthat/test-penalised.R
   09187ef..cf3ce7f  claude/peaceful-babbage-if9ubk -> claude/peaceful-babbage-if9ubk
```

## 118. 

```sh
sed -i 's#source("examples/#source("src/examples/#g; s#source(\x27examples/#source(\x27src/examples/#g' src/examples/*.R && sed -i 's#dir <- file.path("examples", name)#dir <- file.path("src", "examples", name)#; s#examples/<name>/#src/examples/<name>/#; s#^\# source("examples/helpers.R")#\# source("src/examples/helpers.R")#' src/examples/helpers.R && sed -i 's#`examples/01-getting-started/stock-summary.png`#`src/examples/01-getting-started/stock-summary.png`#; s#source("examples/#source("src/examples/#g' src/examples/README.md && sed -i 's#\[`examples/`\](examples)#[`src/examples/`](src/examples)#; s#`examples/06-penalised-smoothers.R`#`src/examples/06-penalised-smoothers.R`#' README.md && sed -i 's#^examples/\*/$#src/examples/*/#' .gitignore && sed -i 's#^\^examples\$$#^src$#' .Rbuildignore && grep -rn "examples" README.md .gitignore .Rbuildignore src/examples/helpers.R src/examples/README.md | grep -v "src/examples\|\^src" ; grep -rn 'source(' src/examples/*.R | grep -v "src/examples/helpers.R" ; cat .Rbuildignore
```

Output:

```
.gitignore:24:# plots written by the examples
src/examples/01-getting-started.R:6:# Run from the repository root:  source("src/examples/01-getting-started.R")
src/examples/02-smoothers.R:11:# Run from the repository root:  source("src/examples/02-smoothers.R")
src/examples/03-covariates.R:8:# Run from the repository root:  source("src/examples/03-covariates.R")
src/examples/04-stock-recruitment.R:8:# Run from the repository root:  source("src/examples/04-stock-recruitment.R")
src/examples/05-simulate-covariates.R:13:# Run from the repository root:  source("src/examples/05-simulate-covariates.R")
src/examples/06-penalised-smoothers.R:15:# Run from the repository root:  source("src/examples/06-penalised-smoothers.R")
^README\.md$
^NEWS\.md$
^\.github$
^\.devcontainer$
^\.gitattributes$
^src$
```

## 119. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -6
```

Output:

```
*** installing help indices
** building package indices
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (FLa4a)
```

## 120. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | grep -i "libs\|make\|compil\|src\|warn" | head; Rscript -e 'cat(requireNamespace("pkgbuild", quietly=TRUE), requireNamespace("pkgload", quietly=TRUE), "\n")'
```

Output:

```
** libs
Warning: no source files found
** byte-compile and prepare package for lazy loading
TRUE TRUE
```

## 121. 

```sh
Rscript -e 'suppressMessages(pkgload::load_all(".", quiet = TRUE)); cat("loaded, sca exists:", exists("sca"), "\n"); cat("needs_compile:", pkgbuild::needs_compile("."), "\n")' 2>&1 | tail -5
```

Output:

```
loaded, sca exists: TRUE 
needs_compile: FALSE
```

## 122. 

```sh
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "writ\|warn\|error"; R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1; Rscript /tmp/claude-0/sim1.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -16
```

Output:

```
Writing 'NAMESPACE'
Writing 'derivedCI.Rd'
Writing 'simStock.Rd'
Writing 'simScenario.Rd'
* DONE (FLa4a)
a4aFit: PLE 
  ages: 1 - 10   years: 1957 - 2017   iters: 1 
  fleets: catch, BTS-Combined (all), SNS 
    
iter nopar    nlogl      maxgrad nobs convergence
   1   105 339.9854 8.905765e-12 1123           0
fit size: 0.7 Mb 
predict secs 0.13 
reproduces fit: 0 0 
F ratio 0.9913823 0.9913823 exp(beta) 0.9913823 
SNS index unchanged ratio range: 1.000632 1.00513 
simulate 20 secs 1.77 
20 20 NA pattern same: TRUE 
catch log resid mean 0.001171444 sd 0.224949 
true beta -0.008655064 refit -0.00132015 -0.003437998 -0.01061417
```

## 123. 

```sh
cat > /tmp/claude-0/simdata1.R <<'EOF'
suppressMessages(library(FLa4a))
for (sc in c("simple", "smooth", "covariate", "sr", "biomass")) {
  d <- simScenario(sc, nsim = 1, seed = 1)
  cat(sprintf("%-10s ages %s years %d-%d surveys %s | SSB %6.0f-%6.0f Fbar %.2f-%.2f R %.2g-%.2g\n", sc,
              paste(range(as.numeric(dimnames(d$stock)$age)), collapse = "-"),
              min(as.numeric(dimnames(d$stock)$year)), max(as.numeric(dimnames(d$stock)$year)),
              paste(names(d$indices), collapse = ","),
              min(d$truth$ssb), max(d$truth$ssb), min(d$truth$fbar), max(d$truth$fbar), min(d$truth$rec), max(d$truth$rec)))
}
d <- simStock(ages = 1:6, years = 1991:2020, fbar = c(2, 4), sel = list(a50 = 2, slope = 0.5),
              surveys = list(simSurvey("s", ages = 1:5, q = 2e-3, sd = 0.01)), catch.sd = 0.01, seed = 1)
m <- simScenario("simple")$models
fit <- do.call(sca, c(list(d$stock, d$indices), m))
cat("conv", fitSumm(fit)["convergence", 1], "\n")
cat("max rel error: harvest", max(abs(c(harvest(fit) / d$truth$harvest) - 1)),
    " stock.n", max(abs(c(stock.n(fit) / d$truth$stock.n) - 1)), "\n")
ci <- derivedCI(fit, d$stock, d$indices)
s <- ci[ci$quantity == "ssb", ]
cat("ssb est vs truth max rel", max(abs(s$estimate / c(d$truth$ssb) - 1)), " vs fit ssb", max(abs(s$estimate / c(ssb(d$stock + fit)) - 1)), "\n")
f <- ci[ci$quantity == "fbar", ]; cat("fbar vs fit", max(abs(f$estimate / c(fbar(d$stock + fit)) - 1)), "\n")
h <- ci[ci$quantity == "harvest", ]; cat("harvest vs fit", max(abs(h$estimate / c(harvest(fit)) - 1)), "\n")
print(head(ci[ci$quantity == "ssb", ], 3))
EOF
Rscript /tmp/claude-0/simdata1.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -16
```

Output:

```
simple     ages 1-6 years 1991-2020 surveys survey | SSB 161009-594734 Fbar 0.12-0.64 R 3.3e+05-2.2e+06
smooth     ages 1-10 years 1981-2020 surveys summer,winter | SSB 317284-792429 Fbar 0.12-0.65 R 3.3e+05-2.2e+06
covariate  ages 1-6 years 1991-2020 surveys survey | SSB 139705-637887 Fbar 0.14-0.82 R 4.7e+05-2.2e+06
sr         ages 1-8 years 1981-2020 surveys survey | SSB 136758-1303542 Fbar 0.15-0.90 R 5e+05-2.8e+06
biomass    ages 1-6 years 1991-2020 surveys survey,biomass | SSB 161009-594734 Fbar 0.12-0.64 R 3.3e+05-2.2e+06
conv 0 
max rel error: harvest 0.01130254  stock.n 0.01629655 
ssb est vs truth max rel 0.004687173  vs fit ssb 1.110223e-15 
fbar vs fit 2.220446e-16 
harvest vs fit 0 
  quantity age year estimate    lower    upper          se
1      ssb  NA 1991 522806.8 518250.7 527402.9 0.004465802
2      ssb  NA 1992 520950.9 516916.6 525016.6 0.003966493
3      ssb  NA 1993 510194.4 506484.4 513931.7 0.003723760
```

## 124. 

```sh
cat > /tmp/claude-0/cov1.R <<'EOF'
suppressMessages(library(FLa4a))
nsim <- 20
d <- simScenario("simple", nsim = nsim, seed = 42)
t0 <- Sys.time()
res <- lapply(seq_len(nsim), function(i) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  fit <- do.call(sca, c(list(stk, idx), d$models))
  ci <- derivedCI(fit, stk, idx)
  truth <- c(c(d$truth$ssb), c(d$truth$fbar), c(d$truth$rec), c(d$truth$harvest))
  data.frame(ci, truth = truth, sim = i, conv = fitSumm(fit)["convergence", 1])
})
cat("secs per sim", round(as.numeric(Sys.time() - t0, units = "secs") / nsim, 2), "\n")
r <- do.call(rbind, res)
r$covered <- r$truth >= r$lower & r$truth <= r$upper
print(tapply(r$covered, r$quantity, mean))
print(tapply(log(r$estimate / r$truth), r$quantity, mean))
cat("converged:", mean(r$conv == 0), "\n")
EOF
Rscript /tmp/claude-0/cov1.R 2>&1 | tail -8
```

Output:

```
secs per sim 0.34 
     fbar   harvest       rec       ssb 
0.8900000 0.8833333 0.8900000 0.8816667 
        fbar      harvest          rec          ssb 
 0.003554898  0.006407626 -0.002528141 -0.008176930 
converged: 1
```

## 125. 

```sh
cat > /tmp/claude-0/cov2.R <<'EOF'
suppressMessages(library(FLa4a))
nsim <- 200
d <- simScenario("simple", nsim = nsim, seed = 7)
res <- lapply(seq_len(nsim), function(i) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  fit <- do.call(sca, c(list(stk, idx), d$models))
  ci <- derivedCI(fit, stk, idx)
  s <- fitSumm(fit)[, 1]
  data.frame(ci, truth = c(c(d$truth$ssb), c(d$truth$fbar), c(d$truth$rec), c(d$truth$harvest)),
             sim = i, n = s[["nobs"]], p = s[["nopar"]])
})
r <- do.call(rbind, res)
z <- qnorm(0.975)
k <- sqrt(r$n / (r$n - r$p))
r$cov <- abs(log(r$truth / r$estimate)) <= z * r$se
r$covAdj <- abs(log(r$truth / r$estimate)) <= z * r$se * k
cat("n", r$n[1], "p", r$p[1], "inflation", round(k[1], 3), "\n")
print(round(rbind(nominal = tapply(r$cov, r$quantity, mean), df_adjusted = tapply(r$covAdj, r$quantity, mean)), 3))
# the true observation sds are 0.1 (catch) and 0.2 (survey): compare estimates
EOF
Rscript /tmp/claude-0/cov2.R 2>&1 | tail -5
```

Output:

```
n 330 p 77 inflation 1.142 
             fbar harvest   rec   ssb
nominal     0.880   0.884 0.888 0.890
df_adjusted 0.923   0.925 0.928 0.929
```

## 126. 

```sh
for f in 07 08; do s=$(ls src/examples/$f-*.R); ( Rscript -e "t0<-Sys.time(); source('$s'); cat('TIME', round(as.numeric(Sys.time()-t0, units='secs')), 's\n')" > /tmp/claude-0/ex/run$f.log 2>&1; echo "$f exit $?" ) & done; wait 2>/dev/null; for f in 07 08; do echo "== $f"; grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$\|^saved\|~\|environment" /tmp/claude-0/ex/run$f.log | tail -22; done
```

Output:

```
08 exit 1
07 exit 0
== 07
$fmodel
$qmodel
$qmodel[[1]]
$vmodel
$vmodel[[1]]
$vmodel[[2]]
$n1model
$srmodel
converged: 1 
   fbar harvest     rec     ssb 
 0.0006  0.0026 -0.0009 -0.0020 
   fbar harvest     rec     ssb 
  0.885   0.889   0.889   0.906 
[1] 0.0797 0.1939
             fbar harvest   rec   ssb
nominal     0.885   0.889 0.889 0.906
df.adjusted 0.924   0.929 0.930 0.937
TIME 35 s
== 08
Error in (function (stock, indices, fmodel = defaultFmod(stock), qmodel = defaultQmod(indices),  : 
  qmodel needs one formula per index
Calls: source ... eval -> lapply -> lapply -> FUN -> do.call -> <Anonymous>
In addition: Warning message:
Execution halted
```

## 127. 

```sh
python3 - <<'EOF'
p='R/simdata.R'; s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a[:50]
    s=s.replace(a,b)
rep("""      list(args = a,
           models = utils::modifyList(simpleModels, list(
             fmodel = ~ factor(age) + factor(year) + effort,
             qmodel = list(~ factor(age) + temp))))""","""      m <- simpleModels
      m$fmodel <- ~ factor(age) + factor(year) + effort
      m$qmodel <- list(~ factor(age) + temp)
      list(args = a, models = m)""")
rep("""      list(args = a, models = utils::modifyList(simpleModels, list(
        qmodel = list(~ factor(age), ~ 1), vmodel = list(~ 1, ~ 1, ~ 1))))""","""      m <- simpleModels
      m$qmodel <- list(~ factor(age), ~ 1)
      m$vmodel <- list(~ 1, ~ 1, ~ 1)
      list(args = a, models = m)""")
rep("""  args <- utils::modifyList(spec$args, list(...))""","""  args <- spec$args
  extra <- list(...)
  args[names(extra)] <- extra""")
rep("""#' @param ... further arguments to [simStock()], overriding the scenario's.""","""#' @param ... further arguments to [simStock()], replacing the scenario's
#'   (e.g. `catch.sd = 0.2`, or a new `surveys` list).""")
open(p,'w').write(s)
p='src/examples/08-simulated-scenarios.R'; s=open(p).read()
old="""fits$`smooth (penalised)` <- fitScenario(
  utils::modifyList(sims$smooth, list(models = list(fmodel = ~ s(age, k = 6, bs = "ps") +
    s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 10), bs = "ps")))),
  penalise = "fmodel")"""
new="""penalisedSmooth <- sims$smooth
penalisedSmooth$models$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") +
  ti(age, year, k = c(5, 10), bs = "ps")
fits$`smooth (penalised)` <- fitScenario(penalisedSmooth, penalise = "fmodel")"""
assert s.count(old)==1
open(p,'w').write(s.replace(old,new))
EOF
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1; Rscript -e "t0<-Sys.time(); source('src/examples/08-simulated-scenarios.R'); cat('TIME', round(as.numeric(Sys.time()-t0, units='secs')), 's\n')" 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -20
```

Output:

```
* DONE (FLa4a)
                    ssb fbar
simple              0.9  7.7
smooth             -0.2 -1.6
covariate          -8.2 15.1
sr                 -2.2  8.8
biomass            -2.4 11.0
smooth (penalised) -1.0 -3.3
saved src/examples/08-simulated-scenarios/simple.png
saved src/examples/08-simulated-scenarios/smooth.png
saved src/examples/08-simulated-scenarios/covariate.png
saved src/examples/08-simulated-scenarios/sr.png
saved src/examples/08-simulated-scenarios/biomass.png
saved src/examples/08-simulated-scenarios/smooth-penalised.png
Warning messages:
1: ~factor(age) + factor(year) + effort has 1 redundant parameter(s), removing: effort 
2: In smooth.construct.tensor.smooth.spec(object, dk$data, dk$knots) :
  reparameterization unstable for margin: not done
3: In smooth.construct.tensor.smooth.spec(object, dk$data, dk$knots) :
  reparameterization unstable for margin: not done
TIME 10 s
```

## 128. 

```sh
python3 - <<'EOF'
p='R/simdata.R'; s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a[:50]
    s=s.replace(a,b)
rep("""      effort <- seq(-1, 1, length = length(years30)) + stats::rnorm(length(years30), 0, 0.3)
      a <- simple
      a$covar <- list(temp = temp, effort = effort)
      a$Fcovar <- c(effort = 0.3)
      a$surveys[[1]]$covar <- c(temp = 0.4)
      m <- simpleModels
      m$fmodel <- ~ factor(age) + factor(year) + effort""","""      effort <- sin(seq(0, 1.5 * pi, length = length(years30))) + stats::rnorm(length(years30), 0, 0.3)
      a <- simple
      # F changes over the years only through effort, so the effect is
      # identifiable (a year-only covariate is confounded with factor(year))
      a$Fbar <- rep(0.35, length(years30))
      a$covar <- list(temp = temp, effort = effort)
      a$Fcovar <- c(effort = 0.3)
      a$surveys[[1]]$covar <- c(temp = 0.4)
      m <- simpleModels
      m$fmodel <- ~ factor(age) + effort""")
rep("""#' * `"covariate"`: as `"simple"`, with the survey's catchability depending
#'   on a covariate `temp` (effect 0.4 on log q) and F on a covariate
#'   `effort` (effect 0.3 on log F); the correct submodels include both.""","""#' * `"covariate"`: as `"simple"`, with the survey's catchability depending
#'   on a covariate `temp` (effect 0.4 on log q), and F varying over the
#'   years only through a covariate `effort` (effect 0.3 on log F); the
#'   correct submodels are `~ factor(age) + effort` and
#'   `~ factor(age) + temp`.""")
open(p,'w').write(s)
p='src/examples/08-simulated-scenarios.R'; s=open(p).read()
s=s.replace('ti(age, year, k = c(5, 10), bs = "ps")','ti(age, year, k = c(5, 15), bs = "ps")')
open(p,'w').write(s)
EOF
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "warn\|error"; R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1; Rscript -e "source('src/examples/08-simulated-scenarios.R')" 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$\|^saved" | tail -14
```

Output:

```
* DONE (FLa4a)
                 true estimate    se
fMod:effort       0.3    0.311 0.012
qMod:survey:temp  0.4    0.415 0.031
                    ssb fbar
simple              0.9  7.7
smooth             -0.2 -1.6
covariate           0.5 -0.3
sr                 -2.2  8.8
biomass            -2.4 11.0
smooth (penalised) -1.0 -2.1
```

## 129. 

```sh
python3 - <<'EOF'
p='src/examples/08-simulated-scenarios.R'; s=open(p).read()
old="""    for (q in c("ssb", "fbar", "rec")) {
      x <- ci[ci$quantity == q, ]
      plot(x$year, x$estimate, type = "n", ylim = range(0, x$upper, truth[[q]]), las = 1,
           xlab = "", ylab = "", main = toupper(q))
      polygon(c(x$year, rev(x$year)), c(x$lower, rev(x$upper)),
              col = grDevices::adjustcolor(fitCols(1), 0.3), border = NA)
      lines(x$year, x$estimate, col = fitCols(1), lwd = 2)
      lines(x$year, truth[[q]], lwd = 2)
    }"""
new="""    scale <- c(ssb = 1e3, fbar = 1, rec = 1e6)
    titles <- c(ssb = "SSB (thousand t)", fbar = "Fbar", rec = "recruits (millions)")
    for (q in c("ssb", "fbar", "rec")) {
      x <- ci[ci$quantity == q, ]
      x[c("estimate", "lower", "upper")] <- x[c("estimate", "lower", "upper")] / scale[[q]]
      tr <- truth[[q]] / scale[[q]]
      plot(x$year, x$estimate, type = "n", ylim = range(0, x$upper, tr), las = 1,
           xlab = "", ylab = "", main = titles[[q]])
      polygon(c(x$year, rev(x$year)), c(x$lower, rev(x$upper)),
              col = grDevices::adjustcolor(fitCols(1), 0.3), border = NA)
      lines(x$year, x$estimate, col = fitCols(1), lwd = 2)
      lines(x$year, tr, lwd = 2)
    }"""
assert s.count(old)==1
open(p,'w').write(s.replace(old,new))
EOF
Rscript -e "source('src/examples/08-simulated-scenarios.R')" > /dev/null 2>&1; echo $?
```

Output:

```
0
```

## 130. 

```sh
timeout 900 Rscript -e 'testthat::test_local(".", filter = "simdata", reporter = "summary")' 2>&1 | tail -20
```

Output:

```
simdata: ................................

== DONE ========================================================================
```

## 131. 

```sh
python3 - <<'EOF'
p='README.md'; s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a[:40]
    s=s.replace(a,b)
rep("### Simulation with covariates","""### Simulated data with known truth

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

### Simulation with covariates""")
rep("""| `R/defaults.R` | default submodels |""","""| `R/uncertainty.R` | `derivedCI()`: delta-method intervals for SSB, Fbar, recruitment and F |
| `R/simdata.R` | `simStock()`, `simSurvey()`, `simScenario()`: simulated data with known truth |
| `R/defaults.R` | default submodels |""")
rep("""See [`src/examples/`](src/examples) for worked examples with plots: getting started,
smoothers, covariates and stock-recruitment models.""","""See [`src/examples/`](src/examples) for worked examples with plots: getting started,
smoothers, covariates, stock-recruitment models, simulation, penalised
smoothers, confidence interval coverage and simulated scenarios.""")
open(p,'w').write(s)

p='NEWS.md'; s=open(p).read()
s=s.replace("# FLa4a 2.0.0.9000\n","""# FLa4a 2.0.0.9000

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
""",1)
open(p,'w').write(s)

p='src/examples/README.md'; s=open(p).read()
s=s.replace("""| `helpers.R` |""","""| `07-coverage.R` | bias and coverage of 95% confidence intervals (`derivedCI()`) over 100 simulated data sets fitted with the correct model |
| `08-simulated-scenarios.R` | each `simScenario()` fitted and compared with the truth: separable, smooth (also penalised), covariate, stock-recruitment and biomass-survey data |
| `helpers.R` |""")
s=s.replace("Scripts 01-04 take 10-30 seconds each; 05 and 06 take 1-3 minutes.","Scripts 01-04 and 08 take 10-30 seconds each; 05, 06 and 07 take about a minute.")
s=s.replace("""Worked examples using North Sea plaice (`ple4` and `ple4.indices` from
FLCore).""","""Worked examples using North Sea plaice (`ple4` and `ple4.indices` from
FLCore) and, in 07 and 08, simulated data with known truth (`simScenario()`).""")
open(p,'w').write(s)
EOF
head -12 src/examples/README.md; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && ls && LANG=C.UTF-8 LC_ALL=C.UTF-8 timeout 1800 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A5 | head -20
```

Output:

```
# Examples

Worked examples using North Sea plaice (`ple4` and `ple4.indices` from
FLCore) and, in 07 and 08, simulated data with known truth (`simScenario()`). Run them from the repository root, either line by line or with
`source()`:

```r
source("src/examples/01-getting-started.R")
```

Each script saves its plots as PNG files in a folder named after it, e.g.
`src/examples/01-getting-started/stock-summary.png` (these folders are not
FLa4a_2.0.0.9000.tar.gz
Status: OK
Shell cwd was reset to /home/user/FLa4a
```

## 132. 

```sh
python3 - <<'EOF' > /tmp/claude-0/readme_sim.R
s=open('/home/user/FLa4a/README.md').read()
i=s.index("### Simulated data with known truth"); b=s.index("```r",i)+4; e=s.index("```",b)
print("suppressMessages(library(FLa4a))\n"+s[b:e]+"\nprint(head(ci, 2)); print(dims(d$stock)$iter)")
EOF
Rscript /tmp/claude-0/readme_sim.R 2>&1 | tail -4; for f in 01 04; do s=$(ls src/examples/$f-*.R); Rscript -e "source('$s')" > /tmp/claude-0/ex/mv$f.log 2>&1; echo "$f exit $? $(grep -c '^saved' /tmp/claude-0/ex/mv$f.log) plots saved"; done; git status --short | head -30
```

Output:

```
  quantity age year estimate    lower    upper         se
1      ssb  NA 1991 527194.6 480019.9 579005.4 0.04782851
2      ssb  NA 1992 523752.1 480827.6 570508.6 0.04362823
[1] 100
01 exit 0 4 plots saved
04 exit 0 2 plots saved
 M .Rbuildignore
 M .gitignore
 M DESCRIPTION
 M NAMESPACE
 M NEWS.md
 M R/model.R
 M README.md
RM examples/01-getting-started.R -> src/examples/01-getting-started.R
RM examples/02-smoothers.R -> src/examples/02-smoothers.R
RM examples/03-covariates.R -> src/examples/03-covariates.R
RM examples/04-stock-recruitment.R -> src/examples/04-stock-recruitment.R
RM examples/05-simulate-covariates.R -> src/examples/05-simulate-covariates.R
RM examples/06-penalised-smoothers.R -> src/examples/06-penalised-smoothers.R
RM examples/README.md -> src/examples/README.md
RM examples/helpers.R -> src/examples/helpers.R
?? R/simdata.R
?? R/uncertainty.R
?? man/derivedCI.Rd
?? man/simScenario.Rd
?? man/simStock.Rd
?? src/examples/07-coverage.R
?? src/examples/08-simulated-scenarios.R
?? tests/testthat/test-simdata.R
```

## 133. 

```sh
cat > /tmp/claude-0/reml1.R <<'EOF'
suppressMessages(library(FLa4a))
tm <- function(expr) { t0 <- Sys.time(); r <- expr; list(r = r, s = as.numeric(Sys.time() - t0, units = "secs")) }
reml <- function(data, full) {
  inner <- setdiff(names(data$par)[lengths(data$par) > 0], c("vpar", "loglambda"))
  obj <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), FLa4a:::relistPar(full, data$par),
                         random = inner, silent = TRUE)
  opt <- nlminb(obj$par, obj$fn, obj$gr, control = list(eval.max = 1e4, iter.max = 1e4))
  list(opt = opt, par = obj$env$last.par)
}
run <- function(stk, idx, models, penalise = character(0)) {
  idx <- FLa4a:::prepIndices(idx)
  data <- do.call(FLa4a:::a4aData, c(list(stk, idx), models[c("fmodel","qmodel","vmodel","n1model","srmodel")], list(penalise = penalise)))
  ml <- tm(FLa4a:::fitA4a(data))
  obj0 <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), data$par, silent = TRUE)
  full <- obj0$par; full[data$colmap$pos] <- ml$r$par
  if (length(ml$r$loglambda)) full[length(full) - length(ml$r$loglambda) + seq_along(ml$r$loglambda)] <- ml$r$loglambda
  re <- tm(reml(data, full))
  vpos <- grep("^vpar", names(obj0$par))
  cat(sprintf("  ML %.1fs  REML %.1fs (%d outer iters, conv %d)\n", ml$s, re$s, re$r$opt$iterations, re$r$opt$convergence))
  cat("  sd ML  :", round(exp(full[vpos]), 4), "\n  sd REML:", round(exp(re$r$par[vpos]), 4), "\n")
}
d <- simScenario("simple", seed = 1)
cat("simple (true sd 0.1, 0.2)\n"); run(d$stock, d$indices, d$models)
data(ple4); data(ple4.indices); idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
m <- list(fmodel = ~ te(age, year, k = c(5, 20)), qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)),
          vmodel = defaultVmod(ple4, FLa4a:::prepIndices(idx)), n1model = defaultN1mod(ple4), srmodel = ~ factor(year))
cat("ple4 te(5,20)\n"); run(ple4, idx, m)
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 30, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
cat("ple4 penalised s+s+ti\n"); run(ple4, idx, m, penalise = "f")
EOF
cd /tmp/claude-0 && timeout 1500 Rscript reml1.R 2>&1 | tail -14
```

Output:

```
simple (true sd 0.1, 0.2)
  ML 0.2s  REML 1.6s (9 outer iters, conv 0)
  sd ML  : 0.0721 0.1944 
  sd REML: 0.0902 0.2008 
ple4 te(5,20)
  ML 2.1s  REML 35.8s (30 outer iters, conv 0)
  sd ML  : 0.1113 1.0211 1.0599 0.3384 0.9193 
  sd REML: 0.1302 0.6794 1.0546 0.3427 0.9246 
ple4 penalised s+s+ti
  ML 7.8s  REML 33.4s (43 outer iters, conv 0)
  sd ML  : 0.1072 0.3992 0.9147 0.3335 0.9192 
  sd REML: 0.1222 0.4255 0.9139 0.3429 0.9264
Shell cwd was reset to /home/user/FLa4a
```

## 134. 

```sh
python3 - <<'EOF'
p='R/sca.R'; s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a[:50]
    s=s.replace(a,b)
rep("""#' @param verbose logical, print optimiser output.""","""#' @param method `"ML"` (default) estimates all parameters by maximum
#'   likelihood. `"REML"` estimates the observation variance parameters (the
#'   `vmodel` coefficients) and any smoothing parameters by restricted
#'   maximum likelihood: all other coefficients are integrated out with the
#'   Laplace approximation (flat priors on the unpenalised ones), starting
#'   from the ML fit. Maximum likelihood underestimates the observation
#'   variances, the more so the more coefficients each fleet's data have to
#'   support, which makes confidence intervals too narrow; REML corrects for
#'   this. The likelihoods (and so `AIC()`) of REML fits with different
#'   submodels for F, catchability, initial numbers or recruitment are not
#'   comparable: use ML for model selection.
#' @param verbose logical, print optimiser output.""")
rep("""                penalise = FALSE, sp.method = c("efs", "laplace"),""","""                penalise = FALSE, sp.method = c("efs", "laplace"), method = c("ML", "REML"),""")
rep("""  sp.method <- match.arg(sp.method)""","""  sp.method <- match.arg(sp.method)
  method <- match.arg(method)""")
rep("""control = control, sp.method = sp.method)""","""control = control, sp.method = sp.method,
                  method = method)""")
rep("""  penalised <- length(first$edf) > 0""","""  penalised <- length(first$edf) > 0
  marginal <- penalised || method == "REML\"""")
rep("""                 if (penalised) c("nlogl:marginal", paste0("edf:", names(first$edf))))""","""                 if (marginal) "nlogl:marginal", if (penalised) paste0("edf:", names(first$edf)))""")
rep("""                          f$report$nllComp, if (penalised) c(f$objective, f$edf))""","""                          f$report$nllComp, if (marginal) f$objective, if (penalised) f$edf)""")
rep("""#'   reports the effective degrees of freedom of each smoother (`edf:`), the
#'   marginal negative log-likelihood (`nlogl:marginal`), and `nopar` counts""","""#'   reports the effective degrees of freedom of each smoother (`edf:`), the
#'   marginal negative log-likelihood (`nlogl:marginal`; the restricted
#'   likelihood for REML fits), and `nopar` counts""")
open(p,'w').write(s)
EOF
grep -n 'marginal <- penalised' R/sca.R; Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "warn\|error"; R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1
```

Output:

```
145:  marginal <- penalised || method == "REML"
* DONE (FLa4a)
```

## 135. 

```sh
cat > /tmp/claude-0/reml2.R <<'EOF'
suppressMessages(library(FLa4a))
d <- simScenario("simple", nsim = 1, seed = 3)
pm <- d$models; pm$fmodel <- ~ s(age, k = 5) + s(year, k = 20, bs = "ps")
s2 <- simScenario("smooth", nsim = 1, seed = 3)
sm <- s2$models; sm$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
cases <- list(
  "simple ML"  = list(d, d$models, list()), "simple REML" = list(d, d$models, list(method = "REML")),
  "pen ML"     = list(d, pm, list(penalise = "fmodel")), "pen REML" = list(d, pm, list(penalise = "fmodel", method = "REML")),
  "smooth2D ML"   = list(s2, sm, list(penalise = "fmodel")), "smooth2D REML" = list(s2, sm, list(penalise = "fmodel", method = "REML")))
for (n in names(cases)) {
  x <- cases[[n]]; t0 <- Sys.time()
  f <- do.call(sca, c(list(x[[1]]$stock, x[[1]]$indices), x[[2]], x[[3]]))
  s <- fitSumm(f)[, 1]
  cat(sprintf("%-14s %5.1fs conv %d  sd %s  loglam %s\n", n, as.numeric(Sys.time() - t0, units = "secs"), s[["convergence"]],
      paste(round(exp(c(coef(f)[grep("vMod", dimnames(coef(f))$params), 1])), 3), collapse = " "),
      paste(round(smoothing(f)[, 1], 2), collapse = " ")))
}
EOF
cd /tmp/claude-0 && timeout 1500 Rscript reml2.R 2>&1 | tail -8
```

Output:

```
simple ML        0.5s conv 0  sd 0.083 0.197  loglam 
simple REML      1.9s conv 0  sd 0.104 0.204  loglam 
pen ML           0.4s conv 0  sd 0.088 0.197  loglam -2.07 7.35
pen REML         1.0s conv 0  sd 0.101 0.204  loglam -2.07 7.35
smooth2D ML      8.1s conv 0  sd 0.147 0.242 0.293  loglam 1.58 8.41 -5.55 12.29
smooth2D REML   24.2s conv 0  sd 0.157 0.247 0.299  loglam 1.56 8.4 -4.91 11.86
Shell cwd was reset to /home/user/FLa4a
```

## 136. 

```sh
Rscript -e "t0<-Sys.time(); source('src/examples/09-reml-coverage.R'); cat('TIME', round(as.numeric(Sys.time()-t0, units='secs')), 's\n')" > /tmp/claude-0/reml-study.log 2>&1; tail -60 /tmp/claude-0/reml-study.log
```

Output:

```
Command running in background with ID: bx01haf21. Output is being written to: /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/bx01haf21.output. You will be notified when it completes. To check interim output, use Read on that file path.
```

## 137. 

```sh
timeout 900 Rscript -e 'testthat::test_local(".", filter = "reml", reporter = "summary")' 2>&1 | tail -8; tail -3 /tmp/claude-0/reml-study.log
```

Output:

```
reml: .............

== DONE ========================================================================
    bevholt, bevholtSV, geomean, ricker

Study: Unpenalised (correct model)
```

## 138. 

```sh
cat > /tmp/claude-0/conv2d.R <<'EOF'
suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
res <- parallel::mclapply(1:50, function(i) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  out <- list()
  for (method in c("ML", "REML")) {
    w <- character(0)
    fit <- withCallingHandlers(tryCatch(do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", method = method))),
                                        error = function(e) conditionMessage(e)),
                               warning = function(x) { w <<- c(w, conditionMessage(x)); invokeRestart("muffleWarning") })
    out[[method]] <- if (is.character(fit)) c(i = i, method = method, conv = NA, maxgrad = NA, warn = paste("ERROR:", fit))
      else c(i = i, method = method, conv = fitSumm(fit)["convergence", 1], maxgrad = signif(fitSumm(fit)["maxgrad", 1], 2),
             warn = paste(unique(w), collapse = " | "))
  }
  do.call(rbind, out)
}, mc.cores = 4)
r <- as.data.frame(do.call(rbind, res))
bad <- r[is.na(r$conv) | r$conv != "0", ]
print(table(r$method, r$conv, useNA = "ifany"))
print(bad[, c("i", "method", "conv", "maxgrad", "warn")], right = FALSE)
EOF
cd /tmp/claude-0 && timeout 1800 Rscript conv2d.R 2>&1 | tail -40
```

Output:

```
        0  1 <NA>
  ML   42  1    7
  REML 34  9    7
        i  method conv maxgrad warn                                        
REML.3  4  REML   1    4.3e-05                                             
ML.5    6  ML     1    0.002                                               
REML.5  6  REML   1    0.00095                                             
REML.7  8  REML   1    4.4e-05                                             
REML.13 14 REML   1    0.00036                                             
REML.15 16 REML   1    0.00084                                             
REML.18 19 REML   1    0.0017                                              
ML.24   25 ML     <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.24 25 REML   <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.27 28 REML   1    0.00099                                             
ML.32   33 ML     <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.32 33 REML   <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.35 36 REML   1    0.00038                                             
ML.38   39 ML     <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.38 39 REML   <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
ML.39   40 ML     <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.39 40 REML   <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.43 44 REML   1    0.00013                                             
ML.46   47 ML     <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.46 47 REML   <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
ML.47   48 ML     <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.47 48 REML   <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
ML.49   50 ML     <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
REML.49 50 REML   <NA> <NA>    ERROR: missing value where TRUE/FALSE needed
Shell cwd was reset to /home/user/FLa4a
```

## 139. 

```sh
cat > /tmp/claude-0/dbg2d.R <<'EOF'
suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
i <- 25
stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
r <- withCallingHandlers(tryCatch(do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", verbose = FALSE))), error = function(e) e),
  error = function(e) { cs <- sys.calls(); for (c in tail(cs, 12)) cat(substr(deparse(c)[1], 1, 110), "\n") })
# REML message on sim 4
i <- 4
stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
trace(FLa4a:::fitREML, exit = quote(cat("nlminb:", opt$message, " iterations", opt$iterations, "\n")), print = FALSE, where = asNamespace("FLa4a"))
f <- do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", method = "REML")))
EOF
cd /tmp/claude-0 && timeout 900 Rscript dbg2d.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -18
```

Output:

```
Warning messages:
1: In stats::nlminb(x, fn, gr, control = ctrl) :
  NA/NaN function evaluation
2: In stats::nlminb(x, fn, gr, control = ctrl) :
  NA/NaN function evaluation
3: In stats::nlminb(x, fn, gr, control = ctrl) :
  NA/NaN function evaluation
Tracing function "fitREML" in package "FLa4a (not-exported)"
[1] "fitREML"
nlminb: relative convergence (4)  iterations 22
Shell cwd was reset to /home/user/FLa4a
```

## 140. 

```sh
cat > /tmp/claude-0/dbg2d2.R <<'EOF'
suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
one <- function(i, method) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  f <- tryCatch(do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", method = method))), error = function(e) conditionMessage(e))
  if (is.character(f)) return(paste("ERROR", f))
  s <- fitSumm(f)[, 1]; paste("conv", s[["convergence"]], "maxgrad", signif(s[["maxgrad"]], 2))
}
for (i in c(25, 33)) cat("sim", i, "ML:", one(i, "ML"), "\n")
trace(FLa4a:::fitSmoothing, exit = quote(cat("  FS: converged", converged, " inner converged", fitted$converged, " iterations", it, "\n")), print = FALSE, where = asNamespace("FLa4a"))
cat("sim 4 REML:", one(4, "REML"), "\n")
cat("sim 4 ML:", one(4, "ML"), "\n")
EOF
cd /tmp/claude-0 && timeout 900 Rscript dbg2d2.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$\|Tracing\|fitSmoothing\"" | tail -12
```

Output:

```
3: In stats::nlminb(x, fn, gr, control = ctrl) :
  NA/NaN function evaluation
4: In stats::nlminb(x, fn, gr, control = ctrl) :
  NA/NaN function evaluation
5: In stats::nlminb(x, fn, gr, control = ctrl) :
  NA/NaN function evaluation
6: In stats::nlminb(x, fn, gr, control = ctrl) :
  NA/NaN function evaluation
  FS: converged TRUE  inner converged TRUE  iterations 32 
sim 4 REML: conv 1 maxgrad 0.00012 
  FS: converged TRUE  inner converged TRUE  iterations 32 
sim 4 ML: conv 0 maxgrad 6.3e-08
Shell cwd was reset to /home/user/FLa4a
```

## 141. 

```sh
cd /tmp/claude-0 && timeout 900 Rscript dbg2d2.R 2>&1 | grep "^sim"
```

Output:

```
sim 25 ML: ERROR missing value where TRUE/FALSE needed 
sim 33 ML: ERROR missing value where TRUE/FALSE needed 
sim 4 REML: conv 1 maxgrad 0.00021 
sim 4 ML: conv 0 maxgrad 6.3e-08
Shell cwd was reset to /home/user/FLa4a
```

## 142. 

```sh
cat > /tmp/claude-0/dbg2d3.R <<'EOF'
suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
i <- 25
stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
tryCatch(withCallingHandlers(do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", verbose = TRUE))),
  error = function(e) { cs <- sys.calls(); for (c in tail(cs, 8)) cat("CALL:", substr(paste(deparse(c), collapse = " "), 1, 120), "\n") }),
  error = function(e) cat("ERROR:", conditionMessage(e), "\n"))
EOF
cd /tmp/claude-0 && timeout 900 Rscript dbg2d3.R 2>&1 | grep "CALL\|ERROR\|Fellner" | tail -16
```

Output:

```
Fellner-Schall iteration 66: marginal nll -27.784466, max change in log lambda 0.273
Fellner-Schall iteration 67: marginal nll -27.790478, max change in log lambda 5
Fellner-Schall iteration 68: marginal nll -20.81438, max change in log lambda 5
Fellner-Schall iteration 69: marginal nll -13.501631, max change in log lambda 3.31
Fellner-Schall iteration 70: marginal nll -10.000766, max change in log lambda 0.28
Fellner-Schall iteration 71: marginal nll -10.339422, max change in log lambda 0.278
Fellner-Schall iteration 72: marginal nll NaN, max change in log lambda 0.271
CALL: (function (stock, indices, fmodel = defaultFmod(stock), qmodel = defaultQmod(indices),      srmodel = defaultSRmod(stock 
CALL: lapply(seq_len(nit), function(i) {     stk <- iter(stock, min(i, d$iter))     idx <- FLIndices(lapply(indices, iterOf, i 
CALL: lapply(seq_len(nit), function(i) {     stk <- iter(stock, min(i, d$iter))     idx <- FLIndices(lapply(indices, iterOf, i 
CALL: FUN(X[[i]], ...) 
CALL: fitA4a(data, fit = fit, verbose = verbose, control = control,      sp.method = sp.method, method = method) 
CALL: fitSmoothing(obj, hess, data, full, bPos, lamPos, ctrl, verbose) 
CALL: .handleSimpleError(function (e)  {     cs <- sys.calls()     for (c in tail(cs, 8)) cat("CALL:", substr(paste(deparse(c) 
CALL: h(simpleError(msg, call)) 
ERROR: missing value where TRUE/FALSE needed
Shell cwd was reset to /home/user/FLa4a
```

## 143. 

```sh
grep -n "full <- obj\$par$\|names(full)" R/model.R | head; Rscript -e 'library(RTMB); o <- MakeADFun(function(p) sum(p$a^2)+sum(p$b^2), list(a=1:2+0, b=3), silent=TRUE); print(names(o$par))'
```

Output:

```
260:  full <- obj$par
303:      v <- which(names(full)[bPos] == "vpar")
[1] "a" "a" "b"
```

## 144. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && timeout 1800 Rscript /tmp/claude-0/conv2d.R 2>&1 | tail -12
```

Output:

```
* DONE (FLa4a)
REML.24 25 REML   1    4e-04                             
REML.30 31 REML   1    0.00039                           
REML.32 33 REML   1    0.00028                           
REML.35 36 REML   1    0.00015                           
REML.36 37 REML   1    0.00013                           
REML.37 38 REML   1    0.0011                            
REML.38 39 REML   1    0.0024                            
REML.43 44 REML   1    0.00032                           
REML.44 45 REML   1    0.00027                           
REML.46 47 REML   1    0.016   NA/NaN function evaluation
REML.47 48 REML   1    0.00049                           
REML.49 50 REML   1    0.006
```

## 145. 

```sh
timeout 1800 Rscript /tmp/claude-0/conv2d.R 2>&1 | grep -v "^REML\.\|^ML\." | tail -8
```

Output:

```
        0  1
  ML   50  0
  REML 34 16
        i  method conv maxgrad warn
```

## 146. 

```sh
cat > /tmp/claude-0/dbg2d4.R <<'EOF'
suppressMessages(library(FLa4a)); options(warn = 1)
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
trace(FLa4a:::fitREML, exit = quote(cat("REML nlminb:", opt$message, "| code", opt$convergence, "| iters", opt$iterations, "| vcovVpar NULL:", is.null(Vout), "| outer grad", signif(max(abs(obj$gr(opt$par))), 2), "\n")), print = FALSE, where = asNamespace("FLa4a"))
for (i in c(25, 31, 47)) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  f <- do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", method = "REML")))
  cat("sim", i, "conv", fitSumm(f)["convergence", 1], "\n")
}
EOF
cd /tmp/claude-0 && timeout 900 Rscript dbg2d4.R 2>&1 | grep "REML nlminb\|^sim\|Warning\|warning" | tail -12
```

Output:

```
REML nlminb: false convergence (8) | code 1 | iters 46 | vcovVpar NULL: FALSE | outer grad 0.56 
sim 25 conv 1 
REML nlminb: relative convergence (4) | code 0 | iters 29 | vcovVpar NULL: FALSE | outer grad 0.00018 
sim 31 conv 0 
REML nlminb: false convergence (8) | code 1 | iters 38 | vcovVpar NULL: FALSE | outer grad 0.68 
In addition: There were 11 warnings (use warnings() to see them)
Shell cwd was reset to /home/user/FLa4a
```

## 147. 

```sh
cat > /tmp/claude-0/dbg2d5.R <<'EOF'
suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
fm <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
i <- 25
stk <- iter(d$stock, i); idx <- FLa4a:::prepIndices(FLIndices(lapply(d$indices, iter, i)))
data <- FLa4a:::a4aData(stk, idx, fm, d$models$qmodel, d$models$vmodel, d$models$n1model, d$models$srmodel, penalise = "f")
ml <- FLa4a:::fitA4a(data, fit = "MP")
obj0 <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), data$par, silent = TRUE)
full <- obj0$par; full[data$colmap$pos] <- ml$par; full[length(full) - length(ml$loglambda) + seq_along(ml$loglambda)] <- ml$loglambda
inner <- setdiff(names(data$par)[lengths(data$par) > 0], c("vpar", "loglambda"))
try1 <- function(label, ic = list(), restarts = 0) {
  t0 <- Sys.time()
  obj <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), FLa4a:::relistPar(full, data$par), random = inner, silent = TRUE, inner.control = ic)
  opt <- nlminb(obj$par, obj$fn, obj$gr, control = list(eval.max = 1e4, iter.max = 1e4))
  for (r in seq_len(restarts)) if (opt$convergence != 0) opt <- nlminb(opt$par, obj$fn, obj$gr, control = list(eval.max = 1e4, iter.max = 1e4))
  obj$fn(opt$par)
  cat(sprintf("%-32s %-28s obj %.6f grad %.2g  %.1fs\n", label, opt$message, opt$objective, max(abs(obj$gr(opt$par))), as.numeric(Sys.time() - t0, units = "secs")))
}
try1("default")
try1("restart x3", restarts = 3)
try1("inner tol 1e-10, maxit 1000", ic = list(tol = 1e-10, maxit = 1000))
try1("inner tol 1e-10 + restarts", ic = list(tol = 1e-10, maxit = 1000), restarts = 3)
EOF
cd /tmp/claude-0 && timeout 1500 Rscript dbg2d5.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -6
```

Output:

```
default                          false convergence (8)        obj 15.034897 grad 0.0013  17.3s
restart x3                       false convergence (8)        obj 15.034522 grad 0.0011  23.1s
inner tol 1e-10, maxit 1000      false convergence (8)        obj 15.036075 grad 0.005  19.5s
inner tol 1e-10 + restarts       false convergence (8)        obj 15.036158 grad 0.005  27.0s
Shell cwd was reset to /home/user/FLa4a
```

## 148. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && timeout 1800 Rscript /tmp/claude-0/conv2d.R 2>&1 | tail -8
```

Output:

```
* DONE (FLa4a)
  ML   50  0    0
  REML 48  1    1
        i  method conv maxgrad
REML.32 33 REML   1    0.015  
REML.46 47 REML   <NA> <NA>   
        warn                                                                                
REML.32                                                                                     
REML.46 ERROR: system is computationally singular: reciprocal condition number = 6.66717e-17
```

## 149. 

```sh
grep -n "determinant(Hr)\|nopar = length(bPos)" R/model.R | head -4
```

Output:

```
345:      marginal <- obj$fn(full) + 0.5 * as.numeric(determinant(Hr)$modulus) -
352:       nopar = length(bPos) - length(data$par$re) + sum(edf),
435:    ld <- determinant(Hr)
```

## 150. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && Rscript -e "t0<-Sys.time(); source('src/examples/09-reml-coverage.R'); cat('TIME', round(as.numeric(Sys.time()-t0, units='secs')), 's\n')" > /tmp/claude-0/reml-study.log 2>&1; grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$\|^saved" /tmp/claude-0/reml-study.log | tail -80
```

Output:

```
Command running in background with ID: bhej0k8dc. Output is being written to: /tmp/claude-0/-home-user-FLa4a/4d5b0f74-01d4-5e68-a45a-2360deb285c7/tasks/bhej0k8dc.output. You will be notified when it completes. To check interim output, use Read on that file path.
```

## 151. 

```sh
Rscript -e '
r <- readRDS("src/examples/09-reml-coverage/results.rds")
for (s in names(r)) {
  ci <- r[[s]]$ci; ci$w <- log(ci$upper/ci$lower)
  key <- paste(ci$quantity, ci$year, ci$age, ci$sim)
  ml <- ci[ci$method=="ML",]; re <- ci[ci$method=="REML",]
  k <- intersect(paste(ml$quantity, ml$year, ml$age, ml$sim), paste(re$quantity, re$year, re$age, re$sim))
  ml <- ml[match(k, paste(ml$quantity, ml$year, ml$age, ml$sim)),]; re <- re[match(k, paste(re$quantity, re$year, re$age, re$sim)),]
  rat <- re$w/ml$w
  cat(s, "\n"); print(round(rbind(median_ratio = tapply(rat, ml$quantity, median), mean_ratio = tapply(rat, ml$quantity, mean),
     q10 = tapply(rat, ml$quantity, quantile, 0.1), q90 = tapply(rat, ml$quantity, quantile, 0.9)), 3))
}'
```

Output:

```
unpenalised 
              fbar harvest   rec   ssb
median_ratio 1.237   1.233 1.208 1.202
mean_ratio   1.218   1.216 1.193 1.189
q10          1.140   1.152 1.126 1.111
q90          1.250   1.249 1.223 1.237
penalised1D 
              fbar harvest   rec   ssb
median_ratio 0.978   1.021 1.140 1.115
mean_ratio   0.965   1.023 1.137 1.115
q10          0.873   0.946 1.096 1.077
q90          1.036   1.113 1.166 1.151
penalised2D 
              fbar harvest   rec   ssb
median_ratio 0.697   0.735 1.041 0.962
mean_ratio   0.699   0.732 1.032 0.960
q10          0.617   0.639 0.990 0.920
q90          0.782   0.823 1.068 0.996
```

## 152. 

```sh
Rscript -e '
r <- readRDS("src/examples/09-reml-coverage/results.rds")
for (s in names(r)) {
  ci <- r[[s]]$ci; ci$e <- log(ci$estimate/ci$truth); ci$w <- log(ci$upper/ci$lower)
  cat(s, "  RMSE of log estimate (x100)\n")
  print(round(100*sqrt(tapply(ci$e^2, list(ci$quantity, ci$method), mean)), 2))
}'
```

Output:

```
unpenalised   RMSE of log estimate (x100)
          ML REML
fbar    4.70 4.68
harvest 5.88 5.85
rec     4.93 4.90
ssb     4.28 4.27
penalised1D   RMSE of log estimate (x100)
          ML REML
fbar    4.19 3.36
harvest 5.62 5.12
rec     4.92 4.83
ssb     4.46 4.41
penalised2D   RMSE of log estimate (x100)
          ML REML
fbar    4.72 2.63
harvest 8.37 5.23
rec     5.77 5.43
ssb     2.98 2.57
```

## 153. 

```sh
python3 - <<'EOF'
p='src/examples/09-reml-coverage.R'; s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a[:50]
    s=s.replace(a,b)
rep("""  cov <- tapply(ci$covered, list(ci$quantity, ci$method), mean)[quantities, ]
  width <- tapply(ci$width, list(ci$quantity, ci$method), mean)[quantities, ]
  bias <- tapply(ci$logerror, list(ci$quantity, ci$method), mean)[quantities, ]""","""  cov <- tapply(ci$covered, list(ci$quantity, ci$method), mean)[quantities, ]
  bias <- tapply(ci$logerror, list(ci$quantity, ci$method), mean)[quantities, ]
  rmse <- sqrt(tapply(ci$logerror^2, list(ci$quantity, ci$method), mean))[quantities, ]
  # interval width ratio REML / ML, paired by simulation and cell (median)
  key <- paste(ci$quantity, ci$year, ci$age, ci$sim)
  ml <- ci[ci$method == "ML", ]
  re <- ci[ci$method == "REML", ]
  both <- intersect(key[ci$method == "ML"], key[ci$method == "REML"])
  ml <- ml[match(both, key[ci$method == "ML"]), ]
  re <- re[match(both, key[ci$method == "REML"]), ]
  widthRatio <- tapply(re$width / ml$width, ml$quantity, stats::median)[quantities]""")
rep("""  list(study = s, label = r$label, nsim = r$nsim, coverage = cov, widthRatio = width[, "REML"] / width[, "ML"],
       bias = bias, sdBias = sdBias, secs = r$secs, converged = r$converged)""","""  list(study = s, label = r$label, nsim = r$nsim, coverage = cov, widthRatio = widthRatio,
       bias = bias, rmse = rmse, sdBias = sdBias, secs = r$secs, converged = r$converged)""")
rep("""  cat("interval width, REML / ML:\\n"); print(round(s$widthRatio, 3))
  cat("mean log error (bias):\\n"); print(round(s$bias, 4))""","""  cat("interval width, REML / ML (median over paired intervals):\\n"); print(round(s$widthRatio, 3))
  cat("mean log error (bias):\\n"); print(round(s$bias, 4))
  cat("root mean square log error:\\n"); print(round(s$rmse, 4))""")
rep("""rerun <- TRUE""","""rerun <- !file.exists(file.path(outDir, "results.rds"))""")
rep("""# src/examples/09-reml-coverage/results.rds; set `rerun <- FALSE` to redo
# only the summaries and plots.""","""# src/examples/09-reml-coverage/results.rds; later runs only redo the
# summaries and plots (delete the file, or set `rerun <- TRUE`, to refit).""")
rep("""# Each simulated data set is fitted by ML and by REML, and 95% intervals
# from derivedCI() are checked against the truth.""","""# Each simulated data set is fitted by ML and by REML, and 95% intervals
# from derivedCI() are checked against the truth. With penalised smoothers,
# REML also estimates the smoothing parameters, and it improves the accuracy
# of F as well as the intervals.""")
open(p,'w').write(s)
EOF
Rscript -e "source('src/examples/09-reml-coverage.R')" 2>&1 | grep -A5 "root mean" | head -20; ls src/examples/09-reml-coverage/
```

Output:

```
root mean square log error:
            ML   REML
ssb     0.0428 0.0427
fbar    0.0470 0.0468
rec     0.0493 0.0490
harvest 0.0588 0.0585
--
root mean square log error:
            ML   REML
ssb     0.0446 0.0441
fbar    0.0419 0.0336
rec     0.0492 0.0483
harvest 0.0562 0.0512
--
root mean square log error:
            ML   REML
ssb     0.0298 0.0257
fbar    0.0472 0.0263
rec     0.0577 0.0543
harvest 0.0837 0.0523
coverage.png
results.rds
sd-estimates.png
summaries.rds
```

## 154. 

```sh
python3 - <<'EOF'
p='NEWS.md'; s=open(p).read()
old="""  coverage close to 95% (see `src/examples/09-reml-coverage.R`).
"""
new="""  coverage close to 95% (see `src/examples/09-reml-coverage.R`). With
  penalised smoothers REML also estimates the smoothing parameters, which
  makes F more accurate (e.g. 44% lower error in Fbar for a 2D smoother).
* Fellner-Schall smoothing parameter updates now use step control (a step
  is halved until the marginal likelihood improves); previously they could
  occasionally diverge.
* Fits whose Laplace-based optimisation stops with "false convergence" at a
  small gradient are treated as converged.
"""
assert s.count(old)==1
open(p,'w').write(s.replace(old,new))
EOF
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "writ\|warn\|error"; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 timeout 2400 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A6 | head -20
```

Output:

```
 ERROR
Running the tests in ‘tests/testthat.R’ failed.
Last 13 lines of output:
  > test_check("FLa4a")
  [ FAIL 2 | WARN 0 | SKIP 0 | PASS 135 ]
  
  ══ Failed tests ════════════════════════════════════════════════════════════════
--
Status: 1 ERROR
See
  ‘/tmp/claude-0/chk/FLa4a.Rcheck/00check.log’
for details.
Shell cwd was reset to /home/user/FLa4a
```

## 155. 

```sh
cat > /tmp/claude-0/fsdbg.R <<'EOF'
suppressMessages(library(FLa4a)); data(ple4); data(ple4.index)
f <- sca(ple4, ple4.index, fmodel = ~ s(age, k = 5) + s(year, k = 25, bs = "ps"), qmodel = list(~ s(age, k = 4)),
         penalise = "fmodel", verbose = TRUE)
print(fitSumm(f)[c("convergence", "maxgrad"), 1]); print(smoothing(f))
EOF
cd /tmp/claude-0 && Rscript fsdbg.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$\|^  [0-9]*:\|outer mgc\|iter:" | tail -20
```

Output:

```
Fellner-Schall iteration 1: marginal nll 101.8801, max step in log lambda 4.25
Fellner-Schall iteration 2: marginal nll 62.911607, max step in log lambda 0.72
convergence     maxgrad 
    0.00000    12.30553 
              iter
                       1
  fMod:s(age)  -1.138618
  fMod:s(year)  4.248726
Shell cwd was reset to /home/user/FLa4a
```

## 156. 

```sh
R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1 && Rscript /tmp/claude-0/fsdbg.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -12
```

Output:

```
* DONE (FLa4a)
outer mgc:  2.904809 
outer mgc:  2.904809 
outer mgc:  2.904809 
outer mgc:  2.904809 
Fellner-Schall iteration 14: marginal nll 57.65263, max step in log lambda 0.000591
outer mgc:  2.904809 
convergence     maxgrad 
 0.0000e+00  4.6501e-06 
              iter
                       1
  fMod:s(age)  -1.191686
  fMod:s(year)  5.497797
```

## 157. 

```sh
timeout 1500 Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -8
```

Output:

```
getX: ..........
penalised: ......................
reml: .............
sca: ................................
simdata: ................................
simulate: ............................

== DONE ========================================================================
```

## 158. 

```sh
rm -f src/examples/09-reml-coverage/results.rds && Rscript -e "t0<-Sys.time(); source('src/examples/09-reml-coverage.R'); cat('TIME', round(as.numeric(Sys.time()-t0, units='secs')), 's\n')" > /tmp/claude-0/reml-study.log 2>&1; grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$\|^saved" /tmp/claude-0/reml-study.log | tail -95
```

Output:

```
ssb     0.910 0.953
fbar    0.883 0.951
rec     0.893 0.948
harvest 0.896 0.954
interval width, REML / ML (median over paired intervals):
    ssb    fbar     rec harvest 
  1.202   1.237   1.208   1.233 
mean log error (bias):
             ML    REML
ssb      0.0024  0.0028
fbar    -0.0006 -0.0007
rec      0.0016  0.0017
harvest -0.0010 -0.0013
root mean square log error:
            ML   REML
ssb     0.0428 0.0427
fbar    0.0470 0.0468
rec     0.0493 0.0490
harvest 0.0588 0.0585
relative bias of observation sd estimates:
           ML   REML
catch  -0.202 -0.001
survey -0.028  0.003
seconds per fit:
  ML REML 
 0.2  1.1 
converged:
  ML REML 
   1    1 
== Penalised 1D: F ~ s(age) + s(year) ( 200 simulations )
coverage of 95% intervals:
           ML  REML
ssb     0.907 0.938
fbar    0.922 0.956
rec     0.917 0.948
harvest 0.899 0.935
interval width, REML / ML (median over paired intervals):
    ssb    fbar     rec harvest 
  1.120   1.109   1.123   1.118 
mean log error (bias):
             ML    REML
ssb      0.0097  0.0086
fbar    -0.0031 -0.0026
rec     -0.0002 -0.0004
harvest -0.0060 -0.0052
root mean square log error:
            ML   REML
ssb     0.0445 0.0441
fbar    0.0340 0.0336
rec     0.0485 0.0483
harvest 0.0518 0.0512
relative bias of observation sd estimates:
           ML   REML
catch  -0.127  0.003
survey -0.041 -0.004
seconds per fit:
  ML REML 
 0.5  1.2 
converged:
  ML REML 
   1    1 
== Penalised 2D: F ~ s(age) + s(year) + ti(age, year) ( 50 simulations )
coverage of 95% intervals:
           ML  REML
ssb     0.945 0.956
fbar    0.952 0.963
rec     0.943 0.956
harvest 0.906 0.917
interval width, REML / ML (median over paired intervals):
    ssb    fbar     rec harvest 
  1.051   1.047   1.053   1.048 
mean log error (bias):
             ML    REML
ssb     -0.0018 -0.0018
fbar     0.0033  0.0029
rec     -0.0025 -0.0030
harvest  0.0038  0.0039
root mean square log error:
            ML   REML
ssb     0.0256 0.0258
fbar    0.0260 0.0260
rec     0.0537 0.0536
harvest 0.0523 0.0526
relative bias of observation sd estimates:
           ML   REML
catch  -0.040  0.028
summer -0.023 -0.001
winter -0.009  0.012
seconds per fit:
  ML REML 
 7.0 21.8 
converged:
  ML REML 
0.94 0.92 
TIME 581 s
```

## 159. 

```sh
python3 - <<'EOF'
p='NEWS.md'; s=open(p).read()
a="""  coverage close to 95% (see `src/examples/09-reml-coverage.R`). With
  penalised smoothers REML also estimates the smoothing parameters, which
  makes F more accurate (e.g. 44% lower error in Fbar for a 2D smoother).
"""
b="""  coverage close to 95% (see `src/examples/09-reml-coverage.R`); estimates
  are unchanged. With penalised smoothers REML also estimates the smoothing
  parameters.
"""
assert s.count(a)==1
s=s.replace(a,b)
a="""  confidence intervals cover the truth about 89% of the time; REML brings"""
assert s.count(a)==1
open(p,'w').write(s)
EOF
grep -n "REML" NEWS.md | head -5; grep -n "REML\|44" src/examples/09-reml-coverage.R | head -8; cd /tmp/claude-0 && rm -rf chk && mkdir chk && cd chk && R CMD build /home/user/FLa4a >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 timeout 2400 R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | grep -E "WARNING|NOTE|ERROR|Status" -A6 | head -12
```

Output:

```
3:* `sca(..., method = "REML")` estimates the observation variances and any
7:  confidence intervals cover the truth about 89% of the time; REML brings
9:  are unchanged. With penalised smoothers REML also estimates the smoothing
1:# ML versus REML: bias of the observation variances and interval coverage
5:# confidence intervals are too narrow. REML (sca(..., method = "REML"))
14:# Each simulated data set is fitted by ML and by REML, and 95% intervals
16:# REML also estimates the smoothing parameters, and it improves the accuracy
58:# Fit every simulated data set by ML and REML
66:  lapply(c("ML", "REML"), function(method) {
96:         secs = tapply(sapply(runs, `[[`, "secs"), rep(c("ML", "REML"), study$nsim), mean),
97:         converged = tapply(sapply(runs, `[[`, "converged"), rep(c("ML", "REML"), study$nsim), mean),
Status: OK
Shell cwd was reset to /home/user/FLa4a
```

## 160. 

```sh
python3 - <<'EOF'
p='src/examples/09-reml-coverage.R'; s=open(p).read()
a="""# REML also estimates the smoothing parameters, and it improves the accuracy
# of F as well as the intervals. Results are saved to"""
b="""# REML also estimates the smoothing parameters. The estimates are equally
# accurate under both methods; REML widens the intervals to restore
# coverage. Results are saved to"""
assert s.count(a)==1
open(p,'w').write(s.replace(a,b))
EOF
git status --short && git add R man NAMESPACE NEWS.md README.md tests DESCRIPTION && git commit -q -m "Add REML estimation of observation variances

sca(..., method = \"REML\") estimates the observation variance parameters
and any smoothing parameters by restricted maximum likelihood: all other
coefficients are integrated out with RTMB's Laplace approximation (flat
priors on the unpenalised ones), starting from the ML fit. The covariance
of the coefficients is conditional on the variance parameters, whose own
covariance comes from the restricted likelihood.

ML underestimates the observation variances (the catch sd by 20% in the
\"simple\" scenario), so 95% intervals cover 88-91%; REML brings coverage
to about 95% without changing the estimates.

Also:
- Fellner-Schall updates of smoothing parameters use step control (halve
  the step until the marginal likelihood improves); they could diverge
- Laplace-based fits stopping with \"false convergence\" at a small
  gradient are treated as converged
- a singular smoother Hessian flags the fit instead of stopping it

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git add src/examples && git commit -q -m "Add ML versus REML coverage study example

src/examples/09-reml-coverage.R compares ML and REML on simulated data for
unpenalised, penalised 1D and penalised 2D models: bias of observation sd
estimates, coverage of 95% intervals, accuracy and interval widths.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012DTSaigMeQFXMwgFoSwBxU" && git push origin claude/peaceful-babbage-if9ubk 2>&1 | tail -1
```

Output:

```
 M NEWS.md
 M R/model.R
 M R/sca.R
 M README.md
 M man/sca.Rd
 M src/examples/README.md
?? src/examples/09-reml-coverage.R
?? tests/testthat/test-reml.R
   fc748d6..46bfa63  claude/peaceful-babbage-if9ubk -> claude/peaceful-babbage-if9ubk
```

## 161. 

```sh
grep -n "obs\$w <- \|centering <- vapply\|nllObs <- \|sdObs <- \|pmin(pmax(g\$age\|ia <- ifelse\|varLogR\|srCV^2\|sqrt(log(dat\$srCV\|lag <- \|min(step, 5)\|pmin(pmax(loglam\|improvement < \|1e-6) break\|< 1e-3)\|tol = 0.01\|1:3) {\|tol = 1e-4\|contr.sum\|e\$values < max" R/*.R | cut -c1-150
```

Output:

```
R/data.R:32:    centering <- vapply(obsList, function(x) mean(log(x$obs)), numeric(1))
R/data.R:44:  obs$w <- 1 / (obs$w / mean(obs$w))
R/data.R:49:  obs$ia <- ifelse(obs$biomass, 1L, match(obs$age, ages))
R/data.R:64:    g$age <- pmin(pmax(g$age, idxAges[[i - 1]][1]), idxAges[[i - 1]][2])
R/formula.R:18:getX <- function(formula, df, tol = 1e-4) a4aDesign(formula, df, tol)$X
R/formula.R:27:a4aDesign <- function(formula, df, tol = 1e-4, penalise = FALSE) {
R/formula.R:28:  opts <- options(contrasts = c(unordered = "contr.sum", ordered = "contr.poly"))
R/formula.R:71:  N <- e$vectors[, e$values < max(e$values) * 1e-8, drop = FALSE]
R/model.R:81:  sdObs <- exp(logV[(fleet - 1) * nC + cell])
R/model.R:82:  nllObs <- -dat$w * dnorm(dat$obs, pred, sdObs, log = TRUE)
R/model.R:94:    lag <- if (dat$srID == 4) 1 else dat$srAge
R/model.R:109:    nllSR <- -sum(dnorm(logN[1, yrs], predLogR, sqrt(log(dat$srCV^2 + 1)), log = TRUE))
R/model.R:366:  for (i in 1:3) {
R/model.R:405:      if (max(abs(g)) < 1e-6) break
R/model.R:424:    list(x = x, H = H, converged = max(abs(gr(x))) < 1e-3)
R/model.R:460:    pmin(pmax(loglam + step, -20), 25) - loglam
R/model.R:495:    if (improvement < tol * 1e-2) {
R/model.R:542:laplaceConvergence <- function(opt, maxgrad, tol = 0.01) {
```

## 162. 

```sh
cat R/srmodels.R | sed -n 18,40p; grep -n "par\$re <- \|par\$loglambda <- \|srCV = \|srID = \|spr0 = \|srAge" R/data.R; grep -n "sra = lp\|srb = lp(\|sqrt(log(dat\$srCV\|^etaMap\|rows <- rows + nrow(X)\|t <- do.call(rbind, trip)" R/model.R
```

Output:

```
#' @param CV coefficient of variation of recruitment around the curve.
#' @param a,b formulas for the (log-scale) parameters.
#' @param SPR0 spawners per recruit at F = 0 (`bevholtSV` only).
#' @return a list describing the model.
#' @name srmodels
NULL

srList <- function(name, id, CV, a, b, SPR0 = 1) {
  if (!is.numeric(CV) || length(CV) != 1 || CV <= 0) stop("CV must be a single positive number")
  list(srr = name, ID = id, srrCV = CV, a = a, b = b, SPR0 = SPR0)
}

#' @rdname srmodels
#' @export
bevholt <- function(CV = 0.5, a = ~1, b = ~1) srList("bevholt", 1L, CV, a, b)

#' @rdname srmodels
#' @export
ricker <- function(CV = 0.5, a = ~1, b = ~1) srList("ricker", 2L, CV, a, b)

#' @rdname srmodels
#' @export
hockey <- function(CV = 0.5, a = ~1, b = ~1) srList("hockey", 3L, CV, a, b)
140:  par$re <- numeric(nre)
141:  par$loglambda <- numeric(nlam)
161:    srID = if (is.null(sr$sr)) 0L else sr$sr$ID,
162:    srCV = if (is.null(sr$sr)) 0 else sr$sr$srrCV,
163:    spr0 = if (is.null(sr$sr)) 1 else sr$sr$SPR0,
164:    srAge = ages[1],
39:       sra = lp("sra", par$rapar), srb = lp("srb", par$rbpar))
109:    nllSR <- -sum(dnorm(logN[1, yrs], predLogR, sqrt(log(dat$srCV^2 + 1)), log = TRUE))
185:etaMap <- function(data) {
203:    rows <- rows + nrow(X)
205:  t <- do.call(rbind, trip)
```

## 163. 

```sh
sed -n '/^fitA4a <- function/,/^}/p' R/model.R; sed -n '/^newtonPolish/,/^}/p;/^fitREML/,/^}/p;/^fitLaplace/,/^}/p' R/model.R; grep -n "he <- function(x)" R/model.R
```

Output:

```
fitA4a <- function(data, fit = "assessment", verbose = FALSE, control = list(),
                   sp.method = c("efs", "laplace"), method = c("ML", "REML")) {
  sp.method <- match.arg(sp.method)
  method <- match.arg(method)
  dat <- data$dat
  ctrl <- utils::modifyList(list(eval.max = 1e4, iter.max = 1e4), control)
  penalised <- length(data$par$re) > 0

  obj <- MakeADFun(function(p) a4aNll(p, dat), data$par, silent = !verbose)
  np <- length(obj$par)
  lamPos <- np - length(data$par$loglambda) + seq_along(data$par$loglambda)
  bPos <- setdiff(seq_len(np), lamPos)
  full <- obj$par
  maxgrad <- NULL

  if (!penalised) {
    opt <- stats::nlminb(full, obj$fn, obj$gr, control = ctrl)
    full <- newtonPolish(obj, opt$par)
    convergence <- opt$convergence
  } else {
    hess <- hessianFun(data)
    sp <- fitSmoothing(obj, hess, data, full, bPos, lamPos, ctrl, verbose)
    full <- sp$par
    convergence <- sp$convergence
    if (sp.method == "laplace") {
      lap <- fitLaplace(data, full, ctrl, verbose)
      full <- lap$par
      convergence <- lap$convergence
      maxgrad <- lap$maxgrad
    }
  }

  marginal <- NA_real_
  if (method == "REML") {
    rem <- fitREML(data, full, ctrl, verbose)
    full <- rem$par
    convergence <- max(convergence, rem$convergence)
    maxgrad <- rem$maxgrad
    marginal <- rem$objective
  }

  pos <- data$colmap$pos
  coefs <- stats::setNames(full[pos], data$pnames)
  report <- obj$report(full)
  H <- if (penalised) hess(full) else if (fit == "assessment") obj$he(full)

  vcov <- NULL
  if (fit == "assessment") {
    V <- if (method == "ML") {
      tryCatch(chol2inv(chol(H)), error = function(e) NULL)
    } else {
      # REML: the coefficients' covariance is conditional on the variance
      # parameters, which are not at a joint-likelihood optimum (so the joint
      # Hessian need not be positive definite there); the variance
      # parameters' covariance comes from the restricted likelihood
      v <- which(names(obj$par)[b
... [truncated] ...
tion(e) NULL)
    if (is.null(step) || !is.finite(obj$fn(par - step)) || maxgrad(par - step) >= maxgrad(par)) break
    par <- par - step
  }
  par
}
fitREML <- function(data, par, ctrl, verbose) {
  inner <- setdiff(names(data$par)[lengths(data$par) > 0], c("vpar", "loglambda"))
  obj <- MakeADFun(function(p) a4aNll(p, data$dat), relistPar(par, data$par), random = inner,
                   silent = !verbose)
  opt <- stats::nlminb(obj$par, obj$fn, obj$gr, control = ctrl)
  objective <- obj$fn(opt$par)
  full <- obj$env$last.par
  maxgrad <- max(abs(obj$gr(opt$par)))
  # covariance of the variance parameters from the curvature of the
  # restricted likelihood (marginal over any smoothing parameters)
  Hout <- stats::optimHess(opt$par, obj$fn, obj$gr)
  Vout <- tryCatch(solve(Hout), error = function(e) NULL)
  vparOut <- names(opt$par) == "vpar"
  list(par = full, objective = objective, convergence = laplaceConvergence(opt, maxgrad),
       maxgrad = maxgrad, vcovVpar = if (!is.null(Vout)) Vout[vparOut, vparOut, drop = FALSE])
}
fitLaplace <- function(data, par, ctrl, verbose) {
  obj <- MakeADFun(function(p) a4aNll(p, data$dat), relistPar(par, data$par), random = "re",
                   silent = !verbose)
  opt <- stats::nlminb(obj$par, obj$fn, obj$gr, control = ctrl)
  obj$fn(opt$par)
  maxgrad <- max(abs(obj$gr(opt$par)))
  list(par = obj$env$last.par, convergence = laplaceConvergence(opt, maxgrad), maxgrad = maxgrad)
}
401:  he <- function(x) { par[bPos] <- x; hess(par) }
```

## 164. 

```sh
sed -n '/penalised <- length(first\$edf) > 0/,/^  }$/p' R/sca.R | head -30
```

Output:

```
  penalised <- length(first$edf) > 0
  marginal <- penalised || method == "REML"
  comps <- c(fleets, if (first$data$dat$srID > 0) "srr", if (penalised) "smooth")
  summNames <- c("nopar", "nlogl", "maxgrad", "nobs", "convergence", paste0("nlogl:", comps),
                 if (marginal) "nlogl:marginal", if (penalised) paste0("edf:", names(first$edf)))
  out@fitSumm <- matrix(NA_real_, length(summNames), nit, dimnames = list(summNames, iter = seq_len(nit)))

  for (i in seq_len(nit)) {
    f <- fits[[i]]
    out@stock.n[, , , , , i] <- f$quants$stock.n
    out@harvest[, , , , , i] <- f$quants$harvest
    out@catch.n[, , , , , i] <- f$quants$catch.n
    for (j in seq_along(indices)) out@index[[j]][, , , , , i] <- f$quants$index[[j]]
    out@coefficients[, i] <- f$par
    if (!is.null(f$vcov)) out@vcov[, , i] <- f$vcov
    out@centering[, i] <- f$data$centering
    out@smoothing[, i] <- f$loglambda
    out@fitSumm[, i] <- c(f$nopar, f$nlogl, f$maxgrad, f$data$nobs, f$convergence,
                          f$report$nllComp, if (marginal) f$objective, if (penalised) f$edf)
  }
```

## 165. 

```sh
Rscript -e 'roxygen2::roxygenise()' 2>&1 | grep -i "warn\|error"; R CMD INSTALL --no-docs -l ~/Rlib . 2>&1 | tail -1; cat > /tmp/claude-0/rr1.R <<'EOF'
suppressMessages(library(FLa4a))
d <- simScenario("sr", seed = 1)
run <- function(label, ...) {
  t0 <- Sys.time()
  f <- do.call(sca, c(list(d$stock, d$indices), utils::modifyList(d$models, list(...)[intersect(names(list(...)), names(d$models))]),
                      list(...)[setdiff(names(list(...)), names(d$models))]))
  s <- fitSumm(f)[, 1]
  cat(sprintf("%-26s %5.1fs conv %d maxgrad %.1g nopar %.1f nlogl %.2f", label, as.numeric(Sys.time() - t0, units = "secs"),
              s[["convergence"]], s[["maxgrad"]], s[["nopar"]], s[["nlogl"]]))
  if ("srr:cv" %in% names(s)) cat(sprintf("  CV %.3f  edfR %.1f", s[["srr:cv"]], s[["edf:recruitment"]]))
  cat(sprintf("  rec err %.3f  vcovNA %s\n", sqrt(mean(log(c(stock.n(f)[1, ]) / c(d$truth$rec))^2)), anyNA(vcov(f))))
  invisible(f)
}
run("bevholt CV fixed 0.3", srmodel = ~ bevholt(CV = 0.3))
run("bevholt CV estimated", srmodel = ~ bevholt(CV = NA))
run("geomean CV estimated", srmodel = ~ geomean(CV = NA))
run("bevholt CV est, REML", srmodel = ~ bevholt(CV = NA), method = "REML")
run("free recruitment", srmodel = ~ factor(year))
EOF
timeout 900 Rscript /tmp/claude-0/rr1.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -8
```

Output:

```
* DONE (FLa4a)
bevholt CV fixed 0.3         0.8s conv 0 maxgrad 2e-12 nopar 103.0 nlogl -291.38  rec err 0.036  vcovNA FALSE
bevholt CV estimated         3.8s conv 0 maxgrad 0.003 nopar 101.9 nlogl -292.91  CV 0.260  edfR 38.9  rec err 0.036  vcovNA FALSE
geomean CV estimated         2.6s conv 0 maxgrad 0.001 nopar 101.5 nlogl -293.20  CV 0.393  edfR 39.5  rec err 0.038  vcovNA FALSE
bevholt CV est, REML         6.8s conv 0 maxgrad 6e-05 nopar 101.8 nlogl -287.61  CV 0.268  edfR 38.8  rec err 0.036  vcovNA FALSE
free recruitment             0.7s conv 0 maxgrad 6e-12 nopar 101.0 nlogl -294.57  rec err 0.035  vcovNA FALSE
```

## 166. 

```sh
timeout 1500 Rscript -e 'testthat::test_local(".", reporter = "summary")' 2>&1 | tail -12
```

Output:

```
getX: ..........
penalised: ......................
reml: .............
sca: ................................
simdata: ................................
simulate: ............................

== DONE ========================================================================
```

## 167. 

```sh
cat > /tmp/claude-0/rr2.R <<'EOF'
suppressMessages(library(FLa4a))
trueCV <- sqrt(exp(0.3^2) - 1)
study <- function(label, ...) {
  d <- simScenario("sr", nsim = 40, seed = 11, ...)
  res <- parallel::mclapply(1:40, function(i) {
    stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
    fitOne <- function(sr, method = "ML") {
      m <- d$models; m$srmodel <- sr
      f <- tryCatch(do.call(sca, c(list(stk, idx), m, list(method = method, fit = "MP"))), error = function(e) NULL)
      if (is.null(f) || fitSumm(f)["convergence", 1] != 0) return(c(NA, NA))
      c(rmse = sqrt(mean(log(c(stock.n(f)[1, ]) / c(d$truth$rec))^2)),
        cv = if ("srr:cv" %in% rownames(fitSumm(f))) fitSumm(f)["srr:cv", 1] else NA)
    }
    rbind(free = fitOne(~ factor(year)), fixed = fitOne(~ bevholt(CV = 0.3)),
          randomML = fitOne(~ bevholt(CV = NA)), randomREML = fitOne(~ bevholt(CV = NA), "REML"))
  }, mc.cores = 4)
  a <- simplify2array(res)
  cat("\n==", label, "(true CV", round(trueCV, 3), ")\n")
  print(round(cbind(recRMSE = apply(a[, 1, ], 1, mean, na.rm = TRUE),
                    meanCV = apply(a[, 2, ], 1, mean, na.rm = TRUE),
                    converged = apply(!is.na(a[, 1, ]), 1, mean)), 3))
}
study("sr scenario")
study("data-poor: catch sd 0.3, survey sd 0.5", catch.sd = 0.3,
      surveys = list(simSurvey("survey", ages = 1:7, q = 2e-3, sd = 0.5, time = 0.5)))
EOF
cd /tmp/claude-0 && timeout 2400 Rscript rr2.R 2>&1 | grep -v "^Load\|lattice\|FLCore (\|masked\|bevholt, \|^Attaching\|^$" | tail -16
```

Output:

```
== sr scenario (true CV 0.307 )
           recRMSE meanCV converged
free         0.047    NaN         1
fixed        0.044    NaN         1
randomML     0.043  0.231         1
randomREML   0.043  0.239         1
== data-poor: catch sd 0.3, survey sd 0.5 (true CV 0.307 )
           recRMSE meanCV converged
free         0.126    NaN         1
fixed        0.105    NaN         1
randomML     0.105  0.222         1
randomREML   0.105  0.232         1
Shell cwd was reset to /home/user/FLa4a
```

## 168. 

```sh
cat > /tmp/claude-0/rr3.R <<'EOF'
suppressMessages(library(FLa4a))
res <- parallel::mclapply(1:12, function(i) {
  d <- simScenario("sr", seed = 100 + i, catch.sd = 0.01,
                   surveys = list(simSurvey("survey", ages = 1:7, q = 2e-3, sd = 0.01, time = 0.5)))
  S <- c(d$truth$ssb); R <- c(d$truth$rec); n <- length(R)
  dev <- log(R[-1]) - log(2e6 * S[-n] / (2e5 + S[-n]))   # true curve, SSB of the previous year
  m <- d$models; m$srmodel <- ~ bevholt(CV = NA)
  f <- do.call(sca, c(list(d$stock, d$indices), m, list(fit = "MP")))
  est <- fitSumm(f)["srr:cv", 1]
  # sd of deviations from the estimated curve, recomputed from the fitted recruitments and SSB
  stk <- d$stock + f
  Sf <- c(ssb(stk)); Rf <- c(rec(stk))
  fitDev <- log(Rf[-1]) - log(Sf[-n]) 
  c(realisedSD = sd(dev), realisedRMS = sqrt(mean(dev^2)), estSD = sqrt(log(est^2 + 1)), conv = fitSumm(f)["convergence", 1])
}, mc.cores = 4)
r <- do.call(rbind, res); print(round(r, 3)); print(round(colMeans(r), 3))
EOF
cd /tmp/claude-0 && timeout 1200 Rscript rr3.R 2>&1 | tail -16
```

Output:

```
      realisedSD realisedRMS estSD conv
 [1,]      0.276       0.273 0.271    0
 [2,]      0.351       0.365 0.339    0
 [3,]      0.285       0.281 0.279    0
 [4,]      0.248       0.245 0.223    0
 [5,]      0.242       0.240 0.238    0
 [6,]      0.260       0.258 0.257    0
 [7,]      0.272       0.268 0.267    0
 [8,]      0.239       0.236 0.235    0
 [9,]      0.328       0.329 0.324    0
[10,]      0.319       0.318 0.303    0
[11,]      0.349       0.358 0.337    0
[12,]      0.310       0.316 0.394    0
 realisedSD realisedRMS       estSD        conv 
      0.290       0.291       0.289       0.000
Shell cwd was reset to /home/user/FLa4a
```

## 169. 

```sh
timeout 900 Rscript -e 'testthat::test_local(".", filter = "random-recruitment", reporter = "summary")' 2>&1 | tail -12
```

Output:

```
random-recruitment: .................

== DONE ========================================================================
You are a coding rockstar!
```

## 170. Update NEWS, roxygenise, run tests

```sh
python3 - <<'EOF'
p='NEWS.md'
s=open(p).read()
new='''# FLa4a 2.0.0.9000

* Recruitment as a random effect: an SR model with `CV = NA`, e.g.
  `srmodel = ~ bevholt(CV = NA)`, estimates the recruitment variability
  (log sd) and integrates the recruitments out of the likelihood by the
  Laplace approximation, rather than fixing the CV. `fitSumm()` reports the
  estimated CV (`srr:cv`) and the recruitments' effective degrees of
  freedom (`edf:recruitment`). Works with `method = "REML"` and penalised
  smoothers. In simulations it improves recruitment estimates when the data
  are weak; the CV tends to be underestimated (about 25% with noisy data).

'''
s=s.replace('# FLa4a 2.0.0.9000\n\n',new,1)
open(p,'w').write(s)
EOF
Rscript -e 'roxygen2::roxygenise()' 2>&1 | tail -5
Rscript -e 'devtools::test()' 2>&1 | tail -15
```

Output:

```
i Loading FLa4a
Loading required package: FLCore
Loading required package: lattice
FLCore (Version 2.6.33, packaged: Tue Sep 29 21:18:14 2026)
- |          5 | simulate                                                       
/ |          8 | simulate                                                       
\ |         10 | simulate                                                       
| |         11 | simulate                                                       
/ |         20 | simulate                                                       
\ |         22 | simulate                                                       
- |         25 | simulate                                                       
\ |         26 | simulate                                                       
| |         27 | simulate                                                       
v |         28 | simulate [8.2s]

== Results =====================================================================
Duration: 66.2 s

[ FAIL 0 | WARN 0 | SKIP 0 | PASS 154 ]
```

## 171. Build and R CMD check

```sh
cd /home/user/FLa4a/.. && rm -rf chk && mkdir chk && cd chk && R CMD build ../FLa4a >/dev/null 2>&1 && LANG=C.UTF-8 LC_ALL=C.UTF-8 _R_CHECK_FORCE_SUGGESTS_=false R CMD check --no-manual FLa4a_*.tar.gz 2>&1 | tail -8; grep -c test_that ../FLa4a/tests/testthat/test-random-recruitment.R; cat FLa4a.Rcheck/tests/testthat.Rout 2>/dev/null | tail -3
```

Output:

```
* checking for unstated dependencies in ‘tests’ ... OK
* checking tests ...
  Running ‘testthat.R’
 OK
* DONE

Status: OK

3
> proc.time()
   user  system elapsed 
 63.403   1.625  65.992
Shell cwd was reset to /home/user/FLa4a
```

## 172. List all scratch R files and show ADMB comparison script

```sh
cd /tmp/claude-0 && ls *.R *.txt *.rds ex 2>/dev/null; ls | tail -25; cat cmp.R
```

Output:

```
cmp.R
conv2d.R
cov1.R
cov2.R
dbg.R
dbg2d.R
dbg2d2.R
dbg2d3.R
dbg2d4.R
dbg2d5.R
dflt.R
fsdbg.R
hess.R
pen1.R
pen2.R
pen3.R
pen4.R
prof.R
prof2.R
prof3.R
readme_sim.R
readme_snip.R
refrun.R
reml1.R
reml2.R
rr1.R
rr2.R
rr3.R
se.R
sim1.R
simdata1.R
sr.R

ex:
01-01.png
01-02.png
01-03.png
01-04.png
01.log
02-01.png
02-02.png
02-03.png
02-04.png
02-05.png
02.log
03-01.png
03-02.png
03.log
04-01.png
04.log
05-01.png
05-02.png
05-03.png
mv01.log
mv04.log
run01.log
run02.log
run03.log
run04.log
run05.log
run07.log
run08.log
pen4.R
pen4.log
pkgdepends
prof.R
prof2.R
prof3.R
readme_sim.R
readme_snip.R
ref
ref.log
reflib
refrun.R
reml-study.log
reml1.R
reml2.R
report-preview.html
report-shot.png
rr1.R
rr2.R
rr3.R
rtmb.log
se.R
sim1.R
simdata1.R
sr.R
args <- commandArgs(TRUE)
lib <- if (args[1] == "ref") "/tmp/claude-0/reflib" else "~/Rlib"
.libPaths(c(lib, .libPaths()))
suppressMessages(library(FLa4a))
data(ple4); data(ple4.indices); data(ple4.index)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
bidx <- as(ple4.index, "FLIndexBiomass"); index(bidx) <- quantSums(index(ple4.index) * stock.wt(ple4)[1:10, ac(1996:2017)]); range(bidx)[c("startf","endf")] <- c(0.6, 0.7)
cases <- list(
  sep   = list(ple4, ple4.index, fmodel=~factor(age)+factor(year), qmodel=list(~factor(age))),
  smth  = list(ple4, idx, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4), ~s(age,k=3))),
  deflt = list(ple4, idx),
  bh    = list(ple4, ple4.index, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4)), srmodel=~bevholt(CV=0.3)),
  gm    = list(ple4, ple4.index, fmodel=~te(age,year,k=c(4,15)), qmodel=list(~s(age,k=4)), srmodel=~geomean(CV=0.5)),
  bio   = list(ple4, FLIndices(a=ple4.index, b=bidx), fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4), ~1))
)
res <- lapply(names(cases), function(n) {
  t <- system.time(fit <- suppressWarnings(do.call(sca, cases[[n]])))[3]
  s <- fitSumm(fit)
  data.frame(case=n, nopar=s["nopar",1], nlogl=s["nlogl",1], ssb2017=c(ssb(ple4+fit)[, "2017"]),
             fbar2017=c(fbar(ple4+fit)[, "2017"]), rec2017=c(stock.n(fit)[1, "2017"]), idxb=c(index(fit)[[length(index(fit))]][1,"2000"]), sec=t)
})
print(do.call(rbind, res), digits = 7, row.names = FALSE)
Shell cwd was reset to /home/user/FLa4a
```

## 173. Inspect ADMB reference run files

```sh
cd /tmp/claude-0 && du -sh ref reflib ex chk; ls ref | head; cat refrun.R; head -30 ref.log rtmb.log
```

Output:

```
12M	ref
11M	reflib
1.4M	ex
888K	chk
BinaryFiles
DESCRIPTION
Makefile
NAMESPACE
NEWS
NEWS.md
R
README.md
_pkgdown.yml
appveyor.yml
.libPaths(c("/tmp/claude-0/reflib", .libPaths()))
suppressMessages(library(FLa4a))
data(ple4); data(ple4.index)
fit <- sca(ple4, ple4.index, fmodel=~factor(age)+factor(year), qmodel=list(~factor(age)), fit="assessment")
print(fitSumm(fit))
print(coef(fit)@stkmodel[1:5])
==> ref.log <==
* installing *source* package 'FLa4a' ...
** using staged installation
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
*** copying figures
** building package indices
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (FLa4a)

==> rtmb.log <==
* installing *source* package 'RTMB' ...
** using staged installation
** libs
using C++ compiler: 'g++ (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0'
g++ -std=gnu++17 -I"/usr/share/R/include" -DNDEBUG -DTMB_EIGEN_DISABLE_WARNINGS -I'/usr/lib/R/site-library/Rcpp/include' -I'/usr/lib/R/site-library/TMB/include' -I'/usr/lib/R/site-library/RcppEigen/include'     -fpic  -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/build/r-base-FPSnzf/r-base-4.3.3=. -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection -fdebug-prefix-map=/build/r-base-FPSnzf/r-base-4.3.3=/usr/src/r-base-4.3.3-2build2 -Wdate-time -D_FORTIFY_SOURCE=3  -c RTMB.cpp -o RTMB.o
g++ -std=gnu++17 -I"/usr/share/R/include" -DNDEBUG -DTMB_EIGEN_DISABLE_WARNINGS -I'/usr/lib/R/site-library/Rcpp/include' -I'/usr/lib/R/site-library/TMB/include' -I'/usr/lib/R/site-library/RcppEigen/include'     -fpic  -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/build/r-base-FPSnzf/r-base-4.3.3=. -fstack-protector-strong -f
... [truncated] ...
ror=format-security -fcf-protection -fdebug-prefix-map=/build/r-base-FPSnzf/r-base-4.3.3=/usr/src/r-base-4.3.3-2build2 -Wdate-time -D_FORTIFY_SOURCE=3  -c poshess.cpp -o poshess.o
g++ -std=gnu++17 -shared -L/usr/lib/R/lib -Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -Wl,-z,relro -o RTMB.so RTMB.o RTMB_tape.o RcppExports.o TMB.o distributions.o interpol.o lapack.o math.o math_complex.o misc.o poshess.o -llapack -lblas -lgfortran -lm -lquadmath -L/usr/lib/R/lib -lR
installing to /root/Rlib/00LOCK-RTMB/00new/RTMB/libs
** R
** inst
** byte-compile and prepare package for lazy loading
Creating a generic function for 'fft' from package 'stats' in package 'RTMB'
Creating a generic function for 'colSums' from package 'base' in package 'RTMB'
Creating a generic function for 'rowSums' from package 'base' in package 'RTMB'
Creating a generic function for 'diag' from package 'base' in package 'RTMB'
Creating a generic function for 'dexp' from package 'stats' in package 'RTMB'
Creating a generic function for 'dweibull' from package 'stats' in package 'RTMB'
Creating a generic function for 'dbinom' from package 'stats' in package 'RTMB'
Creating a generic function for 'dbeta' from package 'stats' in package 'RTMB'
Creating a generic function for 'df' from package 'stats' in package 'RTMB'
Creating a generic function for 'dlogis' from package 'stats' in package 'RTMB'
Creating a generic function for 'dt' from package 'stats' in package 'RTMB'
Shell cwd was reset to /home/user/FLa4a
```
