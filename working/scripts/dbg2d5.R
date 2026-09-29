suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
fm <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
i <- 25
stk <- iter(d$stock, i); idx <- FLa4a:::prepIndices(FLIndices(lapply(d$indices, iter, i)))
data <- FLa4a:::a4aData(stk, idx, fm, d$models$qmodel, d$models$vmodel, d$models$n1model, d$models$srmodel, penalise = "f")
ml <- FLa4a:::fitA4a(data, fit = "MP")
obj0 <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), data$par, silent = TRUE)
full <- obj0$par; full[data$colmap$pos] <- ml$par; full[length(full) - length(ml$loglambda) + seq_along(ml$loglambda)] <- ml$loglambda
inner <- setdiff(names(data$par)[lengths(data$par) > 0], c("vpar", "loglambda"))
try1 <- function(label, ic = list(), restarts = 0) {
  t0 <- Sys.time()
  obj <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), FLa4a:::relistPar(full, data$par), random = inner, silent = TRUE, inner.control = ic)
  opt <- nlminb(obj$par, obj$fn, obj$gr, control = list(eval.max = 1e4, iter.max = 1e4))
  for (r in seq_len(restarts)) if (opt$convergence != 0) opt <- nlminb(opt$par, obj$fn, obj$gr, control = list(eval.max = 1e4, iter.max = 1e4))
  obj$fn(opt$par)
  cat(sprintf("%-32s %-28s obj %.6f grad %.2g  %.1fs\n", label, opt$message, opt$objective, max(abs(obj$gr(opt$par))), as.numeric(Sys.time() - t0, units = "secs")))
}
try1("default")
try1("restart x3", restarts = 3)
try1("inner tol 1e-10, maxit 1000", ic = list(tol = 1e-10, maxit = 1000))
try1("inner tol 1e-10 + restarts", ic = list(tol = 1e-10, maxit = 1000), restarts = 3)
