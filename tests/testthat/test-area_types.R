library(testthat)
library(fingertipsR)

context("Area types")

test_that("the area_types function works correctly", {
        skip_on_cran()
        expect_is(area_types(), "data.frame")
        expect_equal(nrow(area_types("County")), 0)
        expect_equal(area_types(c("gov","ward")), area_types(AreaTypeID = c(8, 6)))
        expect_equal(ncol(area_types(ProfileID = 156)), 4)
        expect_warning(area_types(AreaTypeName = "gov", AreaTypeID = 102),
                       "AreaTypeName used when both AreaTypeName and AreaTypeID are entered")
})

context("Area types by indicator")
test_that("the indicator_areatypes function is working correctly", {
        skip_if_offline()
        expect_equal(ncol(indicator_areatypes()), 2)
        expect_equal(ncol(indicator_areatypes(108)), 2)
        expect_equal(ncol(indicator_areatypes(AreaTypeID = 101)), 2)
        expect_error(indicator_areatypes(c(108, 20)), "Length of IndicatorID must be 0 or 1")
        expect_error(indicator_areatypes(AreaTypeID = c(108, 20)), "Length of AreaTypeID must be 0 or 1")
})

context("category_types works correctly")
test_that("category_types returns as expected", {
        skip_if_offline()
        expect_is(category_types(), "data.frame")
        expect_equal(ncol(category_types()), 5)
})

context("nearest_neighbours works correctly")
test_that("nearest_neighbours returns as expected", {
          skip_on_cran()
          expect_equal(nearest_neighbours("E09000001", 102, "CIPFA"), character())
          expect_is(nearest_neighbours(AreaCode = "E06000007", AreaTypeID = 101), "character")
          expect_is(nearest_neighbours(AreaCode = "E06000007", AreaTypeID = 201), "character")
          expect_is(nearest_neighbours(AreaCode = "E06000007", AreaTypeID = 202), "character")
          expect_is(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 102, measure = "CIPFA"), "character")
          expect_is(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 102, measure = "CSSN"), "character")
          expect_is(nearest_neighbours(AreaCode = "E38000002", AreaTypeID = 154), "character")
})

test_that("nearest_neighbours errors are working as expected", {
          expect_error(nearest_neighbours(AreaCode = "E12000001", AreaTypeID = 6), "AreaTypeID must be one of 101, 102, 201, 202, 152 or 154")
          expect_error(nearest_neighbours(AreaCode = "E07000033", AreaTypeID = 152), "E07000033 not in AreaTypeID = 152")
          expect_error(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 102), "If using AreaTypeID = 102, you must specify measure \\(CIPFA or CSSN\\)")
          expect_error(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 102, measure = "CIPPA"), "Measure must be either CIPFA or CSSN")
})

