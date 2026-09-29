#' Default submodels
#'
#' Formulas used by [sca()] when a submodel is not given. The number of
#' knots scales with the number of ages and years in the data.
#'
#' @param stock an `FLStock`.
#' @param indices an `FLIndices`.
#' @param dfm fraction of data points used to set the number of knots.
#' @return a formula, or a list of formulas.
#' @name defaultSubmodels
NULL

#' @rdname defaultSubmodels
#' @export
defaultFmod <- function(stock, dfm = c(0.5, 0.7)) {
  d <- dims(stock)
  ky <- floor(dfm[1] * d$year)
  ka <- ceiling(dfm[2] * d$age)
  if (ka >= 3) {
    ka <- min(max(3, ka), 6)
    kb <- min(max(3, ka), 10)
    stats::as.formula(sprintf("~ te(age, year, k = c(%d, %d), bs = 'tp') + s(age, k = %d)", ka, ky, kb))
  } else {
    stats::as.formula(sprintf("~ age + s(year, k = %d)", ky))
  }
}

#' @rdname defaultSubmodels
#' @export
defaultQmod <- function(indices, dfm = 0.6) {
  lapply(indices, function(x) ageModel(dims(x)$age, k = min(ceiling(dfm * dims(x)$age), 6)))
}

#' @rdname defaultSubmodels
#' @export
defaultN1mod <- function(stock) ageModel(dims(stock)$age, k = 3)

#' @rdname defaultSubmodels
#' @export
defaultVmod <- function(stock, indices) {
  c(list(ageModel(dims(stock)$age, k = 3)), lapply(seq_along(indices), function(i) ~1))
}

#' @rdname defaultSubmodels
#' @export
defaultSRmod <- function(stock) ~ factor(year)

ageModel <- function(nage, k) {
  if (nage == 1) return(~1)
  if (nage <= 3) return(~ factor(age))
  stats::as.formula(sprintf("~ s(age, k = %d)", k))
}
