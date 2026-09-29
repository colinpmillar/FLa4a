#' Simulate a stock and survey data with known truth
#'
#' Generates catch-at-age and survey indices from a known population, for
#' testing the model: recovery of the truth, confidence interval coverage,
#' smoothers, covariates, stock-recruitment models and biomass indices. The
#' population dynamics are computed here independently of the model code.
#'
#' Fishing mortality is `F[a, y] = sel[a, y] * Fmult[y]`, with logistic
#' selectivity whose age at 50% selection can drift linearly over the years
#' (`sel$shift`, making F non-separable) and `Fmult` scaled so that mean F
#' over `fbar` ages follows `Fbar`. Recruitment (at the first age) is
#' lognormal around a constant mean or a Beverton-Holt curve of the previous
#' year's SSB. Numbers start in equilibrium with the first year's F.
#' Observations are lognormal around their expected values, with no bias
#' correction, as assumed by [sca()].
#'
#' The truth is the same in every iteration; only observation errors differ,
#' so an `nsim` iteration data set can be fitted with one call to [sca()].
#'
#' @param ages,years ages and years.
#' @param M natural mortality (a single value).
#' @param Fbar mean F over the `fbar` ages in each year; by default rises
#'   from 0.2 to 0.7 and falls back to 0.3.
#' @param fbar the age range for mean F.
#' @param sel list with `a50` (age at 50% selection), `slope`, and `shift`
#'   (change in `a50` from the first to the last year).
#' @param rec list with `model` (`"random"` or `"bevholt"`), `mean` (mean
#'   recruitment for `"random"`), `a` and `b` (Beverton-Holt `R = a S / (b +
#'   S)`, S being SSB in tonnes) and `sd` (log-scale standard deviation).
#' @param surveys a list of [simSurvey()] specifications.
#' @param catch.sd log-scale standard deviation of catch at age.
#' @param covar named list of numeric vectors (one value per year) of
#'   covariates, used by `Fcovar` and the surveys' `covar`.
#' @param Fcovar named numeric vector of effects of covariates on log F.
#' @param winf,k weight at age is `winf * (1 - exp(-k * age))^3` (kg).
#' @param mat50 age at 50% maturity.
#' @param plusgroup logical, is the oldest age a plus group.
#' @param nsim number of iterations of observation error.
#' @param seed optional random seed.
#' @return a list with `stock` (an `FLStock` whose `catch.n` holds the
#'   simulated catches and whose `stock.n` and `harvest` hold the truth),
#'   `indices` (an `FLIndices`), `covar` (a named list of `FLQuant`s for
#'   [sca()]) and `truth`, a list of `FLQuant`s: `harvest`, `stock.n`,
#'   `catch.n` (expected), `ssb`, `fbar`, `rec`, `index` (expected indices)
#'   and `q` (catchability).
#' @seealso [simScenario()] for ready-made data sets.
#' @examples
#' d <- simStock(nsim = 2, seed = 1)
#' fit <- sca(d$stock, d$indices, fmodel = ~ factor(age) + factor(year),
#'            qmodel = list(~ factor(age)), fit = "MP")
#' @export
simStock <- function(ages = 1:8, years = 1991:2020, M = 0.2,
                     Fbar = NULL, fbar = c(2, 5),
                     sel = list(a50 = 2.5, slope = 0.7, shift = 0),
                     rec = list(model = "random", mean = 1e6, sd = 0.4),
                     surveys = list(simSurvey()),
                     catch.sd = 0.1, covar = list(), Fcovar = numeric(0),
                     winf = 1, k = 0.3, mat50 = 3, plusgroup = TRUE,
                     nsim = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  nA <- length(ages)
  nY <- length(years)
  sel <- utils::modifyList(list(a50 = 2.5, slope = 0.7, shift = 0), sel)
  rec <- utils::modifyList(list(model = "random", mean = 1e6, sd = 0.4), rec)
  rec$model <- match.arg(rec$model, c("random", "bevholt"))
  for (nm in names(covar)) if (length(covar[[nm]]) != nY) stop("covariate ", nm, " needs one value per year")
  if (length(setdiff(c(names(Fcovar), unlist(lapply(surveys, function(s) names(s$covar)))), names(covar))))
    stop("covariate effects refer to covariates not in covar")

  #------------------------------------------------------------------
  # biology and fishing mortality (age x year matrices)
  #------------------------------------------------------------------
  t01 <- if (nY > 1) (seq_len(nY) - 1) / (nY - 1) else 0
  if (is.null(Fbar)) Fbar <- 0.2 + 0.5 * exp(-((t01 - 0.55) / 0.25)^2) - 0.1 * t01
  if (length(Fbar) != nY) stop("Fbar needs one value per year")
  a50 <- sel$a50 + sel$shift * t01
  S <- outer(ages, a50, function(a, m) 1 / (1 + exp(-(a - m) / sel$slope)))
  S <- sweep(S, 2, apply(S, 2, max), "/")
  fb <- ages >= fbar[1] & ages <= fbar[2]
  logFcov <- rep(0, nY)
  for (nm in names(Fcovar)) logFcov <- logFcov + Fcovar[[nm]] * covar[[nm]]
  Fm <- sweep(S, 2, Fbar / colMeans(S[fb, , drop = FALSE]) * exp(logFcov), "*")
  Mm <- matrix(M, nA, nY)
  Z <- Fm + Mm
  wt <- matrix(winf * (1 - exp(-k * ages))^3, nA, nY)
  mat <- matrix(1 / (1 + exp(-(ages - mat50) * 2)), nA, nY)

  #------------------------------------------------------------------
  # population dynamics
  #------------------------------------------------------------------
  N <- matrix(NA_real_, nA, nY)
  eps <- stats::rnorm(nY, 0, rec$sd)
  ssbOf <- function(n) sum(n * wt[, 1] * mat[, 1])
  # equilibrium age structure with the first year's F
  R0 <- if (rec$model == "random") rec$mean else rec$a * 0.5
  surv <- c(1, cumprod(exp(-Z[-nA, 1])))
  eq <- R0 * surv
  if (plusgroup) eq[nA] <- eq[nA] / (1 - exp(-Z[nA, 1]))
  if (rec$model == "bevholt") {
    # scale to the equilibrium of the Beverton-Holt curve
    spr <- ssbOf(eq) / R0
    Req <- max(rec$a - rec$b / spr, rec$a * 0.05)
    eq <- eq * Req / R0
  }
  N[, 1] <- eq
  N[1, 1] <- N[1, 1] * exp(eps[1])
  ssb <- numeric(nY)
  ssb[1] <- sum(N[, 1] * wt[, 1] * mat[, 1])
  for (y in seq_len(nY)[-1]) {
    N[1, y] <- if (rec$model == "random") {
      rec$mean * exp(eps[y])
    } else {
      rec$a * ssb[y - 1] / (rec$b + ssb[y - 1]) * exp(eps[y])
    }
    if (nA > 1) {
      N[-1, y] <- N[-nA, y - 1] * exp(-Z[-nA, y - 1])
      if (plusgroup) N[nA, y] <- N[nA, y] + N[nA, y - 1] * exp(-Z[nA, y - 1])
    }
    # N is in thousands and weight in kg, so SSB is in tonnes
    ssb[y] <- sum(N[, y] * wt[, y] * mat[, y])
  }
  C <- Fm / Z * (1 - exp(-Z)) * N

  #------------------------------------------------------------------
  # FLR objects
  #------------------------------------------------------------------
  dn <- list(age = as.character(ages), year = as.character(years))
  flq <- function(x, units = "NA") FLQuant(x, dimnames = dn, units = units)
  lnorm <- function(mu, sd) {
    out <- propagate(mu, nsim)
    out[] <- exp(log(c(propagate(mu, nsim))) + stats::rnorm(length(out), 0, sd))
    out
  }

  stk <- FLStock(catch.n = flq(C, "1000"), name = "simulated", desc = "simulated with simStock()")
  stock.n(stk) <- flq(N, "1000")
  harvest(stk) <- flq(Fm, "f")
  m(stk) <- flq(Mm, "m")
  mat(stk) <- flq(mat)
  stock.wt(stk) <- catch.wt(stk) <- landings.wt(stk) <- discards.wt(stk) <- flq(wt, "kg")
  harvest.spwn(stk) <- m.spwn(stk) <- flq(0)
  range(stk)[c("minfbar", "maxfbar")] <- fbar
  range(stk)["plusgroup"] <- if (plusgroup) max(ages) else NA
  stk <- propagate(stk, nsim)
  catch.n(stk) <- lnorm(flq(C, "1000"), catch.sd)
  landings.n(stk) <- catch.n(stk)
  discards.n(stk)[] <- 0
  catch(stk) <- computeCatch(stk)
  landings(stk) <- computeLandings(stk)
  discards(stk) <- computeDiscards(stk)
  stock(stk) <- computeStock(stk)

  #------------------------------------------------------------------
  # surveys
  #------------------------------------------------------------------
  idx <- list()
  expected <- list()
  qs <- list()
  for (s in surveys) {
    yrs <- if (is.null(s$years)) years else s$years
    iy <- match(yrs, years)
    if (anyNA(iy)) stop("survey ", s$name, " has years outside the stock's years")
    sa <- if (is.null(s$ages)) ages else s$ages
    ia <- match(sa, ages)
    q <- if (is.function(s$q)) s$q(sa) else rep_len(s$q, length(sa))
    logQcov <- rep(0, length(yrs))
    for (nm in names(s$covar)) logQcov <- logQcov + s$covar[[nm]] * covar[[nm]][iy]
    Q <- outer(q, exp(logQcov))
    avail <- N[ia, iy, drop = FALSE] * exp(-Z[ia, iy, drop = FALSE] * s$time)
    sdn <- list(age = as.character(sa), year = as.character(yrs))
    if (isTRUE(s$biomass)) {
      I <- colSums(Q * avail * wt[ia, iy, drop = FALSE])
      mu <- FLQuant(I, dimnames = list(age = "all", year = as.character(yrs)))
      x <- FLIndexBiomass(index = lnorm(mu, s$sd), name = s$name)
      range(x)[c("min", "max")] <- range(sa)
    } else {
      mu <- FLQuant(Q * avail, dimnames = sdn)
      x <- FLIndex(index = lnorm(mu, s$sd), name = s$name)
    }
    range(x)[c("startf", "endf")] <- s$time
    idx[[s$name]] <- x
    expected[[s$name]] <- mu
    qs[[s$name]] <- FLQuant(Q, dimnames = sdn)
  }

  covarQ <- lapply(covar, function(v) FLQuant(v, dimnames = list(year = as.character(years))))
  yearly <- function(x, units = "NA") FLQuant(x, dimnames = list(age = "all", year = as.character(years)), units = units)
  list(stock = stk, indices = FLIndices(idx), covar = covarQ,
       truth = list(harvest = flq(Fm, "f"), stock.n = flq(N, "1000"), catch.n = flq(C, "1000"),
                    ssb = yearly(ssb, "t"), fbar = yearly(colMeans(Fm[fb, , drop = FALSE]), "f"),
                    rec = yearly(N[1, ], "1000"), index = FLQuants(expected), q = FLQuants(qs)))
}

#' @rdname simStock
#' @param name survey name.
#' @param q catchability: a single value, one value per age, or a function of age.
#' @param sd log-scale standard deviation of the index.
#' @param time timing of the survey as a fraction of the year.
#' @param biomass logical, a biomass index (summed over `ages`) rather than
#'   an index at age.
#' @export
simSurvey <- function(name = "survey", ages = NULL, years = NULL, q = 1e-3, sd = 0.2,
                      time = 0.5, biomass = FALSE, covar = numeric(0)) {
  list(name = name, ages = ages, years = years, q = q, sd = sd, time = time,
       biomass = biomass, covar = covar)
}

#' Ready-made simulated data sets
#'
#' Data sets from [simStock()] designed to test particular aspects of the
#' model, each with the submodels to fit it.
#'
#' * `"simple"`: 6 ages, 30 years, separable F, one survey. The suggested
#'   submodels are the *correct* ones (the truth is exactly representable),
#'   so it suits tests of bias and confidence interval coverage.
#' * `"smooth"`: 10 ages, 40 years, selectivity shifting to older ages over
#'   time (non-separable F), two surveys; for smoothers, including penalised
#'   ones.
#' * `"covariate"`: as `"simple"`, with the survey's catchability depending
#'   on a covariate `temp` (effect 0.4 on log q), and F varying over the
#'   years only through a covariate `effort` (effect 0.3 on log F); the
#'   correct submodels are `~ factor(age) + effort` and
#'   `~ factor(age) + temp`.
#' * `"sr"`: 8 ages, 40 years, Beverton-Holt recruitment and a strong
#'   contrast in SSB; for stock-recruitment models.
#' * `"biomass"`: as `"simple"`, plus a biomass survey.
#'
#' @param name the scenario.
#' @param nsim number of iterations of observation error.
#' @param seed optional random seed.
#' @param ... further arguments to [simStock()], replacing the scenario's
#'   (e.g. `catch.sd = 0.2`, or a new `surveys` list).
#' @return the [simStock()] list, plus `models`, a list of submodel
#'   formulas (`fmodel`, `qmodel`, `vmodel`, `n1model`, `srmodel`) for
#'   [sca()], and `scenario`.
#' @examples
#' d <- simScenario("simple", nsim = 2, seed = 1)
#' fit <- do.call(sca, c(list(d$stock, d$indices), d$models, fit = "MP"))
#' @export
simScenario <- function(name = c("simple", "smooth", "covariate", "sr", "biomass"),
                        nsim = 1, seed = NULL, ...) {
  name <- match.arg(name)
  if (!is.null(seed)) set.seed(seed)
  ages6 <- 1:6
  years30 <- 1991:2020
  # the "simple" set-up, shared by several scenarios
  simple <- list(ages = ages6, years = years30, fbar = c(2, 4),
                 sel = list(a50 = 2, slope = 0.5),
                 rec = list(model = "random", mean = 1e6, sd = 0.5),
                 surveys = list(simSurvey("survey", ages = 1:5, q = c(2, 3, 3, 2.5, 2) * 1e-3,
                                          sd = 0.2, time = 0.5)),
                 catch.sd = 0.1)
  simpleModels <- list(fmodel = ~ factor(age) + factor(year), qmodel = list(~ factor(age)),
                       vmodel = list(~ 1, ~ 1), n1model = ~ factor(age), srmodel = ~ factor(year))

  spec <- switch(name,
    simple = list(args = simple, models = simpleModels),
    smooth = list(
      args = list(ages = 1:10, years = 1981:2020, fbar = c(3, 6),
                  sel = list(a50 = 2.5, slope = 0.8, shift = 2),
                  rec = list(model = "random", mean = 1e6, sd = 0.5),
                  surveys = list(simSurvey("summer", ages = 1:8, q = function(a) 2e-3 * exp(-0.1 * a), sd = 0.25, time = 0.6),
                                 simSurvey("winter", ages = 2:10, years = 1991:2020, q = 1e-3, sd = 0.3, time = 0.1)),
                  catch.sd = 0.15),
      models = list(fmodel = ~ te(age, year, k = c(5, 15)), qmodel = list(~ s(age, k = 4), ~ s(age, k = 4)),
                    vmodel = list(~ 1, ~ 1, ~ 1), n1model = ~ s(age, k = 4), srmodel = ~ factor(year))),
    covariate = {
      temp <- as.numeric(stats::arima.sim(list(ar = 0.6), n = length(years30), sd = 0.5))
      effort <- sin(seq(0, 1.5 * pi, length = length(years30))) + stats::rnorm(length(years30), 0, 0.3)
      a <- simple
      # F changes over the years only through effort, so the effect is
      # identifiable (a year-only covariate is confounded with factor(year))
      a$Fbar <- rep(0.35, length(years30))
      a$covar <- list(temp = temp, effort = effort)
      a$Fcovar <- c(effort = 0.3)
      a$surveys[[1]]$covar <- c(temp = 0.4)
      m <- simpleModels
      m$fmodel <- ~ factor(age) + effort
      m$qmodel <- list(~ factor(age) + temp)
      list(args = a, models = m)
    },
    sr = list(
      args = list(ages = 1:8, years = 1981:2020, fbar = c(2, 5),
                  Fbar = 0.15 + 0.75 * exp(-((seq(0, 1, length = 40) - 0.5) / 0.2)^2),
                  sel = list(a50 = 2.5, slope = 0.6),
                  rec = list(model = "bevholt", a = 2e6, b = 2e5, sd = 0.3),
                  surveys = list(simSurvey("survey", ages = 1:7, q = 2e-3, sd = 0.2, time = 0.5)),
                  catch.sd = 0.1),
      models = list(fmodel = ~ te(age, year, k = c(4, 12)), qmodel = list(~ s(age, k = 4)),
                    vmodel = list(~ 1, ~ 1), n1model = ~ factor(age),
                    srmodel = ~ bevholt(CV = 0.3))),
    biomass = {
      a <- simple
      a$surveys <- c(a$surveys, list(simSurvey("biomass", ages = 1:6, q = 1e-3, sd = 0.2,
                                               time = 0.5, biomass = TRUE)))
      m <- simpleModels
      m$qmodel <- list(~ factor(age), ~ 1)
      m$vmodel <- list(~ 1, ~ 1, ~ 1)
      list(args = a, models = m)
    })

  args <- spec$args
  extra <- list(...)
  args[names(extra)] <- extra
  out <- do.call(simStock, c(args, list(nsim = nsim)))
  c(out, list(models = spec$models, scenario = name))
}
