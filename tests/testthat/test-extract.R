library(testthat)
library(fingertipsR)

context("fingertips data extract")

ncols <- 26

test_that("error messages work for fingertips_data", {
        skip_if_offline()
        expect_error(fingertips_data(), "One of IndicatorID, DomainID or ProfileID must have an input")

        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = "hello"),
                     "Invalid AreaTypeID\\. Use function area_types\\(\\) to see what values can be used\\.")

        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = NULL),
                     "AreaTypeID must have a value\\. Use function area_types\\(\\) to see what values can be used\\.")

        expect_error(fingertips_data(DomainID = 1938132767, AreaTypeID = 202, AreaCode = "hello"),
                     "Area code not contained in AreaTypeID\\.")

        expect_error(fingertips_data(IndicatorID = 90631, AreaTypeID = 202, ProfileID = c(19, 20)),
                     "If ProfileID and IndicatorID are populated, they must be the same length")

        expect_error(fingertips_data(IndicatorID = 90631, AreaTypeID = 202, categorytype = "testerror"),
                     "categorytype input must be TRUE or FALSE")

        expect_error(fingertips_data(),
                     "One of IndicatorID, DomainID or ProfileID must have an input")

        expect_error(fingertips_data(IndicatorID = 90631),
                     "AreaTypeID must be defined")

})

test_that("warning messages work for fingertips_data", {
        skip_if_offline()
        expect_warning(fingertips_data(DomainID = 1938133293, AreaTypeID = 202, AreaCode = "E06000015", ParentAreaTypeID = 153),
                       "AreaTypeID not a child of ParentAreaTypeID\\. There may be duplicate values in data\\. Use function area_types\\(\\) to see mappings of area type to parent area type\\.")

        expect_warning(fingertips_data(DomainID = 1938133301, ProfileID = 156, AreaTypeID = 6),
                       "DomainID is complete so ProfileID is ignored")

        expect_warning(fingertips_data(IndicatorID = 90366, DomainID = 1938133301, AreaTypeID = 6),
                       "If IndicatorID is populated DomainID is ignored")

        expect_warning(fingertips_data(IndicatorID = c(93105, 93107),
                                       ProfileID = c(NA, 143),
                                       AreaTypeID = 8),
                       "ProfileID can not contain NAs - all ProfileIDs are ignored")
})

test_that(paste("number of fields returned by fingertips_data function are", ncols), {
        skip_if_offline()
        expect_equal(ncol(fingertips_data(IndicatorID = 90616, AreaTypeID = 120)), ncols)

        expect_equal(ncol(fingertips_data(DomainID = 1938133301, AreaTypeID = 6)), ncols)

        expect_equal(ncol(fingertips_data(ProfileID = 156, AreaTypeID = 6)), ncols)

        expect_equal(ncol(suppressWarnings(fingertips_data(IndicatorID = 90616,
                                                           AreaTypeID = 120,
                                                           ProfileID = NA))), ncols)

        expect_equal(ncol(fingertips_data(DomainID = 1938133301, AreaCode = "E12000005", AreaTypeID = 6)), ncols)

        expect_equal(ncol(fingertips_data(DomainID = 1938133301, AreaTypeID = 6, rank = TRUE)), ncols + 3)

        inds <- c(93081, 93275)
        expect_equal(ncol(fingertips_data(inds, ProfileID = 143, AreaTypeID = 3)), ncols)

        expect_equal(ncol(fingertips_data(IndicatorID = 10101, AreaTypeID = "All", path = 'https://fingertips.phe.org.uk/api/')), ncols)

        expect_equal(ncol(fingertips_data(DomainID = 1938133301, AreaTypeID = "All")), ncols)

        expect_equal(ncol(fingertips_data(ProfileID = 156, AreaTypeID = "All")), ncols)

        expect_equal(ncol(fingertips_data(IndicatorID = 90362, ProfileID = 156, AreaTypeID = "All")), ncols)

        expect_equal(ncol(suppressWarnings(fingertips_data(IndicatorID = 90362, AreaTypeID = 6, ProfileID = 156, rank = TRUE))), ncols + 3)
})
