suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- FLa4a:::prepIndices(ple4.indices[c("BTS-Combined (all)", "SNS")])
fm <- if (length(commandArgs(TRUE))) ~ s(age, k = 6) + s(year, k = 40, bs = "ps") else ~ te(age, year, k = c(6, 30), bs = "ps")
d <- FLa4a:::a4aData(ple4, idx, fm, list(~ s(age, k = 5), ~ s(age, k = 4)),
  defaultVmod(ple4, idx), defaultN1mod(ple4), ~ factor(year), penalise = "f")
f <- function(p) FLa4a:::a4aNll(p, d$dat)
tm <- function(label, expr) { t0 <- Sys.time(); r <- expr; cat(sprintf("%-34s %6.2fs\n", label, as.numeric(Sys.time() - t0, units = "secs"))); invisible(r) }

# stage 1: penalised likelihood with smoothing parameters fixed
map <- list(loglambda = factor(rep(NA, length(d$par$loglambda))))
tm("stage 1 (lambda fixed, no Laplace)", {
  o0 <- RTMB::MakeADFun(f, d$par, map = map, silent = TRUE)
  op0 <- nlminb(o0$par, o0$fn, o0$gr, control = list(eval.max = 1e4, iter.max = 1e4))
})
init <- o0$env$parList(op0$par)

# stage 2a: Laplace, warm start
tm("stage 2a Laplace (warm start)", {
  o1 <- RTMB::MakeADFun(f, init, random = "re", silent = TRUE)
  op1 <- nlminb(o1$par, o1$fn, o1$gr, control = list(eval.max = 1e4, iter.max = 1e4))
})
cat("  obj", op1$objective, "conv", op1$convergence, op1$message, "iters", op1$iterations, "\n  loglam", tail(op1$par, length(d$par$loglambda)), "\n")

# stage 2b: Laplace with fixed coefficients profiled out
prof <- setdiff(names(d$par)[lengths(d$par) > 0], c("re", "loglambda"))
tm("stage 2b Laplace + profile", {
  o2 <- RTMB::MakeADFun(f, init, random = "re", profile = prof, silent = TRUE)
  op2 <- nlminb(o2$par, o2$fn, o2$gr, control = list(eval.max = 1e4, iter.max = 1e4))
})
cat("  obj", op2$objective, "conv", op2$convergence, op2$message, "iters", op2$iterations, "npar outer", length(o2$par), "\n  loglam", tail(op2$par, length(d$par$loglambda)), "\n")
