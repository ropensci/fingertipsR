library(testthat)
library(fingertipsR)

context("fingertips data extract")

df1 <- fingertips_data(IndicatorID = 90616, AreaTypeID = 152)
df2 <- suppressWarnings(fingertips_data(IndicatorID = 90616, AreaTypeID = 152, DomainID = 1938133106))
df3 <- suppressWarnings(fingertips_data(IndicatorID = 90616, AreaTypeID = 152, ProfileID = 135))
df4 <- fingertips_data(DomainID = 1938132767)
df5 <- fingertips_data(ProfileID = 152)
df6 <- fingertips_data(IndicatorID = 90616, AreaTypeID = 152, ProfileID = NA)
df7 <- fingertips_data(DomainID = 1938132767, AreaCode = "E06000015")
df8 <- fingertips_data(DomainID = 1938132767, rank = TRUE)

inds <- c(93081, 93275, 93094)
df9 <- fingertips_data(inds, ProfileID = 143, AreaTypeID = 3)

ncols <- 26

cols_to_check <- c('IndicatorID', 'ParentCode', 'AreaCode',
                   'Sex', 'Age', 'Timeperiod', 'Value',
                   'LowerCI95.0limit', 'UpperCI95.0limit',
                   'LowerCI99.8limit', 'UpperCI99.8limit',
                   'Count', 'Denominator')
test_that("the data returned are the same despite different inputs", {
        expect_equal(df1[,cols_to_check], df2[,cols_to_check])
        expect_equal(df1[,cols_to_check], df3[,cols_to_check])
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
        expect_warning(fingertips_data(DomainID = 1938133152, ProfileID = 76),
                       "DomainID is complete so ProfileID is ignored")
        expect_warning(fingertips_data(IndicatorID = c(93105, 93107),
                                       ProfileID = c(NA, 143),
                                       AreaTypeID = 8),
                       "ProfileID can not contain NAs - all ProfileIDs are ignored")
})

test_that(paste("number of fields returned by fingertips_data function are", ncols), {
        expect_equal(ncol(df1), ncols)
        expect_equal(ncol(df4), ncols)
        expect_equal(ncol(df5), ncols)
        expect_equal(ncol(df6), ncols)
        expect_equal(ncol(df7), ncols)
        expect_equal(ncol(df8), ncols + 3)
        expect_equal(ncol(df9), ncols)

})
