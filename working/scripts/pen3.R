suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
qm <- list(~ s(age, k = 5), ~ s(age, k = 4))
t0 <- Sys.time()
f <- sca(ple4, idx, fmodel = ~ te(age, year, k = c(6, 30), bs = "ps"), qmodel = qm, penalise = "fmodel", verbose = FALSE)
cat("secs", round(as.numeric(Sys.time() - t0, units = "secs"), 1), "\n")
print(t(fitSumm(f))); print(smoothing(f))
cat("catch residual sd", sd(c(log(catch.n(ple4) / catch.n(f)))), "\n")
