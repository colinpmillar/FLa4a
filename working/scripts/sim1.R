suppressMessages(library(FLa4a)); data(ple4); data(ple4.indices)
idx <- ple4.indices[c("BTS-Combined (all)", "SNS")]
yrs <- dimnames(ple4)$year
set.seed(1); temp <- FLQuant(rnorm(length(yrs)), dimnames = list(year = yrs))
fit <- sca(ple4, idx, fmodel = ~ s(age, k = 5) + s(year, k = 20) + temp,
           qmodel = list(~ s(age, k = 5) + s(temp, k = 3), ~ s(age, k = 4)), covar = list(temp = temp))
print(fit); cat("fit size:", format(object.size(fit), units = "Mb"), "\n")
t0 <- Sys.time(); p0 <- predict(fit, ple4, idx); cat("predict secs", round(as.numeric(Sys.time() - t0), 2), "\n")
cat("reproduces fit:", max(abs(c(p0$stock.n / stock.n(fit)) - 1)), max(abs(c(p0$index[[1]] / index(fit)[[1]]) - 1), na.rm=TRUE), "\n")
p1 <- predict(fit, ple4, idx, covar = list(temp = temp + 1))
b <- c(coef(fit)["fMod:temp", 1]); cat("F ratio", range(c(p1$harvest / p0$harvest)), "exp(beta)", exp(b), "\n")
cat("SNS index unchanged ratio range:", range(c(p1$index[[2]] / p0$index[[2]] * p0$stock.n[1:7, ac(1970:2017)]/p1$stock.n[1:7, ac(1970:2017)] ), na.rm=TRUE), "\n")
t0 <- Sys.time(); s <- simulate(fit, nsim = 20, seed = 2, stock = ple4, indices = idx); cat("simulate 20 secs", round(as.numeric(Sys.time() - t0), 2), "\n")
cat(dims(s$stock)$iter, dims(s$indices[[1]])$iter, "NA pattern same:", identical(is.na(c(index(s$indices[[2]])[, , , , , 1])), is.na(c(index(idx[[2]])))), "\n")
r <- log(catch.n(s$stock) / propagate(catch.n(fit), 20)); cat("catch log resid mean", mean(r), "sd", sd(c(r)), "\n")
refit <- sca(s$stock[, , , , , 1:3], FLIndices(lapply(s$indices, function(x) x[, , , , , 1:3])), fmodel = fit@models$fmodel, qmodel = fit@models$qmodel, covar = list(temp = temp), fit = "MP")
cat("true beta", b, "refit", c(coef(refit)["fMod:temp", ]), "\n")
