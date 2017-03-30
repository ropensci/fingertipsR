library(testthat)
library(fingertips)

context("Test metadata")

test_that("bad inputs give bad outputs", {
        expect_error(indicator_metadata("blah blah"),
                     "IndicatorID(s) do not exist, use indicators() to identify existing indicators")
        expect_error(indicator_metadata(DomainID = 1),
                     "DomainID(s) do not exist, use profiles() to identify existing domains")
        expect_error(indicator_metadata(ProfileID = "1234 blah blah"),
                     "ProfileID(s) do not exist, use profiles() to identify existing profiles")
        expect_error(indicator_metadata(),
                     "One of IndicatorID, DomainID or ProfileID must be populated")
})
