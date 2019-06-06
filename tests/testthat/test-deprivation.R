library(testthat)
library(fingertipsR)

context("Deprivation extract")

dep_default <- deprivation_decile()
dep_101 <- deprivation_decile(101)
dep_7 <- deprivation_decile(7)
dep_3 <- deprivation_decile(3)

dep_cols <- 3
test_that("the dimensions of deprivation decile function are as expected", {
        expect_equal(ncol(dep_default), dep_cols)
        expect_equal(ncol(dep_101), dep_cols)
        expect_equal(ncol(dep_3), dep_cols)
        expect_equal(ncol(dep_7), dep_cols)
})

exp_classes <- c("character","numeric","integer")
names(exp_classes) <- c("AreaCode", "IMDscore", "decile")
test_that("the class of columns returned are character-numeric-integer", {
        expect_equal(vapply(dep_default, class, character(1)), exp_classes)
        expect_equal(vapply(dep_101, class, character(1)), exp_classes)
        expect_equal(vapply(dep_7, class, character(1)), exp_classes)
        expect_equal(vapply(dep_3, class, character(1)), exp_classes)
})

test_that("error messages work correctly", {
        expect_error(deprivation_decile(Year = 2014), "Year must be 2015")
        expect_error(deprivation_decile(AreaTypeID = 12),
                     "AreaTypeID must be either 101 \\(Local authority districts and Unitary Authorities\\), 102 \\(Counties and Unitary Authorities\\), 3 \\(Middle Super Output Areas\\) or 7 \\(General Practice\\)\\.")
})
