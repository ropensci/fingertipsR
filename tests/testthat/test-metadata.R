library(testthat)
library(fingertipsR)

context("Test metadata")
ncols <- 30

skip_if_offline()
df1 <- indicator_metadata(IndicatorID = 10101)
skip_if_offline()
df2 <- indicator_metadata(DomainID = 1938133294)
skip_if_offline()
df3 <- indicator_metadata(ProfileID = 156)

test_that("bad inputs give bad outputs", {
        skip_if_offline()
        expect_error(indicator_metadata("blah blah"),
                     "IndicatorID\\(s\\) do not exist, use indicators\\(\\) to identify existing indicators")
        skip_if_offline()
        expect_error(indicator_metadata(DomainID = 1),
                     "DomainID\\(s\\) do not exist, use profiles\\(\\) to identify existing domains")
        skip_if_offline()
        expect_error(indicator_metadata(ProfileID = "1234 blah blah"),
                     "ProfileID\\(s\\) do not exist, use profiles\\(\\) to identify existing profiles")
        skip_if_offline()
        expect_error(indicator_metadata(),
                     "One of IndicatorID, DomainID or ProfileID must be populated")
})

test_that(paste("the number of fields in the output are", ncols), {
        skip_if_offline()
        expect_equal(ncol(df1), ncols)
        skip_if_offline()
        expect_equal(ncol(df2), ncols)
        skip_if_offline()
        expect_equal(ncol(df3), ncols)
})
