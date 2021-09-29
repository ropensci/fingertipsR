library(testthat)
library(fingertipsR)

context("Test metadata")
ncols <- 29

test_that("indicator_metadata errors when bad input to IndicatorID provided", {
        skip_on_cran()
        expect_error(indicator_metadata("blah blah"),
                     "IndicatorID\\(s\\) do not exist, use indicators\\(\\) to identify existing indicators")
        })

test_that("indicator_metadata errors when incorrect DomainID provided", {
        skip_on_cran()
        expect_error(indicator_metadata(DomainID = 1),
                     "DomainID\\(s\\) do not exist, use profiles\\(\\) to identify existing domains")

})

test_that("indicator_metadata errors when incorrect ProfileID provided", {
        skip_on_cran()
        expect_error(indicator_metadata(ProfileID = "1234 blah blah"),
                     "ProfileID\\(s\\) do not exist, use profiles\\(\\) to identify existing profiles")

})

test_that("indicator_metadata errors when nothing provided", {
        skip_on_cran()
        expect_error(indicator_metadata(),
                     "One of IndicatorID, DomainID or ProfileID must be populated")

})

test_that("indicator_metadata returns correct number of columns when IndicatorID provided", {
        skip_on_cran()
        expect_equal(ncol(indicator_metadata(IndicatorID = 10101)), ncols)
})

test_that("indicator_metadata returns correct number of columns when DomainID provided", {
        skip_on_cran()
        expect_equal(ncol(indicator_metadata(DomainID = 1938133294)), ncols)

})

test_that("indicator_metadata returns correct number of columns when ProfileID provided", {
        skip_on_cran()
        expect_equal(ncol(indicator_metadata(ProfileID = 156)), ncols)

})

test_that("indicator_metadata returns correct number of columns when ProfileID and IndicatorID provided", {
        skip_on_cran()
        expect_equal(ncol(indicator_metadata(IndicatorID = 90362, ProfileID = 156)), ncols)

})

test_that("indicator_metadata returns correct number of columns when IndicatorID option 'All' is supplied", {
        skip_on_cran()
        expect_equal(ncol(indicator_metadata(IndicatorID = "All")), ncols)
})
