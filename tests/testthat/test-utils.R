library(testthat)
library(fingertipsR)

test_that("Unavailable endpoint gives error message", {
        skip_if_offline()
        expect_error(area_types(path = "junk"),
                     "The API is currently unavailable")
        })

test_that("Unavailable endpoint gives error message - real url", {
        skip_if_offline()
        expect_error(area_types(path = "httpstat.us/500"),
                     "The API is currently unavailable")
})

