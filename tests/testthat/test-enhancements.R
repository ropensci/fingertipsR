library(testthat)
library(fingertipsR)

context("Enhancement functions")

test_that("fingertips_redred should return an error", {
        expect_error(fingertips_redred(Comparator = "Sub-national", IndicatorID = 10101),
                     "Comparator must be either England, Parent or Goal")
})

numcols <- 26
test_that(paste("fingertips_redred should return a", numcols, "field data.frame"), {
        expect_equal(ncol(fingertips_redred(90616, AreaTypeID = 152, Comparator = "England")), numcols)
        expect_equal(ncol(fingertips_redred(90616, AreaTypeID = 152, Comparator = "Parent")), numcols)
        expect_equal(ncol(fingertips_redred(90776, Comparator = "Goal")), numcols)
})


test_that("fingertips_stats functionality", {
        expect_null(fingertips_stats())
})
