# Covariates in the submodels
#
# Any FLQuant passed in `covar` becomes a variable that the submodel
# formulas can use, next to age and year. A covariate can vary by year only
# (e.g. an environmental index) or by age and year (e.g. mean weight at age).
# It can enter linearly, through a smoother, or as a varying coefficient.
#
# Run from the repository root:  source("examples/03-covariates.R")

library(FLa4a)
source("examples/helpers.R")
outDir <- exampleDir("03-covariates")  # plots are saved here

data(ple4)
data(ple4.indices)
indices <- ple4.indices[c("BTS-Combined (all)", "SNS")]
fmod <- ~ te(age, year, k = c(5, 20))
years <- dimnames(ple4)$year

# Estimates and standard errors of the parameters whose names match `pattern`
coefTable <- function(fit, pattern) {
  p <- c(coef(fit)[, 1])
  names(p) <- dimnames(coef(fit))$params
  se <- sqrt(diag(vcov(fit)[, , 1]))
  i <- grep(pattern, names(p))
  round(data.frame(estimate = p[i], se = se[i], z = p[i] / se[i]), 3)
}

#---------------------------------------------------------------------
# Covariates
#---------------------------------------------------------------------
# A year-only covariate: a temperature anomaly. This series is SIMULATED
# for illustration; replace it with a real environmental index.
set.seed(1)
temp <- FLQuant(c(stats::arima.sim(list(ar = 0.7), n = length(years), sd = 0.4)),
                dimnames = list(year = years))

# An age x year covariate from the data: the anomaly of log stock weight at
# age (heavier fish than usual for their age -> positive).
lw <- log(stock.wt(ple4))
wtAnomaly <- lw %-% yearMeans(lw)

savePng("covariates", {
  par(mfrow = c(2, 1), mar = c(3, 4, 2, 1))
  plot(as.numeric(years), c(temp), type = "l", lwd = 2, las = 1, xlab = "", ylab = "anomaly",
       main = "temp (simulated, year only)")
  plotAgeYear(wtAnomaly, main = "wtAnomaly: log stock weight anomaly (age x year)")
})

covar <- list(temp = temp, wtAnomaly = wtAnomaly)

#---------------------------------------------------------------------
# 1. A linear effect on survey catchability
#---------------------------------------------------------------------
# log q = s(age) + beta * temp : catchability shifts with temperature
fitBase <- sca(ple4, indices, fmodel = fmod, qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)))
fitTemp <- sca(ple4, indices, fmodel = fmod, covar = covar,
               qmodel = list(~ s(age, k = 5) + temp, ~ s(age, k = 4)))
print(coefTable(fitTemp, "temp"))
# Note: temp is random noise, yet it may look "significant". The base model's
# residuals are correlated in time, so standard errors are optimistic and a
# trending covariate can soak up misfit. Test covariates with a hypothesis,
# not by trawling.

# log q = s(age) + beta * wtAnomaly : bigger-than-usual fish are easier to catch
fitWt <- sca(ple4, indices, fmodel = fmod, covar = covar,
             qmodel = list(~ s(age, k = 5) + wtAnomaly, ~ s(age, k = 4) + wtAnomaly))
print(coefTable(fitWt, "wtAnomaly"))

#---------------------------------------------------------------------
# 2. A smooth (non-linear) effect, and an effect that varies with age
#---------------------------------------------------------------------
fitWtSmooth <- sca(ple4, indices, fmodel = fmod, covar = covar,
                   qmodel = list(~ s(age, k = 5) + s(wtAnomaly, k = 4), ~ s(age, k = 4)))

# varying coefficient: the effect of wtAnomaly is a smooth function of age
fitWtByAge <- sca(ple4, indices, fmodel = fmod, covar = covar,
                  qmodel = list(~ s(age, k = 5) + s(age, k = 3, by = wtAnomaly), ~ s(age, k = 4)))

print(fitTable(list(base = fitBase, "+ temp" = fitTemp, "+ wtAnomaly" = fitWt,
                    "+ s(wtAnomaly)" = fitWtSmooth, "+ s(age, by = wtAnomaly)" = fitWtByAge)))

#---------------------------------------------------------------------
# 3. Covariates in the F and recruitment submodels
#---------------------------------------------------------------------
# F level that responds to temperature on top of a smooth trend
fitF <- sca(ple4, indices, covar = covar, qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)),
            fmodel = ~ s(age, k = 5) + s(year, k = 20) + temp)
print(coefTable(fitF, "temp"))

# recruitment: smooth trend plus a temperature effect
fitR <- sca(ple4, indices, fmodel = fmod, covar = covar,
            qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)),
            srmodel = ~ s(year, k = 15) + temp)
print(coefTable(fitR, "temp"))

#---------------------------------------------------------------------
# 4. Structural breaks without a covariate
#---------------------------------------------------------------------
# breakpts() cuts a variable into periods, e.g. a change of survey gear or
# a management change. Here: catchability of the SNS survey differs before
# and after 1995.
fitBreak <- sca(ple4, indices, fmodel = fmod,
                qmodel = list(~ s(age, k = 5), ~ s(age, k = 4) + breakpts(year, 1995)))
print(coefTable(fitBreak, "breakpts"))
print(fitTable(list(base = fitBase, "SNS q break in 1995" = fitBreak)))

savePng("stock-summary",
        plotSummary(list(base = ple4 + fitBase, "+ wtAnomaly" = ple4 + fitWt,
                         "SNS q break" = ple4 + fitBreak), main = "Covariate models"))
