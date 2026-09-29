suppressMessages(library(FLa4a))
d <- simScenario("simple", nsim = 1, seed = 3)
pm <- d$models; pm$fmodel <- ~ s(age, k = 5) + s(year, k = 20, bs = "ps")
s2 <- simScenario("smooth", nsim = 1, seed = 3)
sm <- s2$models; sm$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
cases <- list(
  "simple ML"  = list(d, d$models, list()), "simple REML" = list(d, d$models, list(method = "REML")),
  "pen ML"     = list(d, pm, list(penalise = "fmodel")), "pen REML" = list(d, pm, list(penalise = "fmodel", method = "REML")),
  "smooth2D ML"   = list(s2, sm, list(penalise = "fmodel")), "smooth2D REML" = list(s2, sm, list(penalise = "fmodel", method = "REML")))
for (n in names(cases)) {
  x <- cases[[n]]; t0 <- Sys.time()
  f <- do.call(sca, c(list(x[[1]]$stock, x[[1]]$indices), x[[2]], x[[3]]))
  s <- fitSumm(f)[, 1]
  cat(sprintf("%-14s %5.1fs conv %d  sd %s  loglam %s\n", n, as.numeric(Sys.time() - t0, units = "secs"), s[["convergence"]],
      paste(round(exp(c(coef(f)[grep("vMod", dimnames(coef(f))$params), 1])), 3), collapse = " "),
      paste(round(smoothing(f)[, 1], 2), collapse = " ")))
}
