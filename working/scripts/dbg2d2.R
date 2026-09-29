suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
one <- function(i, method) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  f <- tryCatch(do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", method = method))), error = function(e) conditionMessage(e))
  if (is.character(f)) return(paste("ERROR", f))
  s <- fitSumm(f)[, 1]; paste("conv", s[["convergence"]], "maxgrad", signif(s[["maxgrad"]], 2))
}
for (i in c(25, 33)) cat("sim", i, "ML:", one(i, "ML"), "\n")
trace(FLa4a:::fitSmoothing, exit = quote(cat("  FS: converged", converged, " inner converged", fitted$converged, " iterations", it, "\n")), print = FALSE, where = asNamespace("FLa4a"))
cat("sim 4 REML:", one(4, "REML"), "\n")
cat("sim 4 ML:", one(4, "ML"), "\n")
