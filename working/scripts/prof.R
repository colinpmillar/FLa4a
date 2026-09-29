suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- FLa4a:::prepIndices(ple4.indices[c("BTS-Combined (all)", "SNS")])
d <- FLa4a:::a4aData(ple4, idx, ~ te(age, year, k = c(6, 30), bs = "ps"), list(~ s(age, k = 5), ~ s(age, k = 4)),
  defaultVmod(ple4, idx), defaultN1mod(ple4), ~ factor(year), penalise = "f")
cat("n re", length(d$par$re), " n fixed", length(unlist(d$par)) - length(d$par$re), "\n")
print(names(formals(RTMB::MakeADFun)))
tm <- function(label, expr) { t0 <- Sys.time(); r <- expr; cat(sprintf("%-28s %.2fs\n", label, as.numeric(Sys.time() - t0, units = "secs"))); invisible(r) }
tm("tape (no random)", o0 <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, silent = TRUE))
tm("fn+gr (no random) x10", for (i in 1:10) { o0$fn(); o0$gr() })
tm("tape (random)", o1 <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, random = "re", silent = TRUE))
tm("fn (random) first", o1$fn())
tm("fn (random) again", o1$fn())
tm("gr (random)", o1$gr())
tm("spHess", H <- o1$env$spHess(o1$env$last.par, random = TRUE)); cat("H nnz fraction", length(H@x) / prod(dim(H)), "\n")
