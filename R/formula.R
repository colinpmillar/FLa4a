#' Build a design matrix from a submodel formula
#'
#' Turns a one-sided submodel formula into a model matrix. Formulas may mix
#' standard terms (`factor(age)`, `year`, ...) with 'mgcv' smoothers
#' (`s()`, `te()`, `ti()`); smoother bases are built with [mgcv::gam()] and
#' are unpenalised.
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
getX <- function(formula, df, tol = 1e-4) a4aDesign(formula, df, tol)$X

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
