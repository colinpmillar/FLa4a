# Assemble the data and design matrices for a single iteration.
#
# All age x year quantities are stored as vectors in column-major (age
# fastest) order so that they can be reshaped to nage x nyear matrices,
# the same layout as an FLQuant.
#
# `designs` and `centering` come from an earlier fit: the design matrices are
# then evaluated with the fitted bases (so the fitted parameters still apply,
# e.g. at new covariate values) and the fitted centering is reused.
#
# `penalise` names the submodels ("f", "q", "v", "n1", "r", "sra", "srb")
# whose smoothers are penalised (only used when building new designs).
a4aData <- function(stock, indices, fmodel, qmodel, vmodel, n1model, srmodel,
                    covar = NULL, center = TRUE, designs = NULL, centering = NULL,
                    penalise = character(0)) {

  ages  <- as.numeric(dimnames(stock.n(stock))$age)
  years <- as.numeric(dimnames(stock.n(stock))$year)
  nA <- length(ages)
  nY <- length(years)
  fleets <- c("catch", names(indices))
  isBiomass <- vapply(indices, is, logical(1), "FLIndexBiomass")

  #------------------------------------------------------------------
  # observations
  #------------------------------------------------------------------
  catchVar <- if (is(catch.n(stock), "FLQuantDistr")) var(catch.n(stock)) else NULL
  obsList <- c(list(obsFrame(catch.n(stock), catchVar, ages, years)),
               lapply(indices, function(x) obsFrame(index(x), index.var(x), ages, years)))

  if (is.null(centering)) {
    centering <- vapply(obsList, function(x) mean(log(x$obs)), numeric(1))
    if (!isTRUE(center)) centering[] <- 0
  }
  centering <- stats::setNames(as.numeric(centering), fleets)

  obs <- do.call(rbind, lapply(seq_along(obsList), function(i) {
    x <- obsList[[i]]
    x$fleet <- i
    x$obs <- log(x$obs) - centering[i]
    x
  }))
  # weights are inverse relative variances, scaled to have mean 1
  obs$w <- 1 / (obs$w / mean(obs$w))

  obs$biomass <- is.na(obs$age)
  obs$iy <- match(obs$year, years)
  # biomass indices use the minimum age cell for their variance model
  obs$ia <- ifelse(obs$biomass, 1L, match(obs$age, ages))

  #------------------------------------------------------------------
  # design matrices
  #------------------------------------------------------------------
  grid <- addCovariates(expand.grid(age = ages, year = years), covar)

  # age range covered by each index; smoothers are not extrapolated beyond it
  idxAges <- lapply(indices, function(x) {
    rng <- range(x)[c("min", "max")]
    if (any(is.na(rng))) range(ages) else rng
  })
  fleetGrid <- function(i) {
    if (i == 1 || isBiomass[i - 1]) return(grid)
    g <- grid
    g$age <- pmin(pmax(g$age, idxAges[[i - 1]][1]), idxAges[[i - 1]][2])
    g
  }

  sr <- parseSRmodel(srmodel)
  recGrid <- grid[grid$age == ages[1], , drop = FALSE]

  # build each design, or evaluate a stored one at the (possibly new) data
  des <- function(formula, df, stored, key) {
    if (is.null(stored)) a4aDesign(formula, df, penalise = key %in% penalise)
    else list(X = predictDesign(stored, df), design = stored)
  }
  n1Grid <- grid[grid$year == years[1] & grid$age > ages[1], , drop = FALSE]
  D <- list(
    f  = des(fmodel, grid, designs$f, "f"),
    q  = lapply(seq_along(indices), function(i) des(qmodel[[i]], fleetGrid(i + 1), designs$q[[i]], "q")),
    v  = lapply(seq_along(fleets), function(i) des(vmodel[[i]], fleetGrid(i), designs$v[[i]], "v")),
    n1 = if (nA > 1) des(n1model, n1Grid, designs$n1, "n1"),
    r  = des(sr$rmodel, recGrid, designs$r, "r"),
    sra = if (!is.null(sr$sr)) des(sr$sr$a, recGrid, designs$sra, "sra"),
    srb = if (!is.null(sr$sr$b)) des(sr$sr$b, recGrid, designs$srb, "srb")
  )
  designs <- list(f = D$f$design, q = lapply(D$q, `[[`, "design"), v = lapply(D$v, `[[`, "design"),
                  n1 = D$n1$design, r = D$r$design, sra = D$sra$design, srb = D$srb$design)
  names(D$q) <- fleets[-1]
  names(D$v) <- fleets

  # one design matrix per submodel (q and v are block diagonal over fleets),
  # with parameter-name prefixes and penalised blocks
  none <- function(nrow) list(X = matrix(0, nrow, 0), design = list(blocks = list()))
  sub <- list(
    f = combineDesigns(list(D$f), "fMod:"),
    q = combineDesigns(D$q, paste0("qMod:", fleets[-1], ":")),
    v = combineDesigns(D$v, paste0("vMod:", fleets, ":")),
    n1 = combineDesigns(list(if (is.null(D$n1)) none(0) else D$n1), "n1Mod:"),
    r = combineDesigns(list(D$r), "rMod:"),
    sra = combineDesigns(list(if (is.null(D$sra)) none(nY) else D$sra), "sraMod:"),
    srb = combineDesigns(list(if (is.null(D$srb)) none(nY) else D$srb), "srbMod:")
  )
  if (!is.null(sr$sr) && ncol(sub$sra$X) + ncol(sub$srb$X) > nY)
    stop("stock-recruitment model is over parameterised")

  #------------------------------------------------------------------
  # split columns into unpenalised parameters (fpar, qpar, ...) and
  # penalised random effects (re), with log smoothing parameters
  #------------------------------------------------------------------
  parNames <- c(f = "fpar", q = "qpar", v = "vpar", n1 = "n1par", r = "rpar", sra = "rapar", srb = "rbpar")
  par <- list()
  mats <- list()
  blocks <- list()
  colmap <- NULL
  nre <- 0
  nlam <- 0
  for (key in names(parNames)) {
    X <- sub[[key]]$X
    rand <- unlist(lapply(sub[[key]]$blocks, `[[`, "cols"))
    fix <- setdiff(seq_len(ncol(X)), rand)
    reIdx <- nre + seq_along(rand)
    par[[parNames[[key]]]] <- numeric(length(fix))
    mats[[paste0("X", key)]] <- X[, fix, drop = FALSE]
    mats[[paste0("Z", key)]] <- sparseIfUseful(X[, rand, drop = FALSE])
    mats[[paste0("i", key)]] <- reIdx
    colmap <- rbind(colmap, data.frame(
      name = colnames(X),
      par = ifelse(seq_len(ncol(X)) %in% rand, "re", parNames[[key]]),
      idx = ifelse(seq_len(ncol(X)) %in% rand, reIdx[match(seq_len(ncol(X)), rand)],
                   match(seq_len(ncol(X)), fix)),
      stringsAsFactors = FALSE))
    for (b in sub[[key]]$blocks) {
      b$idx <- reIdx[match(b$cols, rand)]
      b$lam <- nlam + seq_along(b$S)
      nlam <- nlam + length(b$S)
      blocks[[length(blocks) + 1]] <- b
    }
    nre <- nre + length(rand)
  }
  # log sd of recruitment around the SR curve, when estimated (starting at CV = 0.5)
  estimateCV <- isTRUE(sr$sr$estimateCV)
  par$logsdR <- if (estimateCV) log(sqrt(log(1 + 0.5^2))) else numeric(0)
  par$re <- numeric(nre)
  par$loglambda <- numeric(nlam)

  # position of each coefficient (in design column order) in unlist(par)
  offsets <- cumsum(c(0, lengths(par)))[-(length(par) + 1)]
  names(offsets) <- names(par)
  colmap$pos <- offsets[colmap$par] + colmap$idx

  #------------------------------------------------------------------
  # data list for the RTMB model
  #------------------------------------------------------------------
  bmask <- sapply(idxAges, function(r) as.numeric(ages >= r[1] & ages <= r[2]))
  dat <- c(list(
    nA = nA, nY = nY, nS = length(indices),
    obs = obs$obs, w = obs$w, fleet = obs$fleet, iy = obs$iy, ia = obs$ia,
    biomass = obs$biomass,
    M = c(m(stock)), fspwn = c(harvest.spwn(stock)), mspwn = c(m.spwn(stock)),
    matWt = c(mat(stock) * stock.wt(stock)), stkWt = c(stock.wt(stock)),
    stime = vapply(indices, surveyTime, numeric(1)),
    bmask = matrix(bmask, nA, length(indices)),
    plusgroup = !is.na(range(stock)["plusgroup"]),
    srID = if (is.null(sr$sr)) 0L else sr$sr$ID,
    srCV = if (is.null(sr$sr) || estimateCV) 0 else sr$sr$srrCV,
    randomRec = estimateCV,
    spr0 = if (is.null(sr$sr)) 1 else sr$sr$SPR0,
    srAge = ages[1],
    blocks = blocks), mats)
  if (any(is.na(dat$M))) stop("m(stock) has missing values")

  list(dat = dat, par = par, pnames = colmap$name, colmap = colmap,
       penalties = unlist(lapply(blocks, function(b) paste0(b$label, if (length(b$lam) > 1) paste0(":", seq_along(b$lam))))),
       centering = centering, designs = designs,
       obs = obs[c("fleet", "year", "age")],
       ages = ages, years = years, fleets = fleets, nobs = nrow(obs))
}

# Combine submodel designs (one per fleet for q and v) into one block
# diagonal design matrix with prefixed column names and shifted blocks.
combineDesigns <- function(ds, prefixes) {
  Xs <- lapply(ds, `[[`, "X")
  offset <- cumsum(c(0, vapply(Xs, ncol, numeric(1))))
  X <- blockDiag(Xs)
  colnames(X) <- unlist(lapply(seq_along(Xs), function(i) {
    if (ncol(Xs[[i]])) paste0(prefixes[i], colnames(Xs[[i]])) else character(0)
  }))
  blocks <- unlist(lapply(seq_along(ds), function(i) {
    lapply(ds[[i]]$design$blocks, function(b) {
      b$cols <- b$cols + offset[i]
      b$label <- paste0(prefixes[i], b$label)
      b
    })
  }), recursive = FALSE)
  list(X = X, blocks = if (is.null(blocks)) list() else blocks)
}

# Store a matrix as sparse if that saves space.
sparseIfUseful <- function(X) {
  if (ncol(X) && mean(X != 0) < 0.3) methods::as(Matrix::Matrix(X, sparse = TRUE), "CsparseMatrix") else X
}

# Observations of one fleet as a data.frame (age is NA for biomass indices).
obsFrame <- function(x, v, ages, years) {
  df <- as.data.frame(x)[c("age", "year", "data")]
  df$age <- suppressWarnings(as.numeric(as.character(df$age)))
  df$year <- as.numeric(as.character(df$year))
  df$w <- if (is.null(v)) NA else c(v)
  df <- df[!is.na(df$data), ]
  names(df)[3] <- "obs"

  outside <- !(df$year %in% years) | !(is.na(df$age) | df$age %in% ages)
  if (any(outside)) {
    warning("dropping ", sum(outside), " observations outside the stock's age and year range", call. = FALSE)
    df <- df[!outside, ]
  }
  if (any(df$obs <= 0)) stop("only positive catches and indices are allowed")

  if (all(is.na(df$w))) {
    df$w <- 1
  } else if (any(is.na(df$w) | df$w <= 0)) {
    warning("NA or non-positive variances found; all set to 1", call. = FALSE)
    df$w <- 1
  }
  df
}

# Mid point of the survey period as a fraction of the year.
surveyTime <- function(index) {
  t <- mean(range(index)[c("startf", "endf")])
  if (is.na(t)) stop("startf and endf must be set for every index")
  t
}

# Add covariates (a named list of FLQuants) as columns of the design grid.
addCovariates <- function(grid, covar) {
  for (nm in names(covar)) {
    df <- as.data.frame(covar[[nm]])
    df <- data.frame(age = df[[1]], year = as.numeric(as.character(df$year)), value = df$data)
    by <- "year"
    if (length(unique(df$age)) > 1) {
      df$age <- as.numeric(as.character(df$age))
      by <- c("age", "year")
    } else {
      df$age <- NULL
    }
    names(df)[names(df) == "value"] <- nm
    grid <- merge(grid, df, by = by, all.x = TRUE, sort = FALSE)
    grid <- grid[order(grid$year, grid$age), ]
  }
  rownames(grid) <- NULL
  grid
}

blockDiag <- function(xs) {
  if (!length(xs)) return(matrix(0, 0, 0))
  as.matrix(Matrix::bdiag(xs))
}
