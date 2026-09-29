suppressMessages(library(FLa4a))
d <- simScenario("smooth", nsim = 50, seed = 3)
m <- d$models
m$fmodel <- ~ s(age, k = 6, bs = "ps") + s(year, k = 25, bs = "ps") + ti(age, year, k = c(5, 15), bs = "ps")
res <- parallel::mclapply(1:50, function(i) {
  stk <- iter(d$stock, i); idx <- FLIndices(lapply(d$indices, iter, i))
  out <- list()
  for (method in c("ML", "REML")) {
    w <- character(0)
    fit <- withCallingHandlers(tryCatch(do.call(sca, c(list(stk, idx), m, list(penalise = "fmodel", method = method))),
                                        error = function(e) conditionMessage(e)),
                               warning = function(x) { w <<- c(w, conditionMessage(x)); invokeRestart("muffleWarning") })
    out[[method]] <- if (is.character(fit)) c(i = i, method = method, conv = NA, maxgrad = NA, warn = paste("ERROR:", fit))
      else c(i = i, method = method, conv = fitSumm(fit)["convergence", 1], maxgrad = signif(fitSumm(fit)["maxgrad", 1], 2),
             warn = paste(unique(w), collapse = " | "))
  }
  do.call(rbind, out)
}, mc.cores = 4)
r <- as.data.frame(do.call(rbind, res))
bad <- r[is.na(r$conv) | r$conv != "0", ]
print(table(r$method, r$conv, useNA = "ifany"))
print(bad[, c("i", "method", "conv", "maxgrad", "warn")], right = FALSE)
