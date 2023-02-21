library(testthat)
library(fingertipsR)

ncols <- 27

test_that("error message for fingertips_data when no inputs provided", {
        skip_if_offline()
        expect_error(fingertips_data(),
                     "One of IndicatorID, DomainID or ProfileID must have an input")

})

test_that("error message for fingertips_data when invalid AreaTypeID provided", {
        skip_on_cran()
        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = "hello"),
                     "Invalid AreaTypeID\\. Use function area_types\\(\\) to see what values can be used\\.")

})

test_that("error message for fingertips_data when AreaTypeID is NULL", {
        skip_on_cran()
        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = NULL),
                     "AreaTypeID must have a value\\. Use function area_types\\(\\) to see what values can be used\\.")

})

test_that("error message for fingertips_data when incorrect AreaTypeID and AreaCode combination", {
        skip_on_cran()
        expect_error(fingertips_data(DomainID = 1938132767, AreaTypeID = 202, AreaCode = "hello"),
                     "Area code not contained in AreaTypeID\\.")

})

test_that("error message for fingertips_data when different length IndicatorID and ProfileID", {
        skip_on_cran()
        expect_error(fingertips_data(IndicatorID = 90631, AreaTypeID = 202, ProfileID = c(19, 20)),
                     "If ProfileID and IndicatorID are populated, they must be the same length")

})

test_that("error message for fingertips_data when categorytype not permitted value", {
        skip_on_cran()
        expect_error(fingertips_data(IndicatorID = 90631, AreaTypeID = 202, categorytype = "testerror"),
                     "categorytype input must be TRUE or FALSE")

})

test_that("", {
        skip_on_cran()
        expect_error(fingertips_data(IndicatorID = 90631),
                     "AreaTypeID must be defined")

})


test_that("warnings for fingertips_data when bad combination of AreaTypeID and AreaCode", {
        skip_on_cran()
        expect_warning(fingertips_data(DomainID = 1938133293, AreaTypeID = 202, AreaCode = "E06000015", ParentAreaTypeID = 153),
                       "AreaTypeID not a child of ParentAreaTypeID\\. There may be duplicate values in data\\. Use function area_types\\(\\) to see mappings of area type to parent area type\\.")

        })

test_that("warnings for fingertips_data when DomainID and ProfileID provided", {
        skip_on_cran()
        expect_warning(fingertips_data(DomainID = 1938133301, ProfileID = 156, AreaTypeID = 6),
                       "DomainID is complete so ProfileID is ignored")


})

test_that("warnings for fingertips_data when IndicatorID and DomainID provided", {
        skip_on_cran()
        expect_warning(fingertips_data(IndicatorID = 90366, DomainID = 1938133301, AreaTypeID = 6),
                       "If IndicatorID is populated DomainID is ignored")


})

test_that("warnings for fingertips_data when NA provided to ProfileID", {
        skip_on_cran()
        expect_warning(fingertips_data(IndicatorID = c(90366, 90362),
                                       ProfileID = c(NA, 156),
                                       AreaTypeID = 6),
                       "ProfileID can not contain NAs - all ProfileIDs are ignored")

})

test_that("the correct url produced when IndicatorID provided", {
        skip_on_cran()
        expect_equal(
          fingertips_data(IndicatorID = 90616,
                          AreaTypeID = 219,
                          url_only = TRUE),
          "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90616&child_area_type_id=219&parent_area_type_id=15&include_sortable_time_periods=yes",
          info = "function works correctly with default proxy_settings")
})

test_that("the correct url produced when DomainID provided", {
        skip_on_cran()
        expect_equal(
          fingertips_data(
            DomainID = 1938133301,
            AreaTypeID = 6,
            url_only = TRUE,
            proxy_settings = "none"),
          "https://fingertips.phe.org.uk/api/all_data/csv/by_group_id?child_area_type_id=6&parent_area_type_id=15&group_id=1938133301&include_sortable_time_periods=yes",
          info = "function works correctly with proxy_settings = 'none'")


})

test_that("the correct url produced when ProfileID provided", {
        skip_on_cran()
        expect_equal(fingertips_data(ProfileID = 156, AreaTypeID = 6, url_only = TRUE),
                     "https://fingertips.phe.org.uk/api/all_data/csv/by_profile_id?child_area_type_id=6&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes")


})

test_that("the correct url produced when bad input for ProfileID", {
        skip_on_cran()
        expect_equal(suppressWarnings(fingertips_data(IndicatorID = 90616,
                                                      AreaTypeID = 219,
                                                      ProfileID = NA,
                                                      url_only = TRUE)),
                     "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90616&child_area_type_id=219&parent_area_type_id=15&include_sortable_time_periods=yes")


})

test_that("the correct url produced when AreaCode provided", {
        skip_on_cran()
        expect_equal(fingertips_data(DomainID = 1938133301, AreaCode = "E12000005", AreaTypeID = 6, url_only = TRUE),
                     "https://fingertips.phe.org.uk/api/all_data/csv/by_group_id?child_area_type_id=6&parent_area_type_id=15&group_id=1938133301&include_sortable_time_periods=yes")


})

test_that("the correct url produced when multiple IndicatorIDs provided", {
        skip_on_cran()
        inds <- c(93081, 93275)
        expect_equal(fingertips_data(inds, ProfileID = 143, AreaTypeID = 3, url_only = TRUE),
                     sprintf("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=%s&child_area_type_id=3&parent_area_type_id=402&profile_id=143&include_sortable_time_periods=yes",
                             inds))

})

test_that("the correct url produced when AreaTypeID = 'All' and ProfileID provided", {
        skip_on_cran()
        expect_equal(fingertips_data(ProfileID = 156, AreaTypeID = "All", url_only = TRUE),
                     c("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=202&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=202&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=201&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=102&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=15&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=15&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=6&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=6&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes"))


})

test_that("the correct url produced when AreaTypeID = 'All' and IndicatorID provided", {
        skip_on_cran()
        expect_equal(fingertips_data(IndicatorID = 90362, ProfileID = 156, AreaTypeID = "All", url_only = TRUE),
                     c("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=402&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=302&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=202&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=102&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=15&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes" ,
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=6&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes"))

})



test_that("correct number of fields returned by fingertips_data when AreaTypeID = 6 and rank = TRUE", {
        skip_on_cran()
        expect_equal(ncol(fingertips_data(DomainID = 1938133301, AreaTypeID = 6, rank = TRUE)), ncols + 3)
})

test_that("correct number of fields returned by fingertips_data when AreaTypeID = 'All'", {
        skip_on_cran()
        expect_equal(ncol(fingertips_data(IndicatorID = 10101, AreaTypeID = "All", path = 'https://fingertips.phe.org.uk/api/')),
                     ncols)
})

test_that("correct number of fields returned by fingertips_data when DomainID and AreaTypeID = 'All'", {
        skip_on_cran()
        expect_equal(ncol(fingertips_data(DomainID = 1938133301, AreaTypeID = "All")),
                     ncols)
})

test_that("correct number of fields returned by fingertips_data when rank = TRUE", {
        skip_on_cran()
        expect_equal(ncol(suppressWarnings(fingertips_data(IndicatorID = 90362, AreaTypeID = 6, ProfileID = 156, rank = TRUE))), ncols + 3)

})
