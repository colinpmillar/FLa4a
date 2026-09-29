suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
i <- 25
stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
tryCatch(withCallingHandlers(do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", verbose = TRUE))),
  error = function(e) { cs <- sys.calls(); for (c in tail(cs, 8)) cat("CALL:", substr(paste(deparse(c), collapse = " "), 1, 120), "\n") }),
  error = function(e) cat("ERROR:", conditionMessage(e), "\n"))
