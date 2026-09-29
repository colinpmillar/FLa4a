#' Predict from a fit, optionally with new covariate values
#'
#' Evaluates the fitted model with its estimated parameters: fishing
#' mortality, numbers, catch and indices. Covariates given in `covar`
#' replace the values used in the fit; the others are kept. The submodels
#' keep their fitted bases, so smoothers of covariates are evaluated at the
#' new values with the same knots and coefficients.
#'
#' Recruitment and numbers in the first year are the fitted values unless
#' their submodels (`srmodel`, `n1model`) use covariates. Numbers at older
#' ages follow from the (possibly new) fishing mortality.
#'
#' @param object an `a4aFit` with a single iteration.
#' @param stock,indices the `FLStock` and `FLIndices` the model was fitted
#'   to. They provide the biology (natural mortality, weights, maturity),
#'   the survey timing and the observation pattern; biology may be changed.
#' @param covar named list of `FLQuant` covariates with new values.
#' @param ... not used.
#' @return a list with `stock.n`, `harvest`, `catch.n` (FLQuants) and
#'   `index` (FLQuants), the expected values.
#' @seealso [simulate()] to add observation error.
#' @rdname predict-a4aFit
#' @export
setMethod("predict", "a4aFit", function(object, stock, indices, covar = list(), ...) {
  indices <- prepIndices(indices)
  m <- modelAt(object, stock, indices, covar)
  predictQuants(list(report = m$report(m$par)), m$data, iter(stock, 1),
                FLIndices(lapply(indices, iter, 1)))
})

#' Simulate catch and survey indices from a fit
#'
#' Generates new catch-at-age and index observations from a fitted model,
#' optionally with new covariate values (see [predict()]). Observations are
#' lognormal around the expected values, with the standard deviations of the
#' fitted variance model, at the cells that were observed in the data.
#'
#' The result has `nsim` iterations and can be refitted directly with
#' [sca()], e.g. to test whether an effect is recoverable.
#'
#' @param object an `a4aFit` with a single iteration.
#' @param nsim number of simulations.
#' @param seed optional random seed.
#' @param stock,indices the `FLStock` and `FLIndices` the model was fitted to.
#' @param covar named list of `FLQuant` covariates with new values. A
#'   covariate with `nsim` iterations gives each simulation its own values.
#' @param sample.pars logical; if `TRUE` each simulation uses parameters drawn
#'   from their estimated multivariate normal distribution (needs a fit with
#'   `fit = "assessment"`), otherwise the estimates are used.
#' @param ... not used.
#' @return a list with `stock`, an `FLStock` whose `catch.n` holds the
#'   simulated catches and whose `stock.n` and `harvest` hold the true values,
#'   and `indices`, an `FLIndices` of simulated indices.
#' @rdname simulate-a4aFit
#' @export
setMethod("simulate", "a4aFit", function(object, nsim = 1, seed = NULL, stock, indices,
                                         covar = list(), sample.pars = FALSE, ...) {
  if (!is.null(seed)) set.seed(seed)
  indices <- prepIndices(indices)
  stock <- iter(stock, 1)
  indices <- FLIndices(lapply(indices, iter, 1))

  ncv <- max(1, vapply(covar, function(x) dims(x)$iter, numeric(1)))
  if (ncv != 1 && ncv != nsim) stop("covariates must have 1 or nsim iterations")

  par <- c(coef(object)[, 1])
  pars <- matrix(par, nsim, length(par), byrow = TRUE)
  if (sample.pars) {
    V <- vcov(object)[, , 1]
    if (anyNA(V)) stop("sample.pars needs a covariance matrix: fit with fit = \"assessment\"")
    # multivariate normal draws: par + L z with V = L L'
    z <- matrix(stats::rnorm(nsim * length(par)), length(par), nsim)
    pars <- t(par + t(chol(V)) %*% z)
  }

  stk <- propagate(stock, nsim)
  idx <- FLIndices(lapply(indices, propagate, nsim))
  m <- NULL
  for (i in seq_len(nsim)) {
    if (is.null(m) || ncv > 1) m <- modelAt(object, stock, indices, lapply(covar, iterOf, i))
    rep <- m$report(pars[i, ])
    q <- predictQuants(list(report = rep), m$data, stock, indices)

    # lognormal observation error at the observed cells
    d <- m$data$dat
    y <- exp(rep$pred + stats::rnorm(length(rep$pred), 0, rep$sdObs / sqrt(d$w)) +
               m$data$centering[d$fleet])
    sims <- obsToQuants(y, m$data$obs, stock, indices)

    stock.n(stk)[, , , , , i] <- q$stock.n
    harvest(stk)[, , , , , i] <- q$harvest
    catch.n(stk)[, , , , , i] <- sims[[1]]
    for (j in seq_along(indices)) index(idx[[j]])[, , , , , i] <- sims[[j + 1]]
  }

  # landings and discards keep their observed proportions of the catch
  ratio <- catch.n(stk) / propagate(catch.n(stock), nsim)
  landings.n(stk) <- landings.n(stk) * ratio
  discards.n(stk) <- discards.n(stk) * ratio
  catch(stk) <- computeCatch(stk, na.rm = FALSE)
  landings(stk) <- computeLandings(stk, na.rm = FALSE)
  discards(stk) <- computeDiscards(stk, na.rm = FALSE)
  stock(stk) <- computeStock(stk, na.rm = FALSE)

  list(stock = stk, indices = idx)
})

# The fitted model set up at (possibly new) covariate values: the data built
# with the fitted designs and centering, and an RTMB object to evaluate it.
modelAt <- function(object, stock, indices, covar = list()) {
  if (dims(object@stock.n)$iter > 1) stop("predict and simulate need a fit with a single iteration")
  if (!identical(names(indices), names(object@index)))
    stop("indices must be the ones the model was fitted to: ", paste(names(object@index), collapse = ", "))
  unused <- setdiff(names(covar), names(object@covar))
  if (length(unused)) warning("covariates not used by the model: ", paste(unused, collapse = ", "), call. = FALSE)

  cv <- object@covar
  cv[names(covar)] <- covar
  mod <- object@models
  data <- a4aData(iter(stock, 1), FLIndices(lapply(indices, iter, 1)),
                  fmodel = mod$fmodel, qmodel = mod$qmodel, vmodel = mod$vmodel,
                  n1model = mod$n1model, srmodel = mod$srmodel,
                  covar = lapply(cv, iter, 1), designs = object@design,
                  centering = c(object@centering[, 1]))
  obj <- MakeADFun(function(p) a4aNll(p, data$dat), data$par, silent = TRUE)
  # evaluate the model at a coefficient vector (in design column order), with
  # penalised smoother coefficients and log smoothing parameters as fitted
  lam <- if (length(object@smoothing)) object@smoothing[, 1] else numeric(0)
  report <- function(coefs) {
    p <- numeric(length(obj$par))
    p[data$colmap$pos] <- coefs
    p[length(p) - length(lam) + seq_along(lam)] <- lam
    obj$report(p)
  }
  list(data = data, report = report, par = c(coef(object)[, 1]))
}

# Put observation-level values back into FLQuants shaped like the catch and
# each index; cells without an observation are NA.
obsToQuants <- function(y, obs, stock, indices) {
  templates <- c(list(catch.n(stock)), lapply(indices, index))
  lapply(seq_along(templates), function(f) {
    out <- templates[[f]]
    out[] <- NA
    rows <- obs$fleet == f
    dn <- dimnames(out)
    ia <- if (f > 1 && is(indices[[f - 1]], "FLIndexBiomass")) rep(1L, sum(rows))
          else match(obs$age[rows], as.numeric(dn$age))
    iy <- match(obs$year[rows], as.numeric(dn$year))
    out@.Data[cbind(ia, iy, 1, 1, 1, 1)] <- y[rows]
    out
  })
}
