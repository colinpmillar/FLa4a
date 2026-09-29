#' The a4aFit class
#'
#' Results of a statistical catch-at-age fit with [sca()].
#'
#' @slot call the call to [sca()].
#' @slot stock.n,harvest,catch.n estimated numbers, fishing mortality and catch at age.
#' @slot index fitted indices.
#' @slot fitSumm fit summary (statistic x iter): number of parameters,
#'   negative log-likelihood, maximum gradient, number of observations,
#'   convergence flag and likelihood components.
#' @slot coefficients parameter estimates (`FLPar`, params x iter).
#' @slot vcov parameter covariance (params x params x iter); `NA` when
#'   `fit = "MP"`.
#' @slot centering log-scale centering applied to each fleet (`FLPar`).
#' @slot models the submodel formulas.
#' @slot design the submodel designs (bases), used by [predict()] and
#'   [simulate()] to evaluate the submodels at new covariate values.
#' @slot covar the covariates used in the fit.
#' @slot smoothing log smoothing parameters of penalised smoothers
#'   (penalty x iter); empty for unpenalised fits.
#' @export
setClass("a4aFit", contains = "FLComp",
  slots = c(call = "call",
            stock.n = "FLQuant", harvest = "FLQuant", catch.n = "FLQuant",
            index = "FLQuants",
            fitSumm = "matrix",
            coefficients = "FLPar", vcov = "array", centering = "FLPar",
            models = "list", design = "list", covar = "list", smoothing = "matrix"))

#' @rdname a4aFit-class
#' @param object an `a4aFit`.
#' @param catch,... not used.
#' @export
setMethod("stock.n", "a4aFit", function(object) object@stock.n)
#' @rdname a4aFit-class
#' @export
setMethod("harvest", "a4aFit", function(object, catch, ...) object@harvest)
#' @rdname a4aFit-class
#' @export
setMethod("catch.n", "a4aFit", function(object) object@catch.n)
#' @rdname a4aFit-class
#' @export
setMethod("index", "a4aFit", function(object, ...) object@index)
#' @rdname a4aFit-class
#' @export
setMethod("coef", "a4aFit", function(object, ...) object@coefficients)
#' @rdname a4aFit-class
#' @export
setMethod("vcov", "a4aFit", function(object, ...) object@vcov)

#' @rdname a4aFit-class
#' @export
setGeneric("fitSumm", function(object, ...) standardGeneric("fitSumm"))
#' @rdname a4aFit-class
#' @export
setMethod("fitSumm", "a4aFit", function(object) object@fitSumm)

#' @rdname a4aFit-class
#' @export
setGeneric("smoothing", function(object, ...) standardGeneric("smoothing"))
#' @rdname a4aFit-class
#' @export
setMethod("smoothing", "a4aFit", function(object) object@smoothing)

#' @rdname a4aFit-class
#' @details `logLik()` returns the maximised log-likelihood (one value per
#'   iteration), so `AIC()` and `BIC()` work on fits.
#' @export
setMethod("logLik", "a4aFit", function(object, ...) {
  structure(-object@fitSumm["nlogl", ],
            df = object@fitSumm["nopar", 1], nobs = object@fitSumm["nobs", 1],
            class = "logLik")
})

#' @rdname a4aFit-class
#' @export
setMethod("show", "a4aFit", function(object) {
  cat("a4aFit:", object@name, "\n")
  cat("  ages:", paste(range(object)[c("min", "max")], collapse = " - "),
      "  years:", paste(range(object)[c("minyear", "maxyear")], collapse = " - "),
      "  iters:", dims(object@stock.n)$iter, "\n")
  cat("  fleets:", paste(c("catch", names(object@index)), collapse = ", "), "\n\n")
  print(t(object@fitSumm[c("nopar", "nlogl", "maxgrad", "nobs", "convergence"), , drop = FALSE]))
  invisible(object)
})

#' @rdname a4aFit-class
#' @param x an `a4aFit`.
#' @export
setMethod("print", "a4aFit", function(x, ...) show(x))

#' Update stocks and indices with fit results
#'
#' `stock + fit` replaces the numbers, fishing mortality and catch at age of
#' an `FLStock` with the estimates in an `a4aFit` (landings and discards are
#' scaled to match the fitted catch). `indices + fit` replaces the index
#' values with the fitted ones.
#'
#' @param e1 an `FLStock` or `FLIndices`.
#' @param e2 an `a4aFit`.
#' @return the updated `e1`.
#' @name addition
#' @aliases +,FLStock,a4aFit-method
#' @export
setMethod("+", c("FLStock", "a4aFit"), function(e1, e2) {
  nit <- max(dims(e1)$iter, dims(e2@stock.n)$iter)
  e1 <- propagate(e1, nit)
  ratio <- propagate(e2@catch.n, nit) / catch.n(e1)
  landings.n(e1) <- landings.n(e1) * ratio
  discards.n(e1) <- discards.n(e1) * ratio
  catch.n(e1) <- propagate(e2@catch.n, nit)
  stock.n(e1) <- propagate(e2@stock.n, nit)
  harvest(e1) <- propagate(e2@harvest, nit)
  catch(e1) <- computeCatch(e1, na.rm = FALSE)
  landings(e1) <- computeLandings(e1, na.rm = FALSE)
  discards(e1) <- computeDiscards(e1, na.rm = FALSE)
  stock(e1) <- computeStock(e1, na.rm = FALSE)
  e1
})

#' @rdname addition
#' @export
setMethod("+", c("FLIndices", "a4aFit"), function(e1, e2) {
  for (i in seq_along(e1)) index(e1[[i]]) <- e2@index[[i]]
  e1
})
