library(testthat)
numVar <- 6
N <- 50
population <- matrix(rbinom(numVar*N, 1, prob = 0.5), N, numVar)
fitnessVec <- seq(15, 50, length.out=50)
eliteRate <- 0.05
c <- 0.5
k <- 5

m1 <- gaSelection(gaLRselection, list(population, fitnessVec, eliteRate))
m2 <- gaSelection(gaExpSelection, list(population, fitnessVec, eliteRate, c))
m3 <- gaSelection(gaRWselection, list(population, fitnessVec, eliteRate))
m4 <- gaSelection(gaTNselection, list(population, fitnessVec, eliteRate, k))

## test the dimension and number of output, class of output
test_that("selection returns a list with two elements", {
  expect_equal(class(gaSelection(gaLRselection, list(population, fitnessVec, eliteRate))), "list")
  expect_equal(dim(gaSelection(gaLRselection, list(population, fitnessVec, eliteRate))[[1]]), c(48,6))
  expect_equal(length(gaSelection(gaLRselection, list(population, fitnessVec, eliteRate))[[2]]), 48)
  expect_equal(class(gaSelection(gaExpSelection, list(population, fitnessVec, eliteRate, c=0.5))), "list")
  expect_equal(dim(gaSelection(gaExpSelection, list(population, fitnessVec, eliteRate, c=0.5))[[1]]), c(48,6))
  expect_equal(length(gaSelection(gaExpSelection, list(population, fitnessVec, eliteRate, c=0.5))[[2]]), 48)
  expect_equal(class(gaSelection(gaRWselection, list(population, fitnessVec, eliteRate))), "list")
  expect_equal(dim(gaSelection(gaRWselection, list(population, fitnessVec, eliteRate))[[1]]), c(48,6))
  expect_equal(length(gaSelection(gaRWselection, list(population, fitnessVec, eliteRate))[[2]]), 48)
  expect_equal(class(gaSelection(gaTNselection, list(population, fitnessVec, eliteRate, k=5))), "list")
  expect_equal(dim(gaSelection(gaTNselection, list(population, fitnessVec, eliteRate, k=5))[[1]]), c(48,6))
  expect_equal(length(gaSelection(gaTNselection, list(population, fitnessVec, eliteRate, k=5))[[2]]), 48)
})


## test whether population and fitness are updated
test_that("population and fitness are changing", {
  expect_false(identical(fitnessVec, m1[[2]]))
  expect_false(identical(fitnessVec, m2[[2]]))
  expect_false(identical(fitnessVec, m3[[2]]))
  expect_false(identical(fitnessVec, m4[[2]]))
  expect_false(identical(population, m1[[1]]))
  expect_false(identical(population, m2[[1]]))
  expect_false(identical(population, m3[[1]]))
  expect_false(identical(population, m4[[1]]))
})

## test arguments
test_that("arguments satisfies certain condition and some are not missing", {
  expect_error(gaSelection(, list(population, fitnessVec, eliteRate)), "A selection method must be provided", fixed=TRUE)
  expect_error(gaSelection(2, list(population, fitnessVec, eliteRate)), "Selection method is not a function", fixed=TRUE)
  expect_error(gaSelection(gaLRselection, list(population, fitnessVec)), "A elite rate must be provided", fixed=TRUE)
  expect_error(gaSelection(gaLRselection, list(c(1,2,3,4,5), fitnessVec, 0.5)), "Population should be a matrix", fixed=TRUE)
  expect_error(gaSelection(gaLRselection, list(population, matrix(rnorm(4),2,2), 0.5)), "Fitness values should be a vector", fixed=TRUE)
  expect_error(gaSelection(gaLRselection, list(population, fitnessVec, 1.5)), "The elite rate must be between 0 and 1", fixed=TRUE)

  expect_error(gaSelection(gaExpSelection, list(population, fitnessVec, 0.1, c=1.5)), "The exponential base c must be between 0 and 1", fixed=TRUE)
  expect_error(gaSelection(gaExpSelection, list(population, fitnessVec, 0.1)), "The exponential base for nonlinear rank selection must be provided", fixed=TRUE)

  expect_error(gaSelection(gaTNselection, list(population, fitnessVec, 0.1)), "Number of random selection must be provided for tournament selection", fixed=TRUE)
  expect_error(gaSelection(gaTNselection, list(population, fitnessVec, 0.1, 0.5)), "Number of random selections must be an integer", fixed=TRUE)
  expect_error(gaSelection(gaTNselection, list(population, fitnessVec, 0.05, 49)), "Number of random selections cannot exceed shrinked population size", fixed=TRUE)
})





## test results
# source("selection-tests.R")
# test_file("selection-tests.R")
