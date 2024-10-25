library(testthat)
library(fingertipsR)


dep_cols <- 3
test_that("the number of columns of deprivation decile function are as expected", {
        skip_if_offline()
        expect_equal(ncol(deprivation_decile(AreaTypeID = 302, Year = 2015)), dep_cols)

})

test_that("the number of rows returned by deprivation decile is greater than 2 for AreaTypeID 202", {
        skip_on_cran()
        expect_true(
          nrow(
            deprivation_decile(
              AreaTypeID = 502,
              Year = 2019,
              proxy_settings = "none")
            ) > 2,
          info = "function works with proxy_settings = 'none'")
})

test_that("the number of rows returned by deprivation decile is greater than 2 for AreaTypeID 502", {
        skip_on_cran()
        expect_true(nrow(deprivation_decile(AreaTypeID = 502, Year = 2019)) > 2)
})


exp_classes <- c("character","numeric","integer")
names(exp_classes) <- c("AreaCode", "IMDscore", "decile")
test_that("the class of columns returned are character-numeric-integer", {
        skip_on_cran()
        expect_equal(vapply(deprivation_decile(AreaTypeID = 502, Year = 2019), class, character(1)), exp_classes)
})

test_that("error messages work correctly for incorrect Year input", {
        skip_if_offline()
        expect_error(deprivation_decile(Year = 2014, AreaTypeID = 102),
                     "Year must be 2015 or 2019")


})

test_that("error message when incorrect AreaTypeID provided to deprivation_decile", {
        skip_on_cran()
        expect_error(deprivation_decile(AreaTypeID = 12, Year = 2019),
                     "AreaTypeID not available")
})

test_that("error message when incorrect AreaTypeID provided to deprivation_decile for 2015", {
        skip_on_cran()
        expect_error(deprivation_decile(AreaTypeID = 7,
                                        Year = 2015),
                     "AreaTypeID unavailable for 2015")
})

test_that("error message when incorrect AreaTypeID provided to deprivation_decile for 2019", {
        skip_on_cran()
        expect_error(deprivation_decile(AreaTypeID = 8,
                                        Year = 2019),
                     "AreaTypeID unavailable for 2019")
})


test_that("", {
        skip_on_cran()
        expect_error(deprivation_decile(Year = 2015),
                     "AreaTypeID must be specified")
})


