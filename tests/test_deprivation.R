library(testthat)
library(fingertips)

context("Deprivation extract")

dep_default <- deprivation_decile()
dep_2010 <- deprivation_decile(Year = 2010)
dep_101 <- deprivation_decile(101)
dep_101_2010 <- deprivation_decile(101, 2010)

test_that("the dimensions of deprivation decile function are as expected", {
        expect_equal(dim(dep_default), c(152, 3))
        expect_equal(dim(dep_2010), c(152, 3))
        expect_equal(dim(dep_101), c(326, 3))
        expect_equal(dim(dep_101_2010), c(152, 3))
})

exp_classes <- c("factor","numeric","numeric")
names(exp_classes) <- c("AreaCode", "IMDscore", "decile")
test_that("the class of columns returned are factor-numeric-numeric", {
        expect_equal(sapply(dep_default,class), exp_classes)
        expect_equal(sapply(dep_2010,class), exp_classes)
        expect_equal(sapply(dep_101,class), exp_classes)
        expect_equal(sapply(dep_101_2010,class), exp_classes)
})

test_that("error messages work correctly", {
        expect_error(deprivation_decile(Year = 2014), "Year must be either 2010 or 2015")
        expect_error(deprivation_decile(AreaTypeID = 12),
                     "AreaTypeID must be either 101 (Local authority districts and Unitary Authorities) or 102 (Counties and Unitary Authorities).")
})
