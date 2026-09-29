suppressMessages(library(FLa4a))
for (sc in c("simple", "smooth", "covariate", "sr", "biomass")) {
  d <- simScenario(sc, nsim = 1, seed = 1)
  cat(sprintf("%-10s ages %s years %d-%d surveys %s | SSB %6.0f-%6.0f Fbar %.2f-%.2f R %.2g-%.2g\n", sc,
              paste(range(as.numeric(dimnames(d$stock)$age)), collapse = "-"),
              min(as.numeric(dimnames(d$stock)$year)), max(as.numeric(dimnames(d$stock)$year)),
              paste(names(d$indices), collapse = ","),
              min(d$truth$ssb), max(d$truth$ssb), min(d$truth$fbar), max(d$truth$fbar), min(d$truth$rec), max(d$truth$rec)))
}
d <- simStock(ages = 1:6, years = 1991:2020, fbar = c(2, 4), sel = list(a50 = 2, slope = 0.5),
              surveys = list(simSurvey("s", ages = 1:5, q = 2e-3, sd = 0.01)), catch.sd = 0.01, seed = 1)
m <- simScenario("simple")$models
fit <- do.call(sca, c(list(d$stock, d$indices), m))
cat("conv", fitSumm(fit)["convergence", 1], "\n")
cat("max rel error: harvest", max(abs(c(harvest(fit) / d$truth$harvest) - 1)),
    " stock.n", max(abs(c(stock.n(fit) / d$truth$stock.n) - 1)), "\n")
ci <- derivedCI(fit, d$stock, d$indices)
s <- ci[ci$quantity == "ssb", ]
cat("ssb est vs truth max rel", max(abs(s$estimate / c(d$truth$ssb) - 1)), " vs fit ssb", max(abs(s$estimate / c(ssb(d$stock + fit)) - 1)), "\n")
f <- ci[ci$quantity == "fbar", ]; cat("fbar vs fit", max(abs(f$estimate / c(fbar(d$stock + fit)) - 1)), "\n")
h <- ci[ci$quantity == "harvest", ]; cat("harvest vs fit", max(abs(h$estimate / c(harvest(fit)) - 1)), "\n")
print(head(ci[ci$quantity == "ssb", ], 3))
