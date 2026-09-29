#' Stock-recruitment models
#'
#' Functions used inside `srmodel` formulas to request a stock-recruitment
#' relationship, e.g. `srmodel = ~ bevholt(CV = 0.2)`. Recruitment (log scale)
#' is then a free parameter per year, penalised towards the stock-recruitment
#' curve with a lognormal error with coefficient of variation `CV`.
#'
#' The parameters `a` and `b` are on the log scale and can themselves be
#' modelled with a formula in `year`, e.g. `a = ~ factor(breakpts(year, 2000))`.
#'
#' * `bevholt`: \eqn{R = a S / (b + S)}
#' * `ricker`: \eqn{R = a S \exp(-b S)}
#' * `hockey`: smooth hockey stick (Mesnil and Rochet, gamma = 0.1)
#' * `geomean`: \eqn{R = a}
#' * `bevholtSV`: Beverton-Holt parametrised by steepness (`a`, logit-scaled
#'   onto 0.2 to 1) and virgin biomass (`b`), given `SPR0`.
#'
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

#' @rdname srmodels
#' @export
geomean <- function(CV = 0.5, a = ~1) srList("geomean", 4L, CV, a, NULL)

#' @rdname srmodels
#' @export
bevholtSV <- function(CV = 0.5, SPR0 = 1, a = ~1, b = ~1) srList("bevholtSV", 5L, CV, a, b, SPR0)

srNames <- c("bevholt", "ricker", "hockey", "geomean", "bevholtSV")

# Split an srmodel formula into the recruitment model and the SR relationship.
# `~ bevholt(CV = 0.2)` -> list(rmodel = ~ factor(year), sr = <bevholt list>)
# `~ s(year, k = 10)`   -> list(rmodel = ~ s(year, k = 10), sr = NULL)
parseSRmodel <- function(srmodel) {
  rhs <- srmodel[[length(srmodel)]]
  if (is.call(rhs) && as.character(rhs[[1]]) %in% srNames) {
    list(rmodel = ~ factor(year), sr = eval(rhs, environment(srmodel)))
  } else {
    if (any(all.names(rhs) %in% srNames))
      stop("a stock-recruitment model must be the only term in srmodel")
    list(rmodel = srmodel, sr = NULL)
  }
}
