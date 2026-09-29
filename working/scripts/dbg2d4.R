suppressMessages(library(FLa4a)); options(warn = 1)
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
trace(FLa4a:::fitREML, exit = quote(cat("REML nlminb:", opt$message, "| code", opt$convergence, "| iters", opt$iterations, "| vcovVpar NULL:", is.null(Vout), "| outer grad", signif(max(abs(obj$gr(opt$par))), 2), "\n")), print = FALSE, where = asNamespace("FLa4a"))
for (i in c(25, 31, 47)) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  f <- do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", method = "REML")))
  cat("sim", i, "conv", fitSumm(f)["convergence", 1], "\n")
}
