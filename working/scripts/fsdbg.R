suppressMessages(library(FLa4a)); data(ple4); data(ple4.index)
f <- sca(ple4, ple4.index, fmodel = ~ s(age, k = 5) + s(year, k = 25, bs = "ps"), qmodel = list(~ s(age, k = 4)),
         penalise = "fmodel", verbose = TRUE)
print(fitSumm(f)[c("convergence", "maxgrad"), 1]); print(smoothing(f))
