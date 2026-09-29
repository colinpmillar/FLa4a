# Smoothers in the submodels
#
# Submodel formulas can use 'mgcv' smoothers: s() for one variable, te() and
# ti() for surfaces in age and year. Here they are unpenalised regression
# splines, so the basis dimension k sets how flexible the fit is. The number
# of parameters, and so the model choice, is traded off with AIC/BIC.
#
# (A later iteration will estimate penalised smoothers, where the amount of
# smoothing is estimated rather than fixed by k.)
#
# Run from the repository root:  source("src/examples/02-smoothers.R")

library(FLa4a)
source("src/examples/helpers.R")
outDir <- exampleDir("02-smoothers")  # plots are saved here

data(ple4)
data(ple4.indices)
indices <- ple4.indices[c("BTS-Combined (all)", "SNS")]
qmod <- list(~ s(age, k = 5), ~ s(age, k = 4))

#---------------------------------------------------------------------
# 1. Fishing mortality: from separable to fully two-dimensional
#---------------------------------------------------------------------
fmodels <- list(
  # separable: one selectivity pattern, a free level each year
  "factor(age) + factor(year)" = ~ factor(age) + factor(year),
  # separable and smooth in both directions
  "s(age) + s(year)" = ~ s(age, k = 5) + s(year, k = 20),
  # selectivity that changes smoothly over time
  "te(age, year, k = c(4, 10))" = ~ te(age, year, k = c(4, 10)),
  "te(age, year, k = c(5, 20))" = ~ te(age, year, k = c(5, 20)),
  # separable main effects plus a smooth interaction
  "s(age) + s(year) + ti(age, year)" = ~ s(age, k = 5) + s(year, k = 20) + ti(age, year, k = c(4, 8))
)

ffits <- lapply(fmodels, function(fm) sca(ple4, indices, fmodel = fm, qmodel = qmod))

# model comparison
print(fitTable(ffits))

# F surfaces on a common colour scale
zlim <- c(0, max(sapply(ffits, function(f) max(harvest(f)))))
savePng("F-surfaces", height = 900, {
  par(mfrow = c(3, 2), mar = c(3, 4, 2, 1))
  for (n in names(ffits)) plotAgeYear(harvest(ffits[[n]]), main = n, zlim = zlim)
})

# selectivity in three years: only the non-separable models let it change
savePng("selectivity", plotSelectivity(ffits, years = c(1970, 1995, 2015)))

# stock trajectories
savePng("stock-summary", plotSummary(lapply(ffits, function(f) ple4 + f), main = "fmodel comparison"))

#---------------------------------------------------------------------
# 2. Catchability: how flexible should q at age be?
#---------------------------------------------------------------------
fm <- ~ te(age, year, k = c(5, 20))
qmodels <- list(
  "~ 1 (flat)"     = list(~ 1, ~ 1),
  "~ s(age, k = 3)" = list(~ s(age, k = 3), ~ s(age, k = 3)),
  "~ s(age, k = 5)" = list(~ s(age, k = 5), ~ s(age, k = 5)),
  "~ factor(age)"   = list(~ factor(age), ~ factor(age))
)
qfits <- lapply(qmodels, function(qm) sca(ple4, indices, fmodel = fm, qmodel = qm))
print(fitTable(qfits))

# catchability at age for the beam trawl survey (index / N / exp(-Z t))
bts <- names(indices)[1]
t_bts <- mean(range(indices[[bts]])[c("startf", "endf")])
qAtAge <- sapply(qfits, function(f) {
  ages <- dimnames(index(f)[[bts]])$age
  years <- dimnames(index(f)[[bts]])$year
  Z <- harvest(f)[ages, years] + m(ple4)[ages, years]
  c((index(f)[[bts]] / (stock.n(f)[ages, years] * exp(-Z * t_bts)))[, "2010"])
})
savePng("catchability", {
  matplot(1:10, qAtAge, type = "l", lty = 1, lwd = 2, col = fitCols(ncol(qAtAge)), las = 1,
          xlab = "age", ylab = "catchability", main = paste("Catchability at age:", bts))
  legend("topleft", colnames(qAtAge), col = fitCols(ncol(qAtAge)), lwd = 2, bty = "n")
})

#---------------------------------------------------------------------
# 3. Recruitment: free, or a smooth trend
#---------------------------------------------------------------------
rmodels <- list(
  "factor(year)"    = ~ factor(year),
  "s(year, k = 30)" = ~ s(year, k = 30),
  "s(year, k = 10)" = ~ s(year, k = 10)
)
rfits <- lapply(rmodels, function(rm) sca(ple4, indices, fmodel = fm, qmodel = qmod, srmodel = rm))
print(fitTable(rfits))

years <- as.numeric(dimnames(ple4)$year)
recs <- sapply(rfits, function(f) yearly(stock.n(f)[1, ]))
savePng("recruitment", {
  matplot(years, recs, type = "l", lty = 1, lwd = 2, col = fitCols(ncol(recs)), las = 1,
          xlab = "", ylab = "recruits (thousands)", main = "Recruitment submodels")
  legend("topright", colnames(recs), col = fitCols(ncol(recs)), lwd = 2, bty = "n")
})
