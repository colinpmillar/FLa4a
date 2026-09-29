# The a4a statistical catch-at-age model as an RTMB objective function.
#
# Linear predictors (log scale) come from the submodel design matrices:
#   log F    = Xf  %*% fpar     (age x year)
#   log q    = Xq  %*% qpar     (age x year, one block per index)
#   log sd   = Xv  %*% vpar     (age x year, one block per fleet)
#   log N1   = Xn1 %*% n1par    (first year, ages 2+)
#   log R    = Xr  %*% rpar     (first age, all years)
# Observations are lognormal. An optional stock-recruitment relationship
# adds a lognormal penalty on recruitment around the curve.
a4aNll <- function(par, dat) {
  "[<-" <- ADoverload("[<-")
  nA <- dat$nA
  nY <- dat$nY
  nC <- nA * nY

  #------------------------------------------------------------------
  # submodels
  #------------------------------------------------------------------
  logF <- matrix(dat$Xf %*% par$fpar, nA, nY)
  logQ <- dat$Xq %*% par$qpar
  logV <- dat$Xv %*% par$vpar
  M <- matrix(dat$M, nA, nY)
  F <- exp(logF)
  Z <- F + M

  #------------------------------------------------------------------
  # population
  #------------------------------------------------------------------
  logN <- matrix(0, nA, nY)
  logN[1, ] <- dat$Xr %*% par$rpar
  if (nA > 1) {
    logN[-1, 1] <- dat$Xn1 %*% par$n1par
    for (y in seq_len(nY)[-1]) {
      logN[-1, y] <- logN[-nA, y - 1] - Z[-nA, y - 1]
      if (dat$plusgroup)
        logN[nA, y] <- logspace_add(logN[nA, y], logN[nA, y - 1] - Z[nA, y - 1])
    }
  }

  #------------------------------------------------------------------
  # predicted observations
  #------------------------------------------------------------------
  fleet <- dat$fleet
  cell <- (dat$iy - 1) * nA + dat$ia
  pred <- numeric(length(dat$obs))

  isC <- fleet == 1
  pred[isC] <- logF[cell[isC]] - log(Z[cell[isC]]) + log(1 - exp(-Z[cell[isC]])) + logN[cell[isC]]

  isS <- !isC & !dat$biomass
  s <- fleet[isS] - 1
  pred[isS] <- logQ[(s - 1) * nC + cell[isS]] - Z[cell[isS]] * dat$stime[s] + logN[cell[isS]]

  for (i in which(dat$biomass)) {
    s <- fleet[i] - 1
    y <- dat$iy[i]
    ages <- (y - 1) * nA + seq_len(nA)
    B <- exp(logQ[(s - 1) * nC + ages] + logN[, y] - Z[, y] * dat$stime[s]) * dat$stkWt[ages]
    pred[i] <- log(sum(B * dat$bmask[, s]))
  }

  sdObs <- exp(logV[(fleet - 1) * nC + cell])
  nllObs <- -dat$w * dnorm(dat$obs, pred, sdObs, log = TRUE)
  # likelihood components: one per fleet, plus one for the SR model
  nllComp <- numeric(dat$nS + 1 + (dat$srID > 0))
  for (f in seq_len(dat$nS + 1)) nllComp[f] <- sum(nllObs[fleet == f])

  #------------------------------------------------------------------
  # stock-recruitment relationship
  #------------------------------------------------------------------
  if (dat$srID > 0) {
    ssb <- colSums(exp(logN - F * matrix(dat$fspwn, nA, nY) - M * matrix(dat$mspwn, nA, nY)) *
                     matrix(dat$matWt, nA, nY))
    # recruits in year y come from the ssb in year y - age of recruitment
    lag <- if (dat$srID == 4) 1 else dat$srAge
    yrs <- seq(1 + lag, nY)
    S <- if (dat$srID != 4) ssb[yrs - dat$srAge]
    a <- (dat$Xsra %*% par$rapar)[yrs]
    b <- if (length(par$rbpar)) (dat$Xsrb %*% par$rbpar)[yrs] else 0
    predLogR <- switch(dat$srID,
      a + log(S) - log(exp(b) + S),                                           # bevholt
      a + log(S) - exp(b) * S,                                                # ricker
      a + log(S + sqrt(exp(2 * b) + 0.0025) - sqrt((S - exp(b))^2 + 0.0025)), # hockey
      a,                                                                      # geomean
      {                                                                       # bevholtSV
        h <- 0.2 + 0.8 / (1 + exp(-a))
        v <- exp(b)
        log(6 * h * v * S) - log(dat$spr0 * ((h + 1) * v + (5 * h - 1) * S))
      })
    nllSR <- -sum(dnorm(logN[1, yrs], predLogR, sqrt(log(dat$srCV^2 + 1)), log = TRUE))
    nllComp[dat$nS + 2] <- nllSR
  }

  REPORT(logF)
  REPORT(logN)
  REPORT(logQ)
  REPORT(pred)
  REPORT(sdObs)
  REPORT(nllComp)
  sum(nllComp)
}

# Fit the model to one iteration of data. Returns estimates, the covariance
# matrix of the parameters (fit = "assessment") and the reported quantities.
fitA4a <- function(data, fit = "assessment", verbose = FALSE, control = list()) {
  dat <- data$dat
  obj <- MakeADFun(function(p) a4aNll(p, dat), data$par, silent = !verbose)

  opt <- stats::nlminb(obj$par, obj$fn, obj$gr,
                       control = utils::modifyList(list(eval.max = 1e4, iter.max = 1e4), control))
  par <- opt$par

  # a few Newton steps to polish the optimum
  maxgrad <- function(p) max(abs(obj$gr(p)))
  for (i in 1:3) {
    step <- tryCatch(solve(obj$he(par), drop(obj$gr(par))), error = function(e) NULL)
    if (is.null(step) || !is.finite(obj$fn(par - step)) || maxgrad(par - step) >= maxgrad(par)) break
    par <- par - step
  }
  names(par) <- data$pnames

  convergence <- opt$convergence
  vcov <- NULL
  if (fit == "assessment") {
    H <- obj$he(par)
    vcov <- tryCatch(chol2inv(chol(H)), error = function(e) NULL)
    if (is.null(vcov)) {
      warning("Hessian is not positive definite", call. = FALSE)
      vcov <- matrix(NA_real_, length(par), length(par))
      convergence <- 1L
    }
    dimnames(vcov) <- list(data$pnames, data$pnames)
  }

  list(par = par, vcov = vcov, report = obj$report(par),
       nlogl = obj$fn(par), maxgrad = maxgrad(par),
       convergence = convergence)
}
