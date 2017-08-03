library(testthat)
library(fingertipsR)

context("Area types")

test_that("the area_types function works correctly", {
        expect_is(area_types(), "data.frame")
        expect_equal(nrow(area_types("County")), 0)
        expect_equal(area_types(c("gov","count")), area_types(AreaTypeID = c(102,6)))
})
