suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
tm <- function(expr) { t0 <- Sys.time(); r <- expr; cat(sprintf("  [%.1fs]\n", as.numeric(Sys.time() - t0, units = "secs"))); r }
cat("1D: F ~ s(age) + s(year, k=40, ps) penalised\n")
f1 <- tm(sca(ple4, idx, fmodel = ~ s(age, k = 6) + s(year, k = 40, bs = "ps"),
          qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)), penalise = "fmodel"))
print(t(fitSumm(f1))); print(smoothing(f1))
cat("2D: F ~ te(age, year, k=c(6,30), ps) penalised\n")
f2 <- tm(sca(ple4, idx, fmodel = ~ te(age, year, k = c(6, 30), bs = "ps"),
          qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)), penalise = "fmodel"))
print(t(fitSumm(f2))); print(smoothing(f2)); cat("vcov NA:", anyNA(vcov(f2)), "\n")
cat("unpenalised te k=c(5,20) AIC", AIC(sca(ple4, idx, fmodel = ~ te(age, year, k = c(5, 20)), qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)))), " penalised AIC", AIC(f2), "\n")
