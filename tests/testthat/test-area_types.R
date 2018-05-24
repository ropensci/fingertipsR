library(testthat)
library(fingertipsR)

context("Area types")

test_that("the area_types function works correctly", {
        expect_is(area_types(), "data.frame")
        expect_equal(nrow(area_types("County")), 0)
        expect_equal(area_types(c("gov","count")), area_types(AreaTypeID = c(102,6)))
        expect_warning(area_types(AreaTypeName = "gov", AreaTypeID = 102),
                       "AreaTypeName used when both AreaTypeName and AreaTypeID are entered")
})

context("Area types by indicator")

test_that("the indicator_areatypes function is working correctly", {
        expect_equal(ncol(indicator_areatypes()), 2)
        expect_equal(ncol(indicator_areatypes(108)), 2)
        expect_equal(ncol(indicator_areatypes(AreaTypeID = 101)), 2)
        expect_error(indicator_areatypes(c(108, 20)), "Length of IndicatorID must be 0 or 1")
        expect_error(indicator_areatypes(AreaTypeID =c(108, 20)), "Length of AreaTypeID must be 0 or 1")
})

context("category_types works correctly")
test_that("category_types returns as expected", {
        expect_is(category_types(), "data.frame")
        expect_equal(ncol(category_types()), 4)
})

context("nearest_neighbours works correctly")
test_that("nearest_neighbours returns as expected", {
        expect_is(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 101), "character")
        expect_is(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 102, measure = "CIPFA"), "character")
        expect_is(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 102, measure = "CSSN"), "character")
        expect_is(nearest_neighbours(AreaCode = "E38000022", AreaTypeID = 153), "character")
        expect_error(nearest_neighbours(AreaCode = "E12000001", AreaTypeID = 6), "AreaTypeID must be one of 101, 102, 152 or 153")
        expect_error(nearest_neighbours(AreaCode = "E07000033", AreaTypeID = 152), "E07000033 not in AreaTypeID = 152")
        expect_error(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 102), "If using AreaTypeID = 102, you must specify measure \\(CIPFA or CSSN\\)")
        expect_error(nearest_neighbours(AreaCode = "E10000007", AreaTypeID = 102, measure = "CIPPA"), "Measure must be either CIPFA or CSSN")
})
