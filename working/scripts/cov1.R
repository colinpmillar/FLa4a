suppressMessages(library(FLa4a))
nsim <- 20
d <- simScenario("simple", nsim = nsim, seed = 42)
t0 <- Sys.time()
res <- lapply(seq_len(nsim), function(i) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  fit <- do.call(sca, c(list(stk, idx), d$models))
  ci <- derivedCI(fit, stk, idx)
  truth <- c(c(d$truth$ssb), c(d$truth$fbar), c(d$truth$rec), c(d$truth$harvest))
  data.frame(ci, truth = truth, sim = i, conv = fitSumm(fit)["convergence", 1])
})
cat("secs per sim", round(as.numeric(Sys.time() - t0, units = "secs") / nsim, 2), "\n")
r <- do.call(rbind, res)
r$covered <- r$truth >= r$lower & r$truth <= r$upper
print(tapply(r$covered, r$quantity, mean))
print(tapply(log(r$estimate / r$truth), r$quantity, mean))
cat("converged:", mean(r$conv == 0), "\n")
