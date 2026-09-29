# The a4a statistical catch-at-age model as an RTMB objective function.
#
# Linear predictors (log scale) come from the submodel design matrices:
#   log F    = Xf  %*% fpar  + Zf  %*% re[if]    (age x year)
#   log q    = Xq  %*% qpar  + Zq  %*% re[iq]    (age x year, one block per index)
#   log sd   = Xv  %*% vpar  + Zv  %*% re[iv]    (age x year, one block per fleet)
#   log N1   = Xn1 %*% n1par + Zn1 %*% re[in1]   (first year, ages 2+)
#   log R    = Xr  %*% rpar  + Zr  %*% re[ir]    (first age, all years)
# X holds unpenalised columns and Z the columns of penalised smoothers,
# whose coefficients `re` are random effects with a Gaussian prior of
# precision sum_j lambda_j S_j (see penaltyNll()).
# Observations are lognormal. An optional stock-recruitment relationship
# adds a lognormal penalty on recruitment around the curve.
#
# The likelihood depends on the parameters only through the linear
# predictors, so it is computed in two steps, linearPredictors() and
# a4aNllEta(); hessianFun() uses this to get the Hessian cheaply.
a4aNll <- function(par, dat) {
  "[<-" <- ADoverload("[<-")
  nData <- dat$nS + 1 + (dat$srID > 0)
  nllComp <- numeric(nData + (length(dat$blocks) > 0))
  nllComp[seq_len(nData)] <- a4aNllEta(linearPredictors(par, dat), dat, report = TRUE)
  if (length(dat$blocks)) nllComp[nData + 1] <- penaltyNll(par, dat$blocks)
  REPORT(nllComp)
  sum(nllComp)
}

# The submodels' linear predictors (log scale).
linearPredictors <- function(par, dat) {
  lp <- function(key, b) {
    X <- dat[[paste0("X", key)]]
    eta <- if (ncol(X)) X %*% b else numeric(nrow(X))
    i <- dat[[paste0("i", key)]]
    if (length(i)) eta <- eta + dat[[paste0("Z", key)]] %*% par$re[i]
    eta
  }
  list(logF = lp("f", par$fpar), logQ = lp("q", par$qpar), logV = lp("v", par$vpar),
       logN1 = lp("n1", par$n1par), logR = lp("r", par$rpar),
       sra = lp("sra", par$rapar), srb = lp("srb", par$rbpar), logsdR = par$logsdR)
}

# Negative log-likelihood components (one per fleet, then the SR model)
# given the linear predictors `eta`.
a4aNllEta <- function(eta, dat, report = FALSE) {
  "[<-" <- ADoverload("[<-")
  nA <- dat$nA
  nY <- dat$nY
  nC <- nA * nY

  pop <- population(eta, dat)
  logF <- pop$logF
  logN <- pop$logN
  F <- pop$F
  M <- pop$M
  Z <- pop$Z
  logQ <- eta$logQ
  logV <- eta$logV

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
  # likelihood components: one per fleet, then the SR model
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
    a <- eta$sra[yrs]
    b <- eta$srb[yrs]
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
    sdR <- if (dat$randomRec) exp(eta$logsdR) else sqrt(log(dat$srCV^2 + 1))
    nllSR <- -sum(dnorm(logN[1, yrs], predLogR, sdR, log = TRUE))
    nllComp[dat$nS + 2] <- nllSR
  }

  if (report) {
    REPORT(logF)
    REPORT(logN)
    REPORT(logQ)
    REPORT(pred)
    REPORT(sdObs)
  }
  nllComp
}

# Fishing and natural mortality and numbers at age (age x year matrices, log
# numbers on the model's centred scale) given the linear predictors.
population <- function(eta, dat) {
  "[<-" <- ADoverload("[<-")
  nA <- dat$nA
  nY <- dat$nY
  logF <- matrix(eta$logF, nA, nY)
  M <- matrix(dat$M, nA, nY)
  F <- exp(logF)
  Z <- F + M

  logN <- matrix(0, nA, nY)
  logN[1, ] <- eta$logR
  if (nA > 1) {
    logN[-1, 1] <- eta$logN1
    for (y in seq_len(nY)[-1]) {
      logN[-1, y] <- logN[-nA, y - 1] - Z[-nA, y - 1]
      if (dat$plusgroup)
        logN[nA, y] <- logspace_add(logN[nA, y], logN[nA, y - 1] - Z[nA, y - 1])
    }
  }
  list(logF = logF, F = F, M = M, Z = Z, logN = logN)
}

# A function returning the Hessian of the negative log-likelihood with
# respect to all parameters except the log smoothing parameters, for a
# parameter vector in unlist(data$par) order.
#
# With eta = A b the linear predictors, the Hessian is
#   A' H_eta A + blockdiag(Q_lambda)
# where H_eta, the Hessian of a4aNllEta() in the linear predictors, is
# sparse (an observation involves only the cells of its cohort) and is
# computed from a sparse Hessian tape recorded once, and Q_lambda is the
# prior precision of the penalised smoothers.
hessianFun <- function(data) {
  dat <- data$dat
  lens <- vapply(linearPredictors(data$par, dat), length, numeric(1))
  ends <- cumsum(lens)
  splitEta <- function(e) {
    out <- Map(function(n, end) e[end - n + seq_len(n)], lens, ends)
    names(out) <- names(lens)
    out
  }
  tape <- RTMB::MakeTape(function(e) sum(a4aNllEta(splitEta(e), dat)), numeric(sum(lens)))
  Heta <- tape$jacfun()$jacfun(sparse = TRUE)
  A <- etaMap(data)
  nb <- ncol(A)
  rePos <- rePositions(data)
  function(par) {
    b <- par[seq_len(nb)]
    H <- Matrix::crossprod(A, Heta(as.vector(A %*% b)) %*% A)
    H <- as.matrix(H)
    for (bl in dat$blocks) {
      i <- rePos[bl$idx]
      H[i, i] <- H[i, i] + penaltyMatrix(bl, par[nb + seq_along(data$par$loglambda)])
    }
    H
  }
}

# The sparse matrix A mapping the parameters (unlist(data$par) without the
# log smoothing parameters) to the linear predictors, eta = A b.
etaMap <- function(data) {
  dat <- data$dat
  keys <- c(f = "fpar", q = "qpar", v = "vpar", n1 = "n1par", r = "rpar", sra = "rapar", srb = "rbpar")
  lens <- lengths(data$par)
  colOff <- cumsum(c(0, lens))[seq_along(lens)]
  names(colOff) <- names(lens)
  nb <- sum(lens) - lens[["loglambda"]]
  rows <- 0
  trip <- list()
  add <- function(M, rowOff, cols) {
    if (!length(M) || !ncol(M)) return()
    M <- methods::as(Matrix::Matrix(M, sparse = TRUE), "TsparseMatrix")
    trip[[length(trip) + 1]] <<- data.frame(i = M@i + 1 + rowOff, j = cols[M@j + 1], x = M@x)
  }
  for (key in names(keys)) {
    X <- dat[[paste0("X", key)]]
    add(X, rows, colOff[[keys[[key]]]] + seq_len(ncol(X)))
    add(dat[[paste0("Z", key)]], rows, colOff[["re"]] + dat[[paste0("i", key)]])
    rows <- rows + nrow(X)
  }
  # the log sd of recruitment enters the likelihood directly
  if (length(data$par$logsdR)) {
    trip[[length(trip) + 1]] <- data.frame(i = rows + 1, j = colOff[["logsdR"]] + 1, x = 1)
    rows <- rows + 1
  }
  t <- do.call(rbind, trip)
  Matrix::sparseMatrix(i = t$i, j = t$j, x = t$x, dims = c(rows, nb))
}

# Negative log prior of the penalised smoothers. Each block's coefficients u
# have an (improper) Gaussian prior with precision Q = sum_j lambda_j S_j,
#   log p(u) = 0.5 log|Q|+ - 0.5 u' Q u - r/2 log(2 pi),   r = rank(Q),
# with a flat prior on the null space of Q (the unpenalised directions).
# The pseudo-determinant is |Q + N N'| for N an orthonormal basis of the
# null space, so dgmrf() on the sparse Q + N N' gives the density once the
# N N' term of its quadratic form is added back.
penaltyNll <- function(par, blocks) {
  nll <- 0
  for (b in blocks) {
    u <- par$re[b$idx]
    Q <- exp(par$loglambda[b$lam[1]]) * b$S[[1]]
    for (j in seq_along(b$S)[-1]) Q <- Q + exp(par$loglambda[b$lam[j]]) * b$S[[j]]
    if (ncol(b$N)) {
      Nu <- t(b$N) %*% u
      nll <- nll - dgmrf(u, 0, Q + b$NN, log = TRUE) - 0.5 * sum(Nu * Nu) -
        0.5 * ncol(b$N) * log(2 * pi)
    } else {
      nll <- nll - dgmrf(u, 0, Q, log = TRUE)
    }
  }
  nll
}

# Fit the model to one iteration of data. Returns the coefficients (in design
# column order), their covariance matrix (fit = "assessment"), the log
# smoothing parameters and effective degrees of freedom of penalised
# smoothers, and the reported quantities.
#
# Penalised smoother coefficients have a Gaussian prior (penaltyNll()); their
# smoothing parameters maximise the Laplace approximation of the marginal
# likelihood, in which the smoother coefficients are integrated out. With
# sp.method = "efs" this uses Fellner-Schall updates (fitSmoothing()); with
# "laplace" the result is refined with RTMB's Laplace approximation, the
# smoother coefficients being random effects (fitLaplace()).
#
# With method = "REML", the variance parameters (vpar) and smoothing
# parameters then maximise the restricted likelihood, in which all other
# coefficients are integrated out (fitREML()).
fitA4a <- function(data, fit = "assessment", verbose = FALSE, control = list(),
                   sp.method = c("efs", "laplace"), method = c("ML", "REML")) {
  sp.method <- match.arg(sp.method)
  method <- match.arg(method)
  dat <- data$dat
  ctrl <- utils::modifyList(list(eval.max = 1e4, iter.max = 1e4), control)
  penalised <- length(data$par$re) > 0
  randomRec <- isTRUE(dat$randomRec)

  obj <- MakeADFun(function(p) a4aNll(p, dat), data$par, silent = !verbose)
  np <- length(obj$par)
  lamPos <- np - length(data$par$loglambda) + seq_along(data$par$loglambda)
  # hyper parameters (log smoothing parameters, log sd of recruitment) are
  # held fixed in penalised fits and have no place in the coefficients' Hessian
  sdRPos <- which(names(obj$par) == "logsdR")
  bPos <- setdiff(seq_len(np), c(lamPos, sdRPos))
  full <- obj$par
  maxgrad <- NULL
  marginal <- NA_real_

  # the Hessian of the coefficients (bPos)
  hess <- if (penalised || randomRec) hessianFun(data)
  coefHessian <- function(p) {
    if (is.null(hess)) obj$he(p)[bPos, bPos, drop = FALSE] else hess(p)[bPos, bPos, drop = FALSE]
  }

  if (!penalised) {
    fn <- function(x) { full[bPos] <- x; obj$fn(full) }
    gr <- function(x) { full[bPos] <- x; obj$gr(full)[bPos] }
    opt <- stats::nlminb(full[bPos], fn, gr, control = ctrl)
    full[bPos] <- opt$par
    full <- newtonPolish(obj, full, bPos)
    convergence <- opt$convergence
  } else {
    sp <- fitSmoothing(obj, coefHessian, data, full, bPos, lamPos, ctrl, verbose)
    full <- sp$par
    convergence <- sp$convergence
  }

  # Laplace approximation with smoother coefficients and/or recruitments as
  # random effects (ML), or all coefficients but the variances (REML)
  if (method == "REML") {
    rem <- fitREML(data, full, ctrl, verbose)
    full <- rem$par
    convergence <- max(convergence, rem$convergence)
    maxgrad <- rem$maxgrad
    marginal <- rem$objective
  } else if (randomRec || (penalised && sp.method == "laplace")) {
    random <- c(if (penalised) "re", if (randomRec) "rpar")
    lap <- fitLaplace(data, full, ctrl, verbose, random)
    full <- lap$par
    convergence <- lap$convergence
    maxgrad <- lap$maxgrad
    marginal <- lap$objective
  }

  pos <- data$colmap$pos
  coefs <- stats::setNames(full[pos], data$pnames)
  report <- obj$report(full)
  H <- if (fit == "assessment" || penalised || randomRec) coefHessian(full)

  vcov <- NULL
  if (fit == "assessment") {
    V <- if (method == "ML") {
      tryCatch(chol2inv(chol(H)), error = function(e) NULL)
    } else {
      # REML: the coefficients' covariance is conditional on the variance
      # parameters, which are not at a joint-likelihood optimum (so the joint
      # Hessian need not be positive definite there); the variance
      # parameters' covariance comes from the restricted likelihood
      v <- which(names(obj$par)[bPos] == "vpar")
      Vb <- tryCatch(chol2inv(chol(H[-v, -v, drop = FALSE])), error = function(e) NULL)
      if (is.null(Vb) || is.null(rem$vcovVpar)) NULL else {
        out <- matrix(0, length(bPos), length(bPos))
        out[-v, -v] <- Vb
        out[v, v] <- rem$vcovVpar
        out
      }
    }
    if (is.null(V)) {
      warning("Hessian is not positive definite", call. = FALSE)
      vcov <- matrix(NA_real_, length(pos), length(pos))
      convergence <- 1L
    } else {
      i <- match(pos, bPos)
      vcov <- V[i, i, drop = FALSE]
    }
    dimnames(vcov) <- list(data$pnames, data$pnames)
  }

  # the data likelihood, excluding the smoother priors and, when recruitment
  # is a random effect, its distribution around the SR curve
  comps <- report$nllComp
  nFleet <- dat$nS + 1
  nlogl <- sum(comps[seq_len(nFleet)]) + if (dat$srID > 0 && !randomRec) comps[[nFleet + 1]] else 0

  edf <- numeric(0)
  if (penalised) {
    # Hessian of the random effects, conditional on the other parameters
    re <- match(rePositions(data), bPos)
    Hr <- H[re, re, drop = FALSE]
    Vr <- tryCatch(solve(Hr), error = function(e) NULL)
    if (is.null(Vr)) {
      warning("the Hessian of the smoother coefficients is singular", call. = FALSE)
      convergence <- 1L
    }
    # effective degrees of freedom of each smoother: k - tr(Hr^-1 S_lambda)
    edf <- vapply(dat$blocks, function(b) {
      if (is.null(Vr)) return(NA_real_)
      length(b$idx) - sum(Vr[b$idx, b$idx] * penaltyMatrix(b, full[lamPos]))
    }, numeric(1))
    names(edf) <- vapply(dat$blocks, `[[`, "", "label")
    # Laplace approximation of the marginal likelihood (when not already
    # computed by a Laplace or REML fit)
    if (is.na(marginal)) {
      marginal <- obj$fn(full) + 0.5 * as.numeric(determinant(Hr)$modulus) -
        0.5 * length(re) * log(2 * pi)
    }
  }

  # recruitment as a random effect: its CV and effective degrees of freedom,
  # n - tr(H_rr^-1 P) with P = X' X / sdR^2 the precision of its distribution
  # around the SR curve (ignoring the dependence of the curve on SSB)
  cvR <- NA_real_
  edfR <- 0
  if (randomRec) {
    sdR <- exp(full[sdRPos])
    cvR <- sqrt(exp(sdR^2) - 1)
    r <- which(names(obj$par)[bPos] == "rpar")
    lag <- if (dat$srID == 4) 1 else dat$srAge
    X <- dat$Xr[seq(1 + lag, dat$nY), , drop = FALSE]
    Vrr <- tryCatch(solve(H[r, r, drop = FALSE]), error = function(e) NULL)
    edfR <- if (is.null(Vrr)) NA_real_ else length(r) - sum(Vrr * crossprod(X)) / sdR^2
  }

  list(par = coefs, vcov = vcov, report = report, nlogl = nlogl, objective = marginal,
       loglambda = stats::setNames(full[lamPos], data$penalties), edf = edf,
       cvR = cvR, edfR = edfR,
       # unpenalised coefficients, plus the smoothers' and recruitment's
       # effective degrees of freedom
       nopar = length(bPos) - length(data$par$re) + sum(edf) -
         (if (randomRec) length(data$par$rpar) - edfR else 0),
       maxgrad = if (is.null(maxgrad)) max(abs(obj$gr(full)[bPos])) else maxgrad,
       convergence = convergence)
}

# Positions of the random effects re[1], re[2], ... in unlist(par).
rePositions <- function(data) {
  cm <- data$colmap[data$colmap$par == "re", ]
  cm$pos[order(cm$idx)]
}

# A few Newton steps to polish an optimum.
newtonPolish <- function(obj, par, pos = seq_along(par)) {
  maxgrad <- function(p) max(abs(obj$gr(p)[pos]))
  for (i in 1:3) {
    step <- tryCatch(solve(obj$he(par)[pos, pos, drop = FALSE], drop(obj$gr(par))[pos]),
                     error = function(e) NULL)
    if (is.null(step)) break
    new <- par
    new[pos] <- new[pos] - step
    if (!is.finite(obj$fn(new)) || maxgrad(new) >= maxgrad(par)) break
    par <- new
  }
  par
}

# Precision matrix sum_j lambda_j S_j of a penalised block (dense), given
# all log smoothing parameters.
penaltyMatrix <- function(b, loglambda) {
  Reduce(`+`, Map(function(S, l) exp(loglambda[l]) * as.matrix(S), b$S, b$lam))
}

# Estimate smoothing parameters with the extended Fellner-Schall update
# (Wood and Fasiolo, 2017, Biometrics 73:1071-1081). Given the smoothing
# parameters, the penalised likelihood is maximised over all the other
# parameters; then each smoothing parameter is updated as
#   lambda_j <- lambda_j * (tr(S^- S_j) - tr(V S_j)) / (b' S_j b)
# with S = sum_j lambda_j S_j the block's prior precision, S^- its
# pseudo-inverse, V the inverse Hessian of the random effects (conditional on
# the other parameters) and b the block's coefficients. The fixed point
# maximises the Laplace approximation of the marginal likelihood, ignoring
# the dependence of the Hessian on the coefficients.
fitSmoothing <- function(obj, hess, data, par, bPos, lamPos, ctrl, verbose, maxit = 200, tol = 1e-3) {
  rePos <- rePositions(data)
  re <- match(rePos, bPos)
  fn <- function(x) { par[bPos] <- x; obj$fn(par) }
  gr <- function(x) { par[bPos] <- x; obj$gr(par)[bPos] }
  he <- function(x) { par[bPos] <- x; hess(par) }  # the coefficients' Hessian

  # penalised likelihood fit given the smoothing parameters: quasi-Newton
  # from a cold start, then Newton steps (with step halving) from the
  # previous solution; returns the solution with its Hessian
  fitGivenLambda <- function(x, cold = FALSE) {
    if (cold) x <- stats::nlminb(x, fn, gr, control = ctrl)$par
    H <- he(x)
    for (k in 1:50) {
      g <- gr(x)
      if (max(abs(g)) < 1e-6) break
      step <- tryCatch(solve(H, g), error = function(e) NULL)
      if (is.null(step)) {
        x <- stats::nlminb(x, fn, gr, control = ctrl)$par
        H <- he(x)
        break
      }
      f0 <- fn(x)
      t <- 1
      while (!isTRUE(fn(x - t * step) <= f0) && t > 1e-4) t <- t / 2
      if (!isTRUE(fn(x - t * step) <= f0)) {
        # no progress along the Newton direction: fall back to quasi-Newton
        x <- stats::nlminb(x, fn, gr, control = ctrl)$par
        H <- he(x)
        break
      }
      x <- x - t * step
      H <- he(x)
    }
    list(x = x, H = H, converged = max(abs(gr(x))) < 1e-3)
  }

  # the penalised fit at given smoothing parameters, with the Laplace
  # approximation of the marginal likelihood (NULL if the fit fails)
  evaluate <- function(p, cold = FALSE) {
    # fn, gr and he read the smoothing parameters from `par`
    par <<- p
    fitted <- tryCatch(fitGivenLambda(par[bPos], cold), error = function(e) NULL)
    if (is.null(fitted)) return(NULL)
    par[bPos] <- fitted$x
    Hr <- fitted$H[re, re, drop = FALSE]
    V <- tryCatch(solve(Hr), error = function(e) NULL)
    ld <- determinant(Hr)
    if (is.null(V) || ld$sign < 0) return(NULL)
    list(par = par, V = V, converged = fitted$converged,
         marginal = obj$fn(par) + 0.5 * as.numeric(ld$modulus))
  }

  # the Fellner-Schall step for the log smoothing parameters
  fsStep <- function(cur) {
    loglam <- cur$par[lamPos]
    step <- numeric(length(loglam))
    for (b in data$dat$blocks) {
      Sinv <- pseudoInverse(penaltyMatrix(b, loglam))
      u <- cur$par[rePos[b$idx]]
      for (j in seq_along(b$S)) {
        Sj <- as.matrix(b$S[[j]])
        num <- sum(Sinv * Sj) - sum(cur$V[b$idx, b$idx] * Sj)
        den <- drop(crossprod(u, Sj %*% u))
        # guard against non-positive updates and limit the step size
        s <- log(max(num, 1e-8 * sum(Sinv * Sj))) - log(max(den, 1e-300))
        step[b$lam[j]] <- max(min(s, 5), -5)
      }
    }
    # stay within bounds
    pmin(pmax(loglam + step, -20), 25) - loglam
  }

  cur <- evaluate(par, cold = TRUE)
  if (is.null(cur)) stop("the penalised fit failed at the initial smoothing parameters")
  converged <- FALSE
  for (it in seq_len(maxit)) {
    step <- fsStep(cur)
    if (verbose) {
      message("Fellner-Schall iteration ", it, ": marginal nll ", signif(cur$marginal, 8),
              ", max step in log lambda ", signif(max(abs(step)), 3))
    }
    if (max(abs(step)) < tol) {
      converged <- TRUE
      break
    }
    # the update does not always improve the marginal likelihood: halve the
    # step until it does
    new <- NULL
    for (scale in 2^-(0:6)) {
      trial <- cur$par
      trial[lamPos] <- trial[lamPos] + scale * step
      new <- evaluate(trial)
      if (!is.null(new) && new$marginal <= cur$marginal + 1e-8) break
      new <- NULL
    }
    if (is.null(new)) {
      # no improving step: at the optimum to the precision of the update
      converged <- TRUE
      break
    }
    improvement <- cur$marginal - new$marginal
    cur <- new
    # converged when the marginal likelihood no longer changes (smoothing
    # parameters drifting along a flat direction, typically towards no penalty)
    if (improvement < tol * 1e-2) {
      converged <- TRUE
      break
    }
  }
  if (!converged) warning("smoothing parameters did not converge", call. = FALSE)
  list(par = cur$par, convergence = if (converged && cur$converged) 0L else 1L)
}

# Pseudo-inverse of a symmetric positive semi-definite matrix.
pseudoInverse <- function(S) {
  e <- eigen(S, symmetric = TRUE)
  keep <- e$values > max(e$values) * 1e-10
  e$vectors[, keep, drop = FALSE] %*% (t(e$vectors[, keep, drop = FALSE]) / e$values[keep])
}

# REML: maximise the restricted likelihood over the variance parameters
# (vpar) and log smoothing parameters, integrating out all other
# coefficients with the Laplace approximation (flat priors on the
# unpenalised ones), starting from `par` (a vector in unlist(data$par)
# order, typically the ML fit).
#
# Maximum likelihood estimates the observation variances as if the other
# coefficients were known, so it underestimates them, the more so the more
# coefficients a fleet's observations have to support; REML accounts for
# the coefficients' uncertainty.
fitREML <- function(data, par, ctrl, verbose) {
  inner <- setdiff(names(data$par)[lengths(data$par) > 0], c("vpar", "loglambda", "logsdR"))
  obj <- MakeADFun(function(p) a4aNll(p, data$dat), relistPar(par, data$par), random = inner,
                   silent = !verbose)
  opt <- stats::nlminb(obj$par, obj$fn, obj$gr, control = ctrl)
  objective <- obj$fn(opt$par)
  full <- obj$env$last.par
  maxgrad <- max(abs(obj$gr(opt$par)))
  # covariance of the variance parameters from the curvature of the
  # restricted likelihood (marginal over any smoothing parameters)
  Hout <- stats::optimHess(opt$par, obj$fn, obj$gr)
  Vout <- tryCatch(solve(Hout), error = function(e) NULL)
  vparOut <- names(opt$par) == "vpar"
  list(par = full, objective = objective, convergence = laplaceConvergence(opt, maxgrad),
       maxgrad = maxgrad, vcovVpar = if (!is.null(Vout)) Vout[vparOut, vparOut, drop = FALSE])
}

# Convergence of nlminb on a Laplace-approximated objective. The objective
# carries a little numerical noise from the inner optimisation, which near a
# flat optimum makes nlminb report "false convergence"; that is accepted when
# the gradient is small.
laplaceConvergence <- function(opt, maxgrad, tol = 0.01) {
  if (opt$convergence == 0 || (grepl("false convergence", opt$message) && maxgrad < tol)) 0L else 1L
}

# Maximise the Laplace approximation of the marginal likelihood with RTMB,
# the smoother coefficients being random effects, starting from `par`
# (a vector in unlist(data$par) order).
fitLaplace <- function(data, par, ctrl, verbose, random = "re") {
  obj <- MakeADFun(function(p) a4aNll(p, data$dat), relistPar(par, data$par), random = random,
                   silent = !verbose)
  opt <- stats::nlminb(obj$par, obj$fn, obj$gr, control = ctrl)
  objective <- obj$fn(opt$par)
  maxgrad <- max(abs(obj$gr(opt$par)))
  list(par = obj$env$last.par, objective = objective,
       convergence = laplaceConvergence(opt, maxgrad), maxgrad = maxgrad)
}

# A vector in unlist(par) order back into the parameter list `par`.
relistPar <- function(x, par) {
  ends <- cumsum(lengths(par))
  Map(function(n, end) unname(x[end - n + seq_len(n)]), lengths(par), ends)
}
