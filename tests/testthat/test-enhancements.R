library(testthat)
library(fingertipsR)

context("Enhancement functions")

test_that("fingertips_redred should return an error", {
        skip_on_cran()
        expect_error(fingertips_redred(IndicatorID = 10101, AreaTypeID = 202, Comparator = "Sub-national"),
                     "Comparator must be either England, Parent or Goal")
})

numcols <- 26
test_that(paste("fingertips_redred returns correct column number table for AreaTypeID 202"), {
        skip_on_cran()
        expect_equal(ncol(fingertips_redred(30309, AreaTypeID = 402, Comparator = "England")), numcols)
        })

test_that("fingertips_redred returns correct column number table for AreaTypeID 154", {
        skip_on_cran()
        expect_equal(ncol(fingertips_redred(90616, AreaTypeID = 154, Comparator = "Parent")), numcols)

})
test_that("fingertips_redred returns correct column number table for AreaTypeID 202", {
        skip_on_cran()
        expect_equal(ncol(fingertips_redred(90776, AreaTypeID = 202, Comparator = "Goal")), numcols)

})

test_that("fingertips_stats functionality", {
        skip_if_offline()
        expect_null(fingertips_stats())
})
