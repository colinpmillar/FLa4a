suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- FLa4a:::prepIndices(ple4.indices[c("BTS-Combined (all)", "SNS")])
d <- FLa4a:::a4aData(ple4, idx, ~ te(age, year, k = c(6, 30), bs = "ps"), list(~ s(age, k = 5), ~ s(age, k = 4)),
  defaultVmod(ple4, idx), defaultN1mod(ple4), ~ factor(year), penalise = "f")
tm <- function(label, expr) { t0 <- Sys.time(); r <- expr; cat(sprintf("%-26s %6.3fs\n", label, as.numeric(Sys.time() - t0, units = "secs"))); invisible(r) }
o <- RTMB::MakeADFun(function(p) FLa4a:::a4aNll(p, d$dat), d$par, silent = TRUE)
p <- o$par
tm("fn", o$fn(p)); tm("gr", o$gr(p)); tm("he", o$he(p)); tm("he again", o$he(p))
cat("n par", length(p), "\n")
# tape size
F <- RTMB::GetTape(o); print(F)
