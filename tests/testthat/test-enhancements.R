library(testthat)
library(fingertipsR)

test_that("fingertips_redred should return an error", {
        skip_on_cran()
        expect_error(fingertips_redred(IndicatorID = 10101, AreaTypeID = 202, Comparator = "Sub-national"),
                     "Comparator must be either England, Parent or Goal")
})

numcols <- 27
test_that(paste("fingertips_redred returns correct column number table for AreaTypeID 202"), {
        skip_on_cran()
        expect_equal(ncol(fingertips_redred(30309, AreaTypeID = 402, Comparator = "England")), numcols)
        })

test_that("fingertips_redred returns correct column number table for AreaTypeID 154", {
        skip_on_cran()
        expect_equal(
          ncol(
            fingertips_redred(
              IndicatorID = 30309,
              AreaTypeID = 402,
              Comparator = "Parent",
              proxy_settings = "none")),
          numcols,
          info = "function works with proxy_settings = 'none'")

})
test_that("fingertips_redred returns correct column number table for AreaTypeID 202", {
        skip_on_cran()
        expect_equal(ncol(fingertips_redred(90776, AreaTypeID = 402, Comparator = "Goal")), numcols)

})

test_that("fingertips_stats functionality", {
        skip_if_offline()
        expect_output(
          fingertips_stats(),
          "Fingertips consisted of",
          fixed = TRUE,
          info = "fingertips_stats functionality with default proxy_settings")
})

test_that("fingertips_stats functionality", {
  skip_if_offline()
  expect_output(
    fingertips_stats(
      proxy_settings = "none"
    ),
    "Fingertips consisted of",
    fixed = TRUE,
    info = "fingertips_stats functionality with proxy_settings = 'none'")
})
