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

        expect_warning(fingertips_data(IndicatorID = c(90366, 90362),
                                       ProfileID = c(NA, 156),
                                       AreaTypeID = 6),
                       "ProfileID can not contain NAs - all ProfileIDs are ignored")
})

test_that("the correct urls are produced", {
        skip_if_offline()
        expect_equal(fingertips_data(IndicatorID = 90616, AreaTypeID = 219, url_only = TRUE),
                     "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90616&child_area_type_id=219&parent_area_type_id=15&include_sortable_time_periods=yes")

        expect_equal(fingertips_data(DomainID = 1938133301, AreaTypeID = 6, url_only = TRUE),
                     "https://fingertips.phe.org.uk/api/all_data/csv/by_group_id?child_area_type_id=6&parent_area_type_id=15&group_id=1938133301&include_sortable_time_periods=yes")

        expect_equal(fingertips_data(ProfileID = 156, AreaTypeID = 6, url_only = TRUE),
                     "https://fingertips.phe.org.uk/api/all_data/csv/by_profile_id?child_area_type_id=6&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes")

        expect_equal(suppressWarnings(fingertips_data(IndicatorID = 90616,
                                                      AreaTypeID = 219,
                                                      ProfileID = NA,
                                                      url_only = TRUE)),
                     "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90616&child_area_type_id=219&parent_area_type_id=15&include_sortable_time_periods=yes")

        expect_equal(fingertips_data(DomainID = 1938133301, AreaCode = "E12000005", AreaTypeID = 6, url_only = TRUE),
                     "https://fingertips.phe.org.uk/api/all_data/csv/by_group_id?child_area_type_id=6&parent_area_type_id=15&group_id=1938133301&include_sortable_time_periods=yes")

        inds <- c(93081, 93275)
        expect_equal(fingertips_data(inds, ProfileID = 143, AreaTypeID = 3, url_only = TRUE),
                     sprintf("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=%s&child_area_type_id=3&parent_area_type_id=101&profile_id=143&include_sortable_time_periods=yes",
                             inds))

        expect_equal(fingertips_data(ProfileID = 156, AreaTypeID = "All", url_only = TRUE),
                     c("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=202&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=202&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=201&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=102&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=15&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=6&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90366&child_area_type_id=6&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes"))

        expect_equal(fingertips_data(IndicatorID = 90362, ProfileID = 156, AreaTypeID = "All", url_only = TRUE),
                     c("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=302&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=202&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=102&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=15&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes",
                       "https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=90362&child_area_type_id=6&parent_area_type_id=15&profile_id=156&include_sortable_time_periods=yes"))



})
test_that(paste("number of fields returned by fingertips_data function are", ncols), {
        skip_if_offline()
        expect_equal(ncol(fingertips_data(DomainID = 1938133301, AreaTypeID = 6, rank = TRUE)), ncols + 3)


        expect_equal(ncol(fingertips_data(IndicatorID = 10101, AreaTypeID = "All", path = 'https://fingertips.phe.org.uk/api/')),
                     ncols)

        expect_equal(ncol(fingertips_data(DomainID = 1938133301, AreaTypeID = "All")),
                     ncols)

        expect_equal(ncol(suppressWarnings(fingertips_data(IndicatorID = 90362, AreaTypeID = 6, ProfileID = 156, rank = TRUE))), ncols + 3)
})
