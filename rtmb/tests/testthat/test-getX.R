df <- expand.grid(age = 1:10, year = 2000:2019)

test_that("getX builds factor and smoother designs", {
  X <- getX(~ factor(age), df)
  expect_equal(dim(X), c(200, 10))

  X <- getX(~ s(age, k = 4) + s(year, k = 6), df)
  expect_equal(dim(X), c(200, 9))
})

test_that("getX removes redundant columns", {
  expect_warning(X <- getX(~ age + I(2 * age) + year, df),
                 "redundant")
  expect_equal(qr(X)$rank, ncol(X))
})

test_that("duplicated rows do not change the smoother basis", {
  clamped <- transform(df, age = pmin(age, 6))
  X1 <- getX(~ s(age, k = 4), clamped)
  X2 <- getX(~ s(age, k = 4), unique(clamped[c("age")]))
  expect_equal(X1[!duplicated(clamped$age), ], X2, ignore_attr = TRUE)
})

test_that("breakpts cuts at the breakpoints", {
  expect_equal(levels(breakpts(2000:2010, 2005)), c("(1999,2005]", "(2005,2010]"))
})

test_that("srmodel parsing separates SR relationships from recruitment formulas", {
  expect_null(FLa4a:::parseSRmodel(~ s(year, k = 10))$sr)
  expect_equal(FLa4a:::parseSRmodel(~ bevholt(CV = 0.2))$sr$ID, 1L)
  expect_error(FLa4a:::parseSRmodel(~ bevholt() + year), "only term")
  expect_error(bevholt(CV = -1), "positive")
})
