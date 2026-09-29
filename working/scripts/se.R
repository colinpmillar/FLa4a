args <- commandArgs(TRUE)
.libPaths(c(if (args[1] == "ref") "/tmp/claude-0/reflib" else "~/Rlib", .libPaths()))
suppressMessages(library(FLa4a)); data(ple4); data(ple4.index)
fit <- sca(ple4, ple4.index, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4)))
if (args[1] == "ref") { v <- fit@pars@stkmodel@vcov[,,1]; p <- fit@pars@stkmodel@coefficients[,1] } else { v <- vcov(fit)[,,1]; p <- coef(fit)[,1] }
i <- grep("fMod", names(diag(v)))[1:5]
print(round(cbind(est=c(p[i]), se=sqrt(diag(v))[i]), 6))
