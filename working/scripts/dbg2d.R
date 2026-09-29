suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
i <- 25
stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
r <- withCallingHandlers(tryCatch(do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", verbose = FALSE))), error = function(e) e),
  error = function(e) { cs <- sys.calls(); for (c in tail(cs, 12)) cat(substr(deparse(c)[1], 1, 110), "\n") })
# REML message on sim 4
i <- 4
stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
trace(FLa4a:::fitREML, exit = quote(cat("nlminb:", opt$message, " iterations", opt$iterations, "\n")), print = FALSE, where = asNamespace("FLa4a"))
f <- do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", method = "REML")))
