#' Statistical catch-at-age model
#'
#' Fits the a4a statistical catch-at-age model. Fishing mortality,
#' catchability, observation variance, initial numbers and recruitment are
#' each described by a linear submodel given as a formula in `age` and `year`
#' (plus any covariates). Formulas may use factors, polynomials and 'mgcv'
#' smoothers (`s()`, `te()`, `ti()`).
#'
#' The model is written in R and differentiated with 'RTMB'. Each iteration
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
#'
#' @param stock an `FLStock` with catch-at-age and biology.
#' @param indices an `FLIndices` (or a single `FLIndex`/`FLIndexBiomass`).
#' @param fmodel formula for log fishing mortality.
#' @param qmodel list of formulas for log catchability, one per index.
#' @param srmodel formula for log recruitment, or a stock-recruitment model
#'   such as `~ bevholt(CV = 0.2)` (see [srmodels]).
#' @param n1model formula for log numbers at age in the first year.
#' @param vmodel list of formulas for the log observation standard deviation,
#'   one for the catch followed by one per index.
#' @param covar optional named list of `FLQuant` covariates usable in the
#'   formulas. A covariate may vary by year (first dimension `"all"`) or by
#'   age and year, and may have one iteration or as many as the data.
#' @param fit `"assessment"` (default) also computes the parameter covariance
#'   matrix; `"MP"` only estimates parameters.
#' @param center logical, center each fleet's log observations before fitting.
#' @param penalise `TRUE` to penalise the smoothers of all submodels, or the
#'   names of the submodels to penalise, e.g. `"fmodel"` or
#'   `c("fmodel", "srmodel")`. Default `FALSE`.
#' @param sp.method how smoothing parameters are estimated: `"efs"`
#'   (default) uses extended Fellner-Schall updates (Wood and Fasiolo, 2017),
#'   which need only first and second derivatives and are fast; `"laplace"`
#'   then refines the estimates by maximising RTMB's Laplace approximation of
#'   the marginal likelihood directly, which is exact to that approximation
#'   but can be much slower for large tensor-product smoothers.
#' @param method `"ML"` (default) estimates all parameters by maximum
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
#' @param verbose logical, print optimiser output.
#' @param control list of control options passed to [stats::nlminb()].
#' @return an [a4aFit-class] object. With an estimated stock-recruitment CV
#'   (e.g. `srmodel = ~ bevholt(CV = NA)`), recruitment is a random effect:
#'   `fitSumm()` reports the estimated CV (`srr:cv`), the recruitments'
#'   effective degrees of freedom (`edf:recruitment`) and the marginal
#'   likelihood, and `nlogl` excludes the recruitment distribution. For penalised fits, `fitSumm()`
#'   reports the effective degrees of freedom of each smoother (`edf:`), the
#'   marginal negative log-likelihood (`nlogl:marginal`; the restricted
#'   likelihood for REML fits), and `nopar` counts
#'   unpenalised parameters plus the smoothers' effective degrees of freedom,
#'   so that `AIC()` is a conditional AIC. The log smoothing parameters are in
#'   `smoothing()`.
#' @examples
#' data(ple4)
#' data(ple4.index)
#' fit <- sca(ple4, ple4.index,
#'            fmodel = ~ s(age, k = 4) + s(year, k = 20),
#'            qmodel = list(~ s(age, k = 4)))
#' fit
#' stk <- ple4 + fit
#'
#' # penalised smoothers: a generous basis, smoothness estimated
#' pfit <- sca(ple4, ple4.index,
#'             fmodel = ~ s(age, k = 5) + s(year, k = 30, bs = "ps"),
#'             qmodel = list(~ s(age, k = 4)), penalise = "fmodel")
#' smoothing(pfit)
#' @export
sca <- function(stock, indices,
                fmodel = defaultFmod(stock),
                qmodel = defaultQmod(indices),
                srmodel = defaultSRmod(stock),
                n1model = defaultN1mod(stock),
                vmodel = defaultVmod(stock, indices),
                covar = NULL, fit = c("assessment", "MP"), center = TRUE,
                penalise = FALSE, sp.method = c("efs", "laplace"), method = c("ML", "REML"),
                verbose = FALSE, control = list()) {

  fit <- match.arg(fit)
  sp.method <- match.arg(sp.method)
  method <- match.arg(method)
  penalise <- penaliseKeys(penalise)
  indices <- prepIndices(indices)
  covar <- as.list(covar)

  d <- dims(stock)
  if (d$unit > 1 || d$season > 1 || d$area > 1)
    stop("only stocks with a single unit, season and area are supported")
  if (length(qmodel) != length(indices)) stop("qmodel needs one formula per index")
  if (length(vmodel) != length(indices) + 1) stop("vmodel needs one formula for the catch and one per index")

  # iterations of stock and indices must be 1 or n
  its <- c(d$iter, vapply(c(indices, covar), function(x) dims(x)$iter, numeric(1)))
  nit <- max(its)
  if (any(its != 1 & its != nit)) stop("inconsistent number of iterations in stock, indices and covar")

  fits <- lapply(seq_len(nit), function(i) {
    stk <- iter(stock, min(i, d$iter))
    idx <- FLIndices(lapply(indices, iterOf, i))
    data <- a4aData(stk, idx, fmodel = fmodel, qmodel = qmodel, vmodel = vmodel,
                    n1model = n1model, srmodel = srmodel, covar = lapply(covar, iterOf, i),
                    center = center, penalise = penalise)
    res <- fitA4a(data, fit = fit, verbose = verbose, control = control, sp.method = sp.method,
                  method = method)
    c(res, list(data = data, quants = predictQuants(res, data, stk, idx)))
  })

  #------------------------------------------------------------------
  # collect results over iterations
  #------------------------------------------------------------------
  first <- fits[[1]]
  fleets <- first$data$fleets
  pnames <- first$data$pnames
  byIter <- function(x) propagate(x, nit)

  out <- new("a4aFit",
    name = name(stock), desc = desc(stock), range = range(stock), call = match.call(),
    stock.n = byIter(first$quants$stock.n), harvest = byIter(first$quants$harvest),
    catch.n = byIter(first$quants$catch.n),
    index = FLQuants(lapply(first$quants$index, byIter)),
    coefficients = FLPar(NA, dimnames = list(params = pnames, iter = seq_len(nit))),
    vcov = array(NA_real_, c(length(pnames), length(pnames), nit),
                 list(pnames, pnames, iter = seq_len(nit))),
    centering = FLPar(NA, dimnames = list(params = fleets, iter = seq_len(nit))),
    models = list(fmodel = fmodel, qmodel = qmodel, vmodel = vmodel,
                  n1model = n1model, srmodel = srmodel),
    design = first$data$designs, covar = covar,
    smoothing = matrix(NA_real_, length(first$loglambda), nit,
                       dimnames = list(names(first$loglambda), iter = seq_len(nit))))

  penalised <- length(first$edf) > 0
  randomRec <- isTRUE(first$data$dat$randomRec)
  marginal <- penalised || randomRec || method == "REML"
  comps <- c(fleets, if (first$data$dat$srID > 0) "srr", if (penalised) "smooth")
  summNames <- c("nopar", "nlogl", "maxgrad", "nobs", "convergence", paste0("nlogl:", comps),
                 if (marginal) "nlogl:marginal", if (penalised) paste0("edf:", names(first$edf)),
                 if (randomRec) c("edf:recruitment", "srr:cv"))
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
                          f$report$nllComp, if (marginal) f$objective, if (penalised) f$edf,
                          if (randomRec) c(f$edfR, f$cvR))
  }
  units(out@harvest) <- "f"
  out
}

# Submodel keys (as used by a4aData) to penalise, from sca()'s `penalise`.
penaliseKeys <- function(penalise) {
  keys <- list(fmodel = "f", qmodel = "q", vmodel = "v", n1model = "n1", srmodel = c("r", "sra", "srb"))
  if (isTRUE(penalise)) return(unlist(keys, use.names = FALSE))
  if (isFALSE(penalise) || !length(penalise)) return(character(0))
  bad <- setdiff(penalise, names(keys))
  if (length(bad)) stop("penalise must be TRUE, FALSE or submodel names: ", paste(names(keys), collapse = ", "))
  unlist(keys[penalise], use.names = FALSE)
}

# Indices as a named FLIndices (a single FLIndex is accepted).
prepIndices <- function(indices) {
  if (is(indices, "FLIndex") || is(indices, "FLIndexBiomass")) indices <- FLIndices(indices)
  nms <- names(indices)
  if (is.null(nms) || any(nms == "")) nms <- rep("index", length(indices))
  names(indices) <- make.unique(nms)
  indices
}

# Iteration i of an object with 1 or n iterations.
iterOf <- function(x, i) iter(x, min(i, dims(x)$iter))

# Convert the reported model quantities of one fit into FLQuants.
predictQuants <- function(res, data, stock, indices) {
  rep <- res$report
  d <- data$dat
  nA <- d$nA
  nY <- d$nY
  cen <- data$centering

  flq <- function(x) FLQuant(x, dimnames = dimnames(stock.n(stock)), units = units(catch.n(stock)))
  F <- exp(rep$logF)
  Z <- F + matrix(d$M, nA, nY)
  N <- exp(rep$logN + cen[1])

  index <- lapply(seq_along(indices), function(j) {
    q <- matrix(exp(rep$logQ[(j - 1) * nA * nY + seq_len(nA * nY)] + cen[j + 1] - cen[1]), nA, nY)
    I <- q * N * exp(-Z * d$stime[j])
    tmpl <- index(indices[[j]])
    yrs <- match(dimnames(tmpl)$year, data$years)
    if (is(indices[[j]], "FLIndexBiomass")) {
      I <- colSums(I * matrix(d$stkWt, nA, nY) * d$bmask[, j])[yrs]
    } else {
      I <- I[match(dimnames(tmpl)$age, data$ages), yrs]
    }
    FLQuant(I, dimnames = dimnames(tmpl), units = units(tmpl))
  })
  names(index) <- names(indices)

  list(stock.n = flq(N), harvest = FLQuant(F, dimnames = dimnames(stock.n(stock)), units = "f"),
       catch.n = flq(F / Z * (1 - exp(-Z)) * N), index = index)
}
