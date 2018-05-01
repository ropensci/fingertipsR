library(testthat)
library(fingertipsR)

context("fingertips data extract")

df1 <- fingertips_data(IndicatorID = 259)
df2 <- suppressWarnings(fingertips_data(IndicatorID = 259, DomainID = 2000008))
df3 <- suppressWarnings(fingertips_data(IndicatorID = 259, ProfileID = 20))
df4 <- fingertips_data(DomainID = 1938132767)
df5 <- fingertips_data(ProfileID = 132)
df6 <- fingertips_data(IndicatorID = 259, ProfileID = NA)
df7 <- fingertips_data(DomainID = 1938132767, AreaCode = "E06000015")
df8 <- fingertips_data(DomainID = 1938132767, rank = TRUE)

ncols <- 24

test_that("the data returned are the same despite different inputs", {
        expect_equal(df1, df2)
        expect_equal(df1, df3)
})

test_that("error messages work", {
        expect_error(fingertips_data(), "One of IndicatorID, DomainID or ProfileID must have an input")
        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = "hello"),
                     "Invalid AreaTypeID\\. Use function area_types\\(\\) to see what values can be used\\.")
        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = NULL),
                     "AreaTypeID must have a value\\. Use function area_types\\(\\) to see what values can be used\\.")
        expect_error(fingertips_data(DomainID = 1938132767, AreaCode = "hello"),
                     "Area code not contained in AreaTypeID\\.")
        expect_error(fingertips_data(IndicatorID = 90631, ProfileID = c(19, 20)),
                     "If ProfileID and IndicatorID are populated, they must be the same length")
        expect_error(fingertips_data(IndicatorID = 90631, categorytype = "testerror"),
                     "categorytype input must be TRUE or FALSE")
        expect_error(fingertips_data(),
                     "One of IndicatorID, DomainID or ProfileID must have an input")

})

test_that("warning messages work", {
        expect_warning(fingertips_data(DomainID = 1938132767, AreaCode = "E06000015", ParentAreaTypeID = 153),
                       "AreaTypeID not a child of ParentAreaTypeID\\. There may be duplicate values in data\\. Use function area_types\\(\\) to see mappings of area type to parent area type\\.")
        expect_warning(fingertips_data(IndicatorID = 10101, inequalities = F),
                       "argument inequalities is deprecated; please use categorytype instead\\.")
        expect_warning(fingertips_data(DomainID = 1938133114, ProfileID = 17),
                       "DomainID is complete so ProfileID is ignored")
})

test_that(paste("number of fields returned by fingertips_data function are", ncols), {
        expect_equal(ncol(df1), ncols)
        expect_equal(ncol(df4), ncols)
        expect_equal(ncol(df5), ncols)
        expect_equal(ncol(df6), ncols)
        expect_equal(ncol(df7), ncols)
        expect_equal(ncol(df8), ncols + 3)
})
