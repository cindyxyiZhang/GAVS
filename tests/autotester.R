library(testthat)

current <- getwd()

CODE       <- paste0(current, "/R/.")
TEST_FILES <- paste0(current, "/tests/testthat")

auto_test(CODE, TEST_FILES)
