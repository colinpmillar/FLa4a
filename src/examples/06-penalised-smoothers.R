# Penalised smoothers with estimated smoothing parameters
#
# With penalise = TRUE (or naming submodels, e.g. penalise = "fmodel"),
# smoothers are penalised and their smoothing parameters estimated, so the
# basis size k only needs to be large enough, instead of being tuned by hand.
#
# The smoother coefficients have a Gaussian prior whose precision is the
# smoothing-parameter weighted sum of the smoother's penalty matrices (as in
# mgcv). Smoothing parameters maximise the Laplace approximation of the
# marginal likelihood, in which the coefficients are integrated out:
#   sp.method = "efs"      extended Fellner-Schall updates (default, fast)
#   sp.method = "laplace"  RTMB's Laplace approximation, maximised directly
# P-splines (bs = "ps") give sparse bases and penalties.
#
# Run from the repository root:  source("src/examples/06-penalised-smoothers.R")
# (takes about 1-2 minutes)

library(FLa4a)
source("src/examples/helpers.R")
outDir <- exampleDir("06-penalised-smoothers")  # plots are saved here

data(ple4)
data(ple4.indices)
indices <- ple4.indices[c("BTS-Combined (all)", "SNS")]
qmod <- list(~ s(age, k = 5), ~ s(age, k = 4))
years <- as.numeric(dimnames(ple4)$year)

#---------------------------------------------------------------------
# 1. A 1D smoother: the year effect in F
#---------------------------------------------------------------------
# Unpenalised, the flexibility of s(year) is set by k; penalised, a large k
# is shrunk to what the data support.
fits1 <- list(
  "k = 10, unpenalised" = sca(ple4, indices, qmodel = qmod,
                              fmodel = ~ s(age, k = 5) + s(year, k = 10)),
  "k = 40, unpenalised" = sca(ple4, indices, qmodel = qmod,
                              fmodel = ~ s(age, k = 5) + s(year, k = 40, bs = "ps")),
  "k = 40, penalised"   = sca(ple4, indices, qmodel = qmod, penalise = "fmodel",
                              fmodel = ~ s(age, k = 5) + s(year, k = 40, bs = "ps"))
)
print(fitTable(fits1))

pen1 <- fits1[["k = 40, penalised"]]
print(smoothing(pen1))                             # log smoothing parameters
print(fitSumm(pen1)[grep("edf", rownames(fitSumm(pen1))), 1])  # effective degrees of freedom

# the same model with the smoothing parameters from RTMB's Laplace approximation
pen1L <- sca(ple4, indices, qmodel = qmod, penalise = "fmodel", sp.method = "laplace",
             fmodel = ~ s(age, k = 5) + s(year, k = 40, bs = "ps"))
print(cbind(efs = smoothing(pen1)[, 1], laplace = smoothing(pen1L)[, 1]))

fbarRange <- ac(range(ple4)["minfbar"]:range(ple4)["maxfbar"])
fbars <- sapply(fits1, function(f) yearly(quantMeans(harvest(f)[fbarRange, ])))
savePng("fbar-1d", {
  par(mar = c(3, 4, 2, 1))
  matplot(years, fbars, type = "l", lty = 1, lwd = 2, col = fitCols(3), las = 1,
          xlab = "", ylab = "Fbar", main = "F ~ s(age) + s(year): unpenalised vs penalised")
  legend("topleft", colnames(fbars), col = fitCols(3), lwd = 2, bty = "n", cex = 0.8)
})

# approximate 95% intervals for log Fbar at age 4 from the posterior covariance
sims <- simulate(pen1, nsim = 200, seed = 1, stock = ple4, indices = indices, sample.pars = TRUE)
f4 <- matrix(c(harvest(sims$stock)["4", ]), nrow = length(years))
savePng("F-age4-uncertainty", {
  par(mar = c(3, 4, 2, 1))
  q <- apply(f4, 1, quantile, c(0.025, 0.5, 0.975))
  plot(years, q[2, ], type = "n", ylim = range(q), las = 1, xlab = "", ylab = "F at age 4",
       main = "Penalised s(year): F at age 4 with 95% intervals")
  polygon(c(years, rev(years)), c(q[1, ], rev(q[3, ])), col = grDevices::adjustcolor(fitCols(1), 0.3), border = NA)
  lines(years, c(harvest(pen1)["4", ]), lwd = 2, col = fitCols(1))
})

#---------------------------------------------------------------------
# 2. A 2D smoother: F as a surface in age and year
#---------------------------------------------------------------------
# Separable main effects plus a smooth interaction, each penalised with its
# own smoothing parameters (the ti() interaction has one for age and one for
# year). The other submodels are as in the unpenalised comparison.
#
# A single te(age, year) surface can also be penalised. For ple4 the
# marginal likelihood then favours very little smoothing across ages (about
# 150 edf), so F follows the catch-at-age data closely, and the fit takes
# 30-60 seconds. Whether that is desirable is a modelling choice: catch
# observation error and variation in F are separated only by the model's
# structure, e.g.
#   sca(ple4, indices, qmodel = qmod, penalise = "fmodel",
#       fmodel = ~ te(age, year, k = c(6, 30), bs = "ps"))
fits2 <- list(
  "te(age, year, k = c(5, 20)), unpenalised" =
    sca(ple4, indices, qmodel = qmod, fmodel = ~ te(age, year, k = c(5, 20))),
  "s(age) + s(year) + ti(age, year), penalised" =
    sca(ple4, indices, qmodel = qmod, penalise = "fmodel",
        fmodel = ~ s(age, k = 6, bs = "ps") + s(year, k = 30, bs = "ps") +
          ti(age, year, k = c(5, 15), bs = "ps"))
)
print(fitTable(fits2))
pen2 <- fits2[[2]]
print(round(cbind(loglambda = smoothing(pen2)[, 1]), 2))
print(round(fitSumm(pen2)[grep("edf", rownames(fitSumm(pen2))), 1], 2))

zlim <- c(0, max(sapply(fits2, function(f) max(harvest(f)))))
savePng("F-surfaces-2d", width = 1100, height = 450, {
  par(mfrow = c(1, 2), mar = c(3, 4, 2, 1))
  for (n in names(fits2)) plotAgeYear(harvest(fits2[[n]]), main = n, zlim = zlim)
})

savePng("stock-summary", plotSummary(list("1D penalised" = ple4 + pen1, "2D penalised" = ple4 + pen2,
                                          "2D unpenalised" = ple4 + fits2[[1]]),
                                     main = "Penalised smoothers"))
