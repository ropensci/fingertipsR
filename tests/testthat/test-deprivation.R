library(testthat)
library(fingertipsR)

context("Deprivation extract")

# create progress bar so travis gets responses
pb <- txtProgressBar(style = 3)
setTxtProgressBar(pb, 0)

skip_if_offline()
dep_3_2015 <- deprivation_decile(AreaTypeID = 3, Year = 2015) #

setTxtProgressBar(pb, 0.2)
skip_if_offline()
dep_202_2019 <- deprivation_decile(AreaTypeID = 202, Year = 2019) #

setTxtProgressBar(pb, 0.4)
skip_if_offline()
dep_201_2019 <- deprivation_decile(AreaTypeID = 201, Year = 2019) #

setTxtProgressBar(pb, 0.6)
skip_if_offline()
dep_154_2019 <- deprivation_decile(AreaTypeID = 154, Year = 2019) #

setTxtProgressBar(pb, 0.8)
skip_if_offline()
dep_7_2019 <- deprivation_decile(AreaTypeID = 7, Year = 2019) #
setTxtProgressBar(pb, 1)

dep_cols <- 3
test_that("the number of columns of deprivation decile function are as expected", {
        skip_if_offline()
        expect_equal(ncol(dep_3_2015), dep_cols)
        skip_if_offline()
        expect_equal(ncol(dep_154_2019), dep_cols)
})

test_that("the number of rows returned by deprivation decile is greater than 2", {
        skip_if_offline()
        expect_true(nrow(dep_201_2019) > 2)
        skip_if_offline()
        expect_true(nrow(dep_202_2019) > 2)
})

exp_classes <- c("character","numeric","integer")
names(exp_classes) <- c("AreaCode", "IMDscore", "decile")
test_that("the class of columns returned are character-numeric-integer", {
        skip_if_offline()
        expect_equal(vapply(dep_7_2019, class, character(1)), exp_classes)
})

test_that("error messages work correctly", {
        skip_if_offline()
        expect_error(deprivation_decile(Year = 2014, AreaTypeID = 102), "Year must be 2015 or 2019")
        skip_if_offline()
        expect_error(deprivation_decile(AreaTypeID = 12, Year = 2019),
                     "AreaTypeID not available")
        skip_if_offline()
        expect_error(deprivation_decile(AreaTypeID = 3, Year = 2019),
                     "AreaTypeID unavailable for 2019")
        skip_if_offline()
        expect_error(deprivation_decile(Year = 2015),
                     "AreaTypeID must be specified")
})

test_that("warnings work correctly", {
        skip_if_offline()
        expect_warning(deprivation_decile(AreaTypeID = 120, Year = 2015),
                     "All the values are NA in this data; this can happen when the data are automatically calculated")

})
