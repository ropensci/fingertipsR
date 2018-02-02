library(testthat)
library(fingertipsR)

context("Enhancement functions")

test_that("fingertips_redred should return an error", {
        expect_error(fingertips_redred(Comparator = "Sub-national", IndicatorID == 10101),
                     "Comparator must be either England or Parent")
})

test_that("fingertips_redred should return a 24 field data.frame", {
        expect_equal(ncol(fingertips_redred(10101, Comparator = "England")), 24)
        expect_equal(ncol(fingertips_redred(10101, Comparator = "Parent")), 24)
})


test_that("fingertips_stats functionality", {
        expect_null(fingertips_stats())
})
