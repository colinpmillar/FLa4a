# Plotting helpers shared by the examples (base graphics only).
# source("src/examples/helpers.R")

options(scipen = 10)  # plain numbers on axes

# Folder for an example's plots, src/examples/<name>/, created if needed.
exampleDir <- function(name) {
  dir <- file.path("src", "examples", name)
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  dir
}

# Draw `plot` (any plotting code) into <dir>/<name>.png. `dir` defaults to
# the `outDir` set at the top of each example.
savePng <- function(name, plot, dir = outDir, width = 900, height = 650, res = 110) {
  path <- file.path(dir, paste0(name, ".png"))
  grDevices::png(path, width = width, height = height, res = res)
  on.exit(grDevices::dev.off())
  plot
  message("saved ", path)
  invisible(path)
}

# Colours for comparing several fits
fitCols <- function(n) grDevices::hcl.colors(max(n, 2), "Dark 3")[seq_len(n)]

# Year-indexed vector from a one-row FLQuant
yearly <- function(x) {
  x <- c(x)
  names(x) <- NULL
  x
}

# SSB, Fbar, recruitment and catch for one or more stocks.
# `stocks` is a named list of FLStocks (typically `stock + fit`).
plotSummary <- function(stocks, main = "") {
  cols <- fitCols(length(stocks))
  years <- as.numeric(dimnames(stock.n(stocks[[1]]))$year)
  panels <- list(
    "SSB (t)" = function(s) ssb(s),
    "Fbar" = function(s) fbar(s),
    "Recruits (thousands)" = function(s) rec(s),
    "Catch (t)" = function(s) catch(s)
  )
  op <- par(mfrow = c(2, 2), mar = c(3, 5, 2, 1), oma = c(0, 0, if (nzchar(main)) 2 else 0, 0))
  on.exit(par(op))
  for (p in names(panels)) {
    vals <- sapply(stocks, function(s) yearly(panels[[p]](s)))
    matplot(years, vals, type = "l", lty = 1, lwd = 2, col = cols, ylim = c(0, max(vals, na.rm = TRUE)),
            xlab = "", ylab = "", main = p, las = 1, yaxt = "n")
    at <- pretty(c(0, max(vals, na.rm = TRUE)))
    axis(2, at = at, labels = format(at, big.mark = ",", scientific = FALSE, trim = TRUE), las = 1)
    if (p == "Catch (t)") points(years, yearly(catch(stocks[[1]])), pch = 16, cex = 0.5)
  }
  if (length(stocks) > 1)
    legend("topright", legend = names(stocks), col = cols, lwd = 2, bty = "n", cex = 0.8)
  mtext(main, outer = TRUE, font = 2)
}

# Image of an age x year FLQuant (e.g. harvest(fit)).
plotAgeYear <- function(x, main = "", zlim = range(x, na.rm = TRUE)) {
  m <- x[drop = TRUE]
  ages <- as.numeric(rownames(m))
  years <- as.numeric(colnames(m))
  image(years, ages, t(m), col = grDevices::hcl.colors(50, "YlOrRd", rev = TRUE),
        zlim = zlim, xlab = "", ylab = "age", main = main, las = 1)
  contour(years, ages, t(m), add = TRUE, nlevels = 6, col = "grey30", labcex = 0.6)
}

# F at age for selected years, for comparing selectivity between fits.
plotSelectivity <- function(fits, years, main = "F at age") {
  cols <- fitCols(length(fits))
  ages <- as.numeric(dimnames(harvest(fits[[1]]))$age)
  op <- par(mfrow = c(1, length(years)), mar = c(4, 4, 2, 1), oma = c(3, 0, 0, 0))
  on.exit(par(op))
  for (y in years) {
    vals <- sapply(fits, function(f) c(harvest(f)[, as.character(y)]))
    matplot(ages, vals, type = "l", lty = 1, lwd = 2, col = cols, xlab = "age", ylab = "F",
            main = paste(main, y), las = 1)
  }
  par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
  plot.new()
  legend("bottom", legend = names(fits), col = cols, lwd = 2, bty = "n", cex = 0.8, ncol = 3)
}

# Observed (points) and fitted (lines) index by age, on the log scale.
plotIndexFit <- function(obs, fitted, main = "") {
  ages <- dimnames(obs)$age
  years <- as.numeric(dimnames(obs)$year)
  nc <- ceiling(sqrt(length(ages)))
  op <- par(mfrow = c(ceiling(length(ages) / nc), nc), mar = c(2, 3, 2, 1), oma = c(0, 0, 2, 0))
  on.exit(par(op))
  for (a in ages) {
    o <- log(c(obs[a, ]))
    f <- log(c(fitted[a, ]))
    plot(years, o, pch = 16, cex = 0.7, ylim = range(o, f, na.rm = TRUE), las = 1,
         xlab = "", ylab = "", main = paste("age", a))
    lines(years, f, lwd = 2, col = fitCols(1))
  }
  mtext(paste(main, "(log scale; points observed, line fitted)"), outer = TRUE, font = 2)
}

# Bubble plot of log residuals log(observed / fitted) by age and year.
plotResiduals <- function(obs, fitted, main = "log residuals") {
  main <- paste0(main, "  (blue: observed > fitted, red: observed < fitted)")
  r <- log(obs / fitted)[drop = TRUE]
  ages <- as.numeric(rownames(r))
  years <- as.numeric(colnames(r))
  g <- expand.grid(age = ages, year = years)
  z <- c(r)
  ok <- !is.na(z)
  plot(g$year[ok], g$age[ok], cex = 3 * sqrt(abs(z[ok]) / max(abs(z), na.rm = TRUE)),
       pch = 21, bg = ifelse(z[ok] > 0, "#2166AC", "#B2182B"), col = NA,
       xlab = "", ylab = "age", main = main, las = 1, cex.main = 0.9)
}

# Table of fit statistics for a named list of fits.
fitTable <- function(fits) {
  tab <- t(sapply(fits, function(f) {
    s <- fitSumm(f)[, 1]
    c(npar = s[["nopar"]], nlogl = s[["nlogl"]], AIC = AIC(f), BIC = BIC(f),
      maxgrad = s[["maxgrad"]], converged = s[["convergence"]] == 0)
  }))
  tab <- as.data.frame(tab)
  tab$dAIC <- tab$AIC - min(tab$AIC)
  tab$dBIC <- tab$BIC - min(tab$BIC)
  round(tab[order(tab$AIC), c("npar", "nlogl", "AIC", "dAIC", "BIC", "dBIC", "maxgrad", "converged")], 3)
}

# Median and 90% band over simulations (iterations) of one age of an
# FLQuant, for several scenarios, with optional observed points.
plotEnvelope <- function(sims, age = 1, obs = NULL, main = "", ylab = "") {
  cols <- fitCols(length(sims))
  q <- lapply(sims, function(x) {
    m <- matrix(c(x[as.character(age), ]), nrow = dim(x)[2])
    t(apply(m, 1, quantile, c(0.05, 0.5, 0.95), na.rm = TRUE))
  })
  years <- as.numeric(dimnames(sims[[1]])$year)
  ylim <- range(unlist(q), if (!is.null(obs)) c(obs[as.character(age), ]), na.rm = TRUE)
  plot(NULL, xlim = range(years), ylim = ylim, las = 1, xlab = "", ylab = ylab, main = main)
  for (i in seq_along(q)) {
    ok <- !is.na(q[[i]][, 2])
    polygon(c(years[ok], rev(years[ok])), c(q[[i]][ok, 1], rev(q[[i]][ok, 3])),
            col = grDevices::adjustcolor(cols[i], 0.25), border = NA)
    lines(years[ok], q[[i]][ok, 2], col = cols[i], lwd = 2)
  }
  if (!is.null(obs)) points(years, c(obs[as.character(age), ]), pch = 16, cex = 0.6)
  legend("topleft", c(names(sims), if (!is.null(obs)) "observed"), col = c(cols, "black"),
         lwd = c(rep(2, length(sims)), NA), pch = c(rep(NA, length(sims)), if (!is.null(obs)) 16),
         bty = "n", cex = 0.8)
}
