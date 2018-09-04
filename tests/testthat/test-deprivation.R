library(testthat)
library(fingertipsR)

context("Deprivation extract")

dep_default <- deprivation_decile()
dep_101 <- deprivation_decile(101)
dep_7 <- deprivation_decile(7)
dep_7_2010 <- deprivation_decile(7, 2010)
dep_3 <- deprivation_decile(3)

test_that("the dimensions of deprivation decile function are as expected", {
        expect_equal(dim(dep_default), c(152, 3))
        expect_equal(dim(dep_101), c(326, 3))
        expect_equal(dim(dep_3), c(6791, 3))
})

exp_classes <- c("character","numeric","integer")
names(exp_classes) <- c("AreaCode", "IMDscore", "decile")
test_that("the class of columns returned are character-numeric-integer", {
        expect_equal(vapply(dep_default, class, character(1)), exp_classes)
        expect_equal(vapply(dep_101, class, character(1)), exp_classes)
        expect_equal(vapply(dep_7, class, character(1)), exp_classes)
        expect_equal(vapply(dep_7_2010, class, character(1)), exp_classes)
        expect_equal(vapply(dep_3, class, character(1)), exp_classes)
})

test_that("error messages work correctly", {
        expect_error(deprivation_decile(Year = 2014), "Year must be either 2010, 2011, 2012 or 2015")
        expect_error(deprivation_decile(AreaTypeID = 12),
                     "AreaTypeID must be either 101 \\(Local authority districts and Unitary Authorities\\), 102 \\(Counties and Unitary Authorities\\), 3 \\(Middle Super Output Areas\\) or 7 \\(General Practice\\)\\.")
        expect_error(deprivation_decile(Year = 2011),
                     "Year must be 2015 for AreaTypeID of 101 or 102")

        expect_error(deprivation_decile(AreaType = 101, Year = 2011),
                     "Year must be 2015 for AreaTypeID of 101 or 102")

})
