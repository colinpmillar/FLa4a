suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
qm <- list(~ s(age, k = 5), ~ s(age, k = 4))
run <- function(label, ...) {
  t0 <- Sys.time(); f <- sca(ple4, idx, qmodel = qm, ...)
  s <- fitSumm(f)[, 1]
  cat(sprintf("%-44s %5.1fs AIC %8.1f nopar %6.1f conv %d catch-nll %8.1f\n", label,
              as.numeric(Sys.time() - t0, units = "secs"), AIC(f), s[["nopar"]], s[["convergence"]], s[["nlogl:catch"]]))
  if (nrow(smoothing(f))) print(round(cbind(loglam = smoothing(f)[, 1], edf = s[paste0("edf:", sub(":[0-9]$", "", rownames(smoothing(f))))]), 2))
  invisible(f)
}
run("A: s(age)+s(year)+ti(age,year) ps, penalised", penalise = "fmodel",
    fmodel = ~ s(age, k = 6, bs = "ps") + s(year, k = 30, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps"))
run("B: te(k=c(6,30)) ps, vmodel catch ~1", penalise = "fmodel",
    fmodel = ~ te(age, year, k = c(6, 30), bs = "ps"), vmodel = list(~ 1, ~ 1, ~ 1))
