suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)

temp <- FLQuant(rnorm(61), dimnames = list(year = 1957:2017))
fit <- sca(ple4, ple4.indices["BTS-Combined (all)"], covar = list(temp = temp),
           fmodel = ~ s(age, k = 5) + s(year, k = 20) + temp,
           qmodel = list(~ s(age, k = 4)))

# expected values, and simulated catches and indices, under new covariates
p   <- predict(fit, ple4, ple4.indices["BTS-Combined (all)"], covar = list(temp = temp + 1))
sim <- simulate(fit, nsim = 100, stock = ple4, indices = ple4.indices["BTS-Combined (all)"],
                covar = list(temp = temp + 1))
refit <- sca(sim$stock, sim$indices, covar = list(temp = temp),
             fmodel = fit@models$fmodel, qmodel = fit@models$qmodel)

print(dims(sim$stock)$iter); print(fitSumm(refit)['convergence',1:3])
