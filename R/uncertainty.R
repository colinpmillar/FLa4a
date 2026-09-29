#' Confidence intervals for derived quantities
#'
#' Delta-method confidence intervals for spawning stock biomass, mean
#' fishing mortality over the `fbar` ages, recruitment, fishing mortality
#' at age and the numbers at age in the first year (the `n1model`). The quantities are computed on the log scale as functions of the
#' coefficients, their Jacobian is taken by automatic differentiation, and
#' the intervals use the coefficients' covariance matrix
#' (`fit = "assessment"`). For penalised smoothers this is their posterior
#' covariance given the estimated smoothing parameters.
#'
#' @param object an `a4aFit` with a single iteration, fitted with
#'   `fit = "assessment"`.
#' @param stock,indices the `FLStock` and `FLIndices` the model was fitted to
#'   (for the biology, the fbar range and the survey information).
#' @param level confidence level.
#' @param quantities any of `"ssb"`, `"fbar"`, `"rec"`, `"harvest"` and
#'   `"n1"` (numbers at age in the first year, ages after the first).
#' @return a `data.frame` with columns `quantity`, `age` (`NA` except for
#'   `harvest` and `n1`), `year`, `estimate`, `lower`, `upper` and `se` (the standard
#'   error of the log quantity). Intervals are symmetric on the log scale.
#' @examples
#' data(ple4)
#' data(ple4.index)
#' fit <- sca(ple4, ple4.index, fmodel = ~ s(age, k = 5) + s(year, k = 20),
#'            qmodel = list(~ s(age, k = 4)))
#' ci <- derivedCI(fit, ple4, ple4.index)
#' tail(ci[ci$quantity == "ssb", ])
#' @export
derivedCI <- function(object, stock, indices, level = 0.95,
                      quantities = c("ssb", "fbar", "rec", "harvest", "n1")) {
  quantities <- match.arg(quantities, several.ok = TRUE)
  indices <- prepIndices(indices)
  V <- vcov(object)[, , 1]
  if (anyNA(V)) stop("derivedCI needs a covariance matrix: fit with fit = \"assessment\"")

  m <- modelAt(object, stock, indices)
  data <- m$data
  dat <- data$dat
  np <- length(unlist(data$par))
  lam <- if (length(object@smoothing)) object@smoothing[, 1] else numeric(0)
  lamPos <- np - length(lam) + seq_along(lam)
  cen <- data$centering[[1]]
  rng <- range(stock)
  fbarAges <- which(data$ages >= rng[["minfbar"]] & data$ages <= rng[["maxfbar"]])
  nA <- dat$nA
  nY <- dat$nY

  # log quantities as a function of the coefficients
  logQuantities <- function(b) {
    "[<-" <- ADoverload("[<-")
    p <- numeric(np)
    p[data$colmap$pos] <- b
    if (length(lam)) p[lamPos] <- lam
    pop <- population(linearPredictors(relistPar(p, data$par), dat), dat)
    out <- list(
      ssb = log(colSums(exp(pop$logN - pop$F * matrix(dat$fspwn, nA, nY) -
                              pop$M * matrix(dat$mspwn, nA, nY)) * matrix(dat$matWt, nA, nY))) + cen,
      fbar = log(colSums(pop$F[fbarAges, , drop = FALSE]) / length(fbarAges)),
      rec = pop$logN[1, ] + cen,
      harvest = pop$logF,
      n1 = pop$logN[-1, 1] + cen)
    do.call(c, lapply(out[quantities], as.vector))
  }

  b <- m$par
  tape <- RTMB::MakeTape(logQuantities, b)
  est <- tape(b)
  J <- tape$jacobian(b)
  se <- sqrt(pmax(rowSums((J %*% V) * J), 0))
  z <- stats::qnorm(1 - (1 - level) / 2)

  lens <- c(ssb = nY, fbar = nY, rec = nY, harvest = nA * nY, n1 = nA - 1)[quantities]
  ageOf <- list(harvest = rep(data$ages, nY), n1 = data$ages[-1])
  yearOf <- list(harvest = rep(data$years, each = nA), n1 = rep(data$years[1], nA - 1))
  out <- data.frame(
    quantity = rep(quantities, lens),
    age = unlist(lapply(quantities, function(q) if (is.null(ageOf[[q]])) rep(NA, nY) else ageOf[[q]])),
    year = unlist(lapply(quantities, function(q) if (is.null(yearOf[[q]])) data$years else yearOf[[q]])),
    estimate = exp(est), lower = exp(est - z * se), upper = exp(est + z * se), se = se,
    stringsAsFactors = FALSE)
  rownames(out) <- NULL
  out
}
