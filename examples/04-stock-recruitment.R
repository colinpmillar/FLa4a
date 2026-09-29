# Stock-recruitment relationships
#
# srmodel can be a formula for recruitment (e.g. ~ factor(year)) or a
# stock-recruitment curve. With a curve, recruitment is still estimated each
# year but is penalised towards the curve with a lognormal error of the
# given CV: a small CV forces recruitment close to the curve.
#
# Run from the repository root:  source("examples/04-stock-recruitment.R")

library(FLa4a)
source("examples/helpers.R")
outDir <- exampleDir("04-stock-recruitment")  # plots are saved here

data(ple4)
data(ple4.indices)
indices <- ple4.indices[c("BTS-Combined (all)", "SNS")]
fmod <- ~ te(age, year, k = c(5, 20))
qmod <- list(~ s(age, k = 5), ~ s(age, k = 4))

srmodels <- list(
  "free"    = ~ factor(year),
  "geomean" = ~ geomean(CV = 0.4),
  "bevholt" = ~ bevholt(CV = 0.4),
  "ricker"  = ~ ricker(CV = 0.4),
  "hockey"  = ~ hockey(CV = 0.4)
)
srfits <- lapply(srmodels, function(sr) sca(ple4, indices, fmodel = fmod, qmodel = qmod, srmodel = sr))

# The SR penalty is an extra likelihood component (nlogl:srr), so compare
# the data components rather than the totals
comps <- paste0("nlogl:", c("catch", names(indices), "srr"))
tab <- sapply(srfits, function(f) round(fitSumm(f)[, 1][comps], 2))
rownames(tab) <- comps
print(tab)

# Fitted stock-recruitment curves. The SR parameters are estimated on the
# model's internal scale, where numbers are divided by exp(centering), so
# SSB is scaled down and predicted recruitment scaled back up. The formulas
# match those in R/model.R.
srCurve <- function(fit, S) {
  p <- c(coef(fit)[, 1])
  names(p) <- dimnames(coef(fit))$params
  a <- p[["sraMod:(Intercept)"]]
  b <- if ("srbMod:(Intercept)" %in% names(p)) p[["srbMod:(Intercept)"]] else 0
  sc <- exp(c(fit@centering["catch", 1]))
  s <- S / sc
  logR <- switch(as.character(fit@models$srmodel[[2]][[1]]),
    bevholt = a + log(s) - log(exp(b) + s),
    ricker  = a + log(s) - exp(b) * s,
    hockey  = a + log(s + sqrt(exp(2 * b) + 0.0025) - sqrt((s - exp(b))^2 + 0.0025)),
    geomean = rep(a, length(s)))
  exp(logR) * sc
}

stks <- lapply(srfits, function(f) ple4 + f)
cols <- fitCols(length(stks))
ssbLag <- function(s) yearly(ssb(s))[-dims(s)$year]   # recruits are age 1: pair with last year's SSB
recLag <- function(s) yearly(rec(s))[-1]

S <- seq(0, 1.1 * max(ssbLag(stks$free)), length = 200)
savePng("sr-curves", {
  par(mar = c(4, 5, 2, 1))
  plot(ssbLag(stks$free) / 1000, recLag(stks$free) / 1e6, pch = 16, col = "grey60", las = 1,
       xlim = range(S) / 1000, ylim = c(0, max(recLag(stks$free)) / 1e6),
       xlab = "SSB (thousand t)", ylab = "recruits at age 1 (millions)", main = "Fitted SR curves")
  for (i in 2:length(srfits)) lines(S / 1000, srCurve(srfits[[i]], S) / 1e6, col = cols[i], lwd = 2)
  legend("topright", c("free recruitment", names(srfits)[-1]), col = c("grey60", cols[-1]),
         pch = c(16, rep(NA, length(srfits) - 1)), lwd = c(NA, rep(2, length(srfits) - 1)),
         bty = "n", cex = 0.8)
})

# A smaller CV pulls recruitment towards the curve. If it is too small the
# curve dominates and the fit to the catches degrades.
cvs <- c(1, 0.4, 0.2, 0.1)
cvfits <- lapply(cvs, function(cv) sca(ple4, indices, fmodel = fmod, qmodel = qmod,
                                        srmodel = eval(bquote(~ bevholt(CV = .(cv))))))
tab <- sapply(cvfits, function(f) round(fitSumm(f)[comps, 1], 1))
dimnames(tab) <- list(comps, paste("CV =", cvs))
print(tab)

years <- as.numeric(dimnames(ple4)$year)
recs <- sapply(cvfits, function(f) yearly(stock.n(f)[1, ])) / 1e6
savePng("cv-effect", {
  par(mar = c(4, 5, 2, 1))
  matplot(years, recs, type = "l", lty = 1, lwd = 2, col = fitCols(length(cvs)), las = 1,
          xlab = "", ylab = "recruits (millions)", main = "bevholt: effect of CV")
  legend("topright", paste("CV =", cvs), col = fitCols(length(cvs)), lwd = 2, bty = "n", cex = 0.8)
})
