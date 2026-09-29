suppressMessages(library(FLa4a))
nsim <- 200
d <- simScenario("simple", nsim = nsim, seed = 7)
res <- lapply(seq_len(nsim), function(i) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  fit <- do.call(sca, c(list(stk, idx), d$models))
  ci <- derivedCI(fit, stk, idx)
  s <- fitSumm(fit)[, 1]
  data.frame(ci, truth = c(c(d$truth$ssb), c(d$truth$fbar), c(d$truth$rec), c(d$truth$harvest)),
             sim = i, n = s[["nobs"]], p = s[["nopar"]])
})
r <- do.call(rbind, res)
z <- qnorm(0.975)
k <- sqrt(r$n / (r$n - r$p))
r$cov <- abs(log(r$truth / r$estimate)) <= z * r$se
r$covAdj <- abs(log(r$truth / r$estimate)) <= z * r$se * k
cat("n", r$n[1], "p", r$p[1], "inflation", round(k[1], 3), "\n")
print(round(rbind(nominal = tapply(r$cov, r$quantity, mean), df_adjusted = tapply(r$covAdj, r$quantity, mean)), 3))
# the true observation sds are 0.1 (catch) and 0.2 (survey): compare estimates
