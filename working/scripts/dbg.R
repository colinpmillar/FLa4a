suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]; names(idx) <- c("a","b")
d <- FLa4a:::a4aData(ple4, idx, defaultFmod(ple4), defaultQmod(idx), defaultVmod(ple4, idx), defaultN1mod(ple4), ~factor(year))
obj <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, silent=TRUE)
opt <- nlminb(obj$par, obj$fn, obj$gr, control=list(eval.max=1e4, iter.max=1e4))
cat(opt$message, opt$objective, max(abs(obj$gr(opt$par))), "\n")
p <- opt$par
for (i in 1:6) { H <- obj$he(p); g <- drop(obj$gr(p)); p <- p - solve(H, g); cat(i, obj$fn(p), max(abs(obj$gr(p))), "\n") }
e <- eigen(obj$he(p), only.values=TRUE)$values; cat("cond", max(e)/min(e), "min eig", min(e), "\n")
