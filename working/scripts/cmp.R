args <- commandArgs(TRUE)
lib <- if (args[1] == "ref") "/tmp/claude-0/reflib" else "~/Rlib"
.libPaths(c(lib, .libPaths()))
suppressMessages(library(FLa4a))
data(ple4); data(ple4.indices); data(ple4.index)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
bidx <- as(ple4.index, "FLIndexBiomass"); index(bidx) <- quantSums(index(ple4.index) * stock.wt(ple4)[1:10, ac(1996:2017)]); range(bidx)[c("startf","endf")] <- c(0.6, 0.7)
cases <- list(
  sep   = list(ple4, ple4.index, fmodel=~factor(age)+factor(year), qmodel=list(~factor(age))),
  smth  = list(ple4, idx, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4), ~s(age,k=3))),
  deflt = list(ple4, idx),
  bh    = list(ple4, ple4.index, fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4)), srmodel=~bevholt(CV=0.3)),
  gm    = list(ple4, ple4.index, fmodel=~te(age,year,k=c(4,15)), qmodel=list(~s(age,k=4)), srmodel=~geomean(CV=0.5)),
  bio   = list(ple4, FLIndices(a=ple4.index, b=bidx), fmodel=~s(age,k=5)+s(year,k=20), qmodel=list(~s(age,k=4), ~1))
)
res <- lapply(names(cases), function(n) {
  t <- system.time(fit <- suppressWarnings(do.call(sca, cases[[n]])))[3]
  s <- fitSumm(fit)
  data.frame(case=n, nopar=s["nopar",1], nlogl=s["nlogl",1], ssb2017=c(ssb(ple4+fit)[, "2017"]),
             fbar2017=c(fbar(ple4+fit)[, "2017"]), rec2017=c(stock.n(fit)[1, "2017"]), idxb=c(index(fit)[[length(index(fit))]][1,"2000"]), sec=t)
})
print(do.call(rbind, res), digits = 7, row.names = FALSE)
