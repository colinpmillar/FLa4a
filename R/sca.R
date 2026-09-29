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
#'   formulas.
#' @param fit `"assessment"` (default) also computes the parameter covariance
#'   matrix; `"MP"` only estimates parameters.
#' @param center logical, center each fleet's log observations before fitting.
#' @param verbose logical, print optimiser output.
#' @param control list of control options passed to [stats::nlminb()].
#' @return an [a4aFit-class] object.
#' @examples
#' data(ple4)
#' data(ple4.index)
#' fit <- sca(ple4, ple4.index,
#'            fmodel = ~ s(age, k = 4) + s(year, k = 20),
#'            qmodel = list(~ s(age, k = 4)))
#' fit
#' stk <- ple4 + fit
#' @export
sca <- function(stock, indices,
                fmodel = defaultFmod(stock),
                qmodel = defaultQmod(indices),
                srmodel = defaultSRmod(stock),
                n1model = defaultN1mod(stock),
                vmodel = defaultVmod(stock, indices),
                covar = NULL, fit = c("assessment", "MP"), center = TRUE,
                verbose = FALSE, control = list()) {

  fit <- match.arg(fit)
  if (is(indices, "FLIndex") || is(indices, "FLIndexBiomass")) indices <- FLIndices(indices)
  nms <- names(indices)
  if (is.null(nms) || any(nms == "")) nms <- rep("index", length(indices))
  names(indices) <- make.unique(nms)

  d <- dims(stock)
  if (d$unit > 1 || d$season > 1 || d$area > 1)
    stop("only stocks with a single unit, season and area are supported")
  if (length(qmodel) != length(indices)) stop("qmodel needs one formula per index")
  if (length(vmodel) != length(indices) + 1) stop("vmodel needs one formula for the catch and one per index")

  # iterations of stock and indices must be 1 or n
  its <- c(d$iter, vapply(indices, function(x) dims(x)$iter, numeric(1)))
  nit <- max(its)
  if (any(its != 1 & its != nit)) stop("inconsistent number of iterations in stock and indices")

  fits <- lapply(seq_len(nit), function(i) {
    stk <- iter(stock, min(i, d$iter))
    idx <- FLIndices(lapply(indices, function(x) iter(x, min(i, dims(x)$iter))))
    data <- a4aData(stk, idx, fmodel = fmodel, qmodel = qmodel, vmodel = vmodel,
                    n1model = n1model, srmodel = srmodel, covar = covar, center = center)
    res <- fitA4a(data, fit = fit, verbose = verbose, control = control)
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
                  n1model = n1model, srmodel = srmodel))

  summNames <- c("nopar", "nlogl", "maxgrad", "nobs", "convergence",
                 paste0("nlogl:", c(fleets, if (length(first$report$nllComp) > length(fleets)) "srr")))
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
    out@fitSumm[, i] <- c(length(f$par), f$nlogl, f$maxgrad, f$data$nobs, f$convergence,
                          f$report$nllComp)
  }
  units(out@harvest) <- "f"
  out
}

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
