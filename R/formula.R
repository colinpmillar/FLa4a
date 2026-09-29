#' Build a design matrix from a submodel formula
#'
#' Turns a one-sided submodel formula into a model matrix. Formulas may mix
#' standard terms (`factor(age)`, `year`, ...) with 'mgcv' smoothers
#' (`s()`, `te()`, `ti()`); smoother bases are built with
#' [mgcv::gam()] (`fit = FALSE`) and are unpenalised.
#'
#' The basis is built on the unique rows of `df` and then expanded back, so
#' duplicated rows (e.g. ages clamped to a survey's range) do not affect knot
#' placement. Columns that make the matrix rank deficient are dropped with a
#' warning.
#'
#' @param formula a one-sided formula.
#' @param df a `data.frame` holding the variables used in `formula`.
#' @param tol tolerance used to detect redundant columns.
#' @return a numeric matrix with `nrow(df)` rows.
#' @export
getX <- function(formula, df, tol = 1e-4) {
  opts <- options(contrasts = c(unordered = "contr.sum", ordered = "contr.poly"))
  on.exit(options(opts))

  key <- do.call(paste, df)
  udf <- df[!duplicated(key), , drop = FALSE]

  rhs <- formula[[length(formula)]]
  if (hasSmooth(rhs)) {
    G <- mgcv::gam(stats::reformulate(deparse1(rhs), response = ".y"),
                   data = cbind(.y = 1, udf), fit = FALSE)
    X <- G$X
    colnames(X) <- G$term.names
  } else {
    X <- stats::model.matrix(formula, udf)
  }
  if (nrow(X) != nrow(udf)) stop("NAs in covariates used by ", deparse1(formula))

  # drop redundant columns
  qrX <- qr(X)
  drop <- qrX$pivot[abs(diag(qrX$qr)) < tol]
  if (length(drop)) {
    warning(deparse1(formula), " has ", length(drop), " redundant parameter(s), removing: ",
            paste(colnames(X)[drop], collapse = ", "), call. = FALSE)
    X <- X[, -drop, drop = FALSE]
  }

  X <- X[match(key, do.call(paste, udf)), , drop = FALSE]
  attr(X, "assign") <- attr(X, "contrasts") <- NULL
  rownames(X) <- NULL
  X
}

hasSmooth <- function(expr) {
  any(all.names(expr) %in% c("s", "te", "ti", "t2"))
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
