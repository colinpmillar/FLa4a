suppressMessages(library(FLa4a))

# data sets that test one aspect of the model each, with their submodels:
# "simple", "smooth", "covariate", "sr", "biomass"
d <- simScenario("simple", nsim = 100, seed = 1)
fit <- do.call(sca, c(list(iter(d$stock, 1), FLIndices(lapply(d$indices, iter, 1))), d$models))
ci <- derivedCI(fit, iter(d$stock, 1), FLIndices(lapply(d$indices, iter, 1)))  # SSB, Fbar, R, F
d$truth$ssb                                                             # the true values

print(head(ci, 2)); print(dims(d$stock)$iter)
