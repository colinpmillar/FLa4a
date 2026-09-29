# Getting started with FLa4a
#
# Fit the a4a statistical catch-at-age model to North Sea plaice (ple4),
# look at the results and check the fit to the data.
#
# Run from the repository root:  source("src/examples/01-getting-started.R")

library(FLa4a)
source("src/examples/helpers.R")
outDir <- exampleDir("01-getting-started")  # plots are saved here

#---------------------------------------------------------------------
# Data: an FLStock (catch at age and biology) and survey indices
#---------------------------------------------------------------------
data(ple4)
data(ple4.indices)

summary(ple4)
print(names(ple4.indices))

# use two surveys: a beam trawl survey (ages 1-10) and a sole net survey (ages 1-7)
indices <- ple4.indices[c("BTS-Combined (all)", "SNS")]

#---------------------------------------------------------------------
# 1. Fit with the default submodels
#---------------------------------------------------------------------
# sca() picks default formulas for F, catchability, observation variance,
# initial numbers and recruitment, scaled to the size of the data.
fit0 <- sca(ple4, indices)
print(fit0)

# The submodels that were used:
print(fit0@models$fmodel)
print(fit0@models$qmodel)

#---------------------------------------------------------------------
# 2. Fit with your own submodels
#---------------------------------------------------------------------
# Every submodel is a formula in age and year:
#   fmodel  - log fishing mortality at age and year
#   qmodel  - log catchability at age, one formula per survey
#   srmodel - log recruitment (here a free value per year)
fit1 <- sca(ple4, indices,
            fmodel  = ~ te(age, year, k = c(5, 20)),
            qmodel  = list(~ s(age, k = 5), ~ s(age, k = 4)),
            srmodel = ~ factor(year))
print(fit1)

# estimates are FLQuants
print(harvest(fit1)[, ac(2010:2017)])
print(stock.n(fit1)[, "2017"])

# parameters and their covariance matrix
print(head(coef(fit1)))
print(dim(vcov(fit1)))

#---------------------------------------------------------------------
# 3. Put the results back into the stock object
#---------------------------------------------------------------------
stk0 <- ple4 + fit0
stk1 <- ple4 + fit1

savePng("stock-summary",
        plotSummary(list(default = stk0, "te(age, year)" = stk1), main = "North Sea plaice"))

# Fishing mortality at age and year
savePng("F-at-age", plotAgeYear(harvest(fit1), main = "F at age: te(age, year, k = c(5, 20))"))

#---------------------------------------------------------------------
# 4. How well does the model fit the data?
#---------------------------------------------------------------------
# fitted vs observed survey indices
savePng("index-fit", plotIndexFit(index(indices[[1]]), index(fit1)[[1]], main = names(indices)[1]))

# residuals for the catch and the first survey
savePng("residuals", {
  par(mfrow = c(2, 1), mar = c(3, 4, 2, 1))
  plotResiduals(catch.n(ple4), catch.n(fit1), main = "catch: log residuals")
  plotResiduals(index(indices[[1]]), index(fit1)[[1]], main = paste(names(indices)[1], ": log residuals"))
})

# likelihood components and information criteria
print(fitSumm(fit1))
print(fitTable(list(default = fit0, "te(age, year)" = fit1)))

#---------------------------------------------------------------------
# 5. Management procedure runs
#---------------------------------------------------------------------
# fit = "MP" skips the covariance matrix: faster when fitting many
# iterations, e.g. inside a management strategy evaluation.
print(system.time(fitMP <- sca(ple4, indices, fmodel = ~ te(age, year, k = c(5, 20)), fit = "MP")))
