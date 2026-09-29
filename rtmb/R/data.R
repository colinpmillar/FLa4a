# Assemble the data and design matrices for a single iteration.
#
# All age x year quantities are stored as vectors in column-major (age
# fastest) order so that they can be reshaped to nage x nyear matrices,
# the same layout as an FLQuant.
a4aData <- function(stock, indices, fmodel, qmodel, vmodel, n1model, srmodel,
                    covar = NULL, center = TRUE) {

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

  centering <- vapply(obsList, function(x) mean(log(x$obs)), numeric(1))
  if (!isTRUE(center)) centering[] <- 0
  names(centering) <- fleets

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

  X <- list(
    f  = getX(fmodel, grid),
    q  = lapply(seq_along(indices), function(i) getX(qmodel[[i]], fleetGrid(i + 1))),
    v  = lapply(seq_along(fleets), function(i) getX(vmodel[[i]], fleetGrid(i))),
    n1 = if (nA > 1) getX(n1model, grid[grid$year == years[1] & grid$age > ages[1], , drop = FALSE])
         else matrix(0, 0, 0),
    r  = getX(sr$rmodel, recGrid),
    sra = if (!is.null(sr$sr)) getX(sr$sr$a, recGrid) else matrix(0, nY, 0),
    srb = if (!is.null(sr$sr$b)) getX(sr$sr$b, recGrid) else matrix(0, nY, 0)
  )
  names(X$q) <- fleets[-1]
  names(X$v) <- fleets

  if (!is.null(sr$sr) && ncol(X$sra) + ncol(X$srb) > nY)
    stop("stock-recruitment model is over parameterised")

  #------------------------------------------------------------------
  # data list for the RTMB model
  #------------------------------------------------------------------
  bmask <- sapply(idxAges, function(r) as.numeric(ages >= r[1] & ages <= r[2]))
  dat <- list(
    nA = nA, nY = nY, nS = length(indices),
    obs = obs$obs, w = obs$w, fleet = obs$fleet, iy = obs$iy, ia = obs$ia,
    biomass = obs$biomass,
    M = c(m(stock)), fspwn = c(harvest.spwn(stock)), mspwn = c(m.spwn(stock)),
    matWt = c(mat(stock) * stock.wt(stock)), stkWt = c(stock.wt(stock)),
    stime = vapply(indices, surveyTime, numeric(1)),
    bmask = matrix(bmask, nA, length(indices)),
    plusgroup = !is.na(range(stock)["plusgroup"]),
    Xf = X$f, Xq = blockDiag(X$q), Xv = blockDiag(X$v), Xn1 = X$n1, Xr = X$r,
    Xsra = X$sra, Xsrb = X$srb,
    srID = if (is.null(sr$sr)) 0L else sr$sr$ID,
    srCV = if (is.null(sr$sr)) 0 else sr$sr$srrCV,
    spr0 = if (is.null(sr$sr)) 1 else sr$sr$SPR0,
    srAge = ages[1]
  )
  if (any(is.na(dat$M))) stop("m(stock) has missing values")

  par <- list(
    fpar  = numeric(ncol(X$f)),
    qpar  = numeric(ncol(dat$Xq)),
    vpar  = numeric(ncol(dat$Xv)),
    n1par = numeric(ncol(X$n1)),
    rpar  = numeric(ncol(X$r)),
    rapar = numeric(ncol(X$sra)),
    rbpar = numeric(ncol(X$srb))
  )

  pn <- function(prefix, X) if (ncol(X)) paste0(prefix, colnames(X)) else character(0)
  pnames <- c(
    pn("fMod:", X$f),
    unlist(lapply(fleets[-1], function(f) pn(paste0("qMod:", f, ":"), X$q[[f]]))),
    unlist(lapply(fleets, function(f) pn(paste0("vMod:", f, ":"), X$v[[f]]))),
    pn("n1Mod:", X$n1),
    pn("rMod:", X$r),
    pn("sraMod:", X$sra),
    pn("srbMod:", X$srb)
  )

  list(dat = dat, par = par, pnames = pnames, centering = centering,
       ages = ages, years = years, fleets = fleets, nobs = nrow(obs))
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
  out <- as.matrix(Matrix::bdiag(xs))
  colnames(out) <- unlist(lapply(xs, colnames))
  out
}
