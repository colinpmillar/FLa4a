suppressMessages(library(FLa4a))
d <- simScenario("sr", seed = 1)
run <- function(label, ...) {
  t0 <- Sys.time()
  f <- do.call(sca, c(list(d$stock, d$indices), utils::modifyList(d$models, list(...)[intersect(names(list(...)), names(d$models))]),
                      list(...)[setdiff(names(list(...)), names(d$models))]))
  s <- fitSumm(f)[, 1]
  cat(sprintf("%-26s %5.1fs conv %d maxgrad %.1g nopar %.1f nlogl %.2f", label, as.numeric(Sys.time() - t0, units = "secs"),
              s[["convergence"]], s[["maxgrad"]], s[["nopar"]], s[["nlogl"]]))
  if ("srr:cv" %in% names(s)) cat(sprintf("  CV %.3f  edfR %.1f", s[["srr:cv"]], s[["edf:recruitment"]]))
  cat(sprintf("  rec err %.3f  vcovNA %s\n", sqrt(mean(log(c(stock.n(f)[1, ]) / c(d$truth$rec))^2)), anyNA(vcov(f))))
  invisible(f)
}
run("bevholt CV fixed 0.3", srmodel = ~ bevholt(CV = 0.3))
run("bevholt CV estimated", srmodel = ~ bevholt(CV = NA))
run("geomean CV estimated", srmodel = ~ geomean(CV = NA))
run("bevholt CV est, REML", srmodel = ~ bevholt(CV = NA), method = "REML")
run("free recruitment", srmodel = ~ factor(year))
