library(testthat)
library(fingertipsR)

context("Area types")

test_that("the area_types function works correctly", {
        expect_is(area_types(), "data.frame")
        expect_equal(nrow(area_types("County")), 0)
        expect_equal(area_types(c("gov","count")), area_types(AreaTypeID = c(102,6)))
})

context("Area types by indicator")

test_that("the indicator_areatypes function is working correctly", {
        expect_equal(ncol(indicator_areatypes()), 2)
        expect_equal(ncol(indicator_areatypes(108)), 2)
        expect_equal(ncol(indicator_areatypes(AreaTypeID = 101)), 2)
        expect_error(indicator_areatypes(c(108, 20)), "Length of IndicatorID must be 0 or 1")
        expect_error(indicator_areatypes(AreaTypeID =c(108, 20)), "Length of AreaType must be 0 or 1")
})
