suppressMessages(library(FLa4a))
tm <- function(expr) { t0 <- Sys.time(); r <- expr; list(r = r, s = as.numeric(Sys.time() - t0, units = "secs")) }
reml <- function(data, full) {
  inner <- setdiff(names(data$par)[lengths(data$par) > 0], c("vpar", "loglambda"))
  obj <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), FLa4a:::relistPar(full, data$par),
                         random = inner, silent = TRUE)
  opt <- nlminb(obj$par, obj$fn, obj$gr, control = list(eval.max = 1e4, iter.max = 1e4))
  list(opt = opt, par = obj$env$last.par)
}
run <- function(stk, idx, models, penalise = character(0)) {
  idx <- FLa4a:::prepIndices(idx)
  data <- do.call(FLa4a:::a4aData, c(list(stk, idx), models[c("fmodel","qmodel","vmodel","n1model","srmodel")], list(penalise = penalise)))
  ml <- tm(FLa4a:::fitA4a(data))
  obj0 <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, data$dat), data$par, silent = TRUE)
  full <- obj0$par; full[data$colmap$pos] <- ml$r$par
  if (length(ml$r$loglambda)) full[length(full) - length(ml$r$loglambda) + seq_along(ml$r$loglambda)] <- ml$r$loglambda
  re <- tm(reml(data, full))
  vpos <- grep("^vpar", names(obj0$par))
  cat(sprintf("  ML %.1fs  REML %.1fs (%d outer iters, conv %d)\n", ml$s, re$s, re$r$opt$iterations, re$r$opt$convergence))
  cat("  sd ML  :", round(exp(full[vpos]), 4), "\n  sd REML:", round(exp(re$r$par[vpos]), 4), "\n")
}
d <- simScenario("simple", seed = 1)
cat("simple (true sd 0.1, 0.2)\n"); run(d$stock, d$indices, d$models)
data(ple4); data(ple4.indices); idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
m <- list(fmodel = ~ te(age, year, k = c(5, 20)), qmodel = list(~ s(age, k = 5), ~ s(age, k = 4)),
          vmodel = defaultVmod(ple4, FLa4a:::prepIndices(idx)), n1model = defaultN1mod(ple4), srmodel = ~ factor(year))
cat("ple4 te(5,20)\n"); run(ple4, idx, m)
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 30, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
cat("ple4 penalised s+s+ti\n"); run(ple4, idx, m, penalise = "f")
