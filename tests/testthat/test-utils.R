library(testthat)
library(fingertipsR)

context("API error handling")

test_that("Unavailable endpoint gives error message", {
        skip_if_offline()
        expect_error(area_types(path = "junk"),
                     "The API at junk is currently unavailable")
        skip_if_offline()
        expect_error(area_types(path = "httpstat.us/500"),
                     "The API at httpstat\\.us/500 is currently unavailable \\(HTTP code 500\\)")
})
