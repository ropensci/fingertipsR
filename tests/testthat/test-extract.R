library(testthat)
library(fingertipsR)

context("fingertips data extract")

df1 <- fingertips_data(IndicatorID = 92309)
df2 <- suppressWarnings(fingertips_data(IndicatorID = 92309, DomainID = 1938132983))
df3 <- suppressWarnings(fingertips_data(IndicatorID = 92309, ProfileID = 19))

test_that("the data returned are the same despite different inputs", {
        expect_equal(df1, df2)
        expect_equal(df1, df3)
        expect_equal(ncol(df1), 22)
})

test_that("error messages work", {
        expect_error(fingertips_data(), "One of IndicatorID, DomainID or ProfileID must have an input")
        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = "hello"),
                     "Invalid AreaTypeID\\. Use function area_types\\(\\) to see what values can be used\\.")
        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = NULL),
                     "AreaTypeID must have a value\\. Use function area_types\\(\\) to see what values can be used\\.")
})
