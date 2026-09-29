suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
qm <- list(~ s(age, k = 5), ~ s(age, k = 4))
tm <- function(label, expr) { t0 <- Sys.time(); r <- expr; cat(sprintf("%-26s %6.1fs\n", label, as.numeric(Sys.time() - t0, units = "secs"))); r }
show <- function(f) {
  s <- fitSumm(f)[, 1]
  cat("   loglambda:", round(smoothing(f)[, 1], 3), " edf:", round(s[grep("^edf", names(s))], 2),
      " marginal:", round(s[["nlogl:marginal"]], 3), " AIC:", round(AIC(f), 1),
      " conv:", s[["convergence"]], " maxgrad:", signif(s[["maxgrad"]], 2), "\n")
}
fm1 <- ~ s(age, k = 6) + s(year, k = 40, bs = "ps")
show(tm("1D efs", sca(ple4, idx, fmodel = fm1, qmodel = qm, penalise = "fmodel")))
show(tm("1D laplace", sca(ple4, idx, fmodel = fm1, qmodel = qm, penalise = "fmodel", sp.method = "laplace")))
fm2 <- ~ te(age, year, k = c(6, 30), bs = "ps")
f2 <- tm("2D efs", sca(ple4, idx, fmodel = fm2, qmodel = qm, penalise = "fmodel"))
show(f2)
f3 <- tm("2D efs, all submodels", sca(ple4, idx, fmodel = fm2, qmodel = list(~ s(age, k = 8, bs = "ps"), ~ s(age, k = 6, bs = "ps")),
                                        srmodel = ~ s(year, k = 40, bs = "ps"), penalise = TRUE))
show(f3)
