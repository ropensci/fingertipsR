library(testthat)
library(fingertipsR)

context("Deprivation extract")

dep_cols <- 3
test_that("the number of columns of deprivation decile function are as expected", {
        skip_if_offline()
        expect_equal(ncol(deprivation_decile(AreaTypeID = 202, Year = 2015)), dep_cols)

})

test_that("the number of rows returned by deprivation decile is greater than 2", {
        skip_on_cran()
        expect_true(nrow(deprivation_decile(AreaTypeID = 201, Year = 2019)) > 2)

        expect_true(nrow(deprivation_decile(AreaTypeID = 202, Year = 2019)) > 2)
})

exp_classes <- c("character","numeric","integer")
names(exp_classes) <- c("AreaCode", "IMDscore", "decile")
test_that("the class of columns returned are character-numeric-integer", {
        skip_on_cran()
        expect_equal(vapply(deprivation_decile(AreaTypeID = 202, Year = 2019), class, character(1)), exp_classes)
})

test_that("error messages work correctly", {
        skip_if_offline()
        expect_error(deprivation_decile(Year = 2014, AreaTypeID = 102), "Year must be 2015 or 2019")

        expect_error(deprivation_decile(AreaTypeID = 12, Year = 2019),
                     "AreaTypeID not available")

        expect_error(deprivation_decile(AreaTypeID = 3, Year = 2019),
                     "AreaTypeID unavailable for 2019")

        expect_error(deprivation_decile(Year = 2015),
                     "AreaTypeID must be specified")
})


