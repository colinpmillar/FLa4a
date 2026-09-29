suppressMessages(devtools::load_all(".", quiet = TRUE))
data(ple4); data(ple4.index)
fit <- sca(ple4, ple4.index, fmodel = ~ s(age, k = 5) + s(year, k = 20),
           qmodel = list(~ s(age, k = 4)), n1model = ~ s(age, k = 4))

plotN1 <- function(fit, stock, indices, ...) {
  ci <- derivedCI(fit, stock, indices, quantities = "n1")
  # reference: numbers in equilibrium with the first-year Z, starting from
  # the fitted numbers at the second age (the last age is a plus group)
  y1 <- dimnames(stock.n(fit))$year[1]
  z <- c(harvest(fit)[-1, y1] + m(stock)[-1, y1])
  eq <- ci$estimate[1] * exp(-cumsum(c(0, z[-length(z)])))
  eq[length(eq)] <- eq[length(eq)] / (1 - exp(-z[length(z)]))
  op <- par(mar = c(4, 5.5, 3, 1)); on.exit(par(op))
  plot(ci$age, ci$estimate, log = "y", pch = 19, ylim = range(ci$lower, ci$upper, eq),
       xlab = "age", ylab = "", las = 1, yaxt = "n", ...)
  axis(2, at = axTicks(2), labels = format(axTicks(2), big.mark = ",", scientific = FALSE), las = 1)
  mtext(paste("numbers in", y1), 2, line = 4.3)
  arrows(ci$age, ci$lower, ci$age, ci$upper, angle = 90, code = 3, length = 0.04)
  lines(ci$age, eq, lty = 2, col = "grey40")
  legend("topright", c("fitted n1 (95% CI)", "equilibrium at year-1 Z"),
         pch = c(19, NA), lty = c(NA, 2), col = c("black", "grey40"), bty = "n")
  invisible(ci)
}
png("n1.png", width = 700, height = 480, res = 100)
invisible(plotN1(fit, ple4, ple4.index, main = "n1model: ~ s(age, k = 4)"))
dev.off()
