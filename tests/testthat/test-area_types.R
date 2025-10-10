library(testthat)
library(fingertipsR)

test_that("the area_types function returns data frame", {
    skip_on_cran()
    expect_type(area_types(), "list")

})

test_that("area_type brings 0 row table for specific condition", {
    skip_on_cran()
    expect_equal(
      nrow(
        area_types(
          "County",
          proxy_settings = "none")
        ),
      0,
      info = "testing the filter and also proxy_settings = 'none'")

})

test_that("area_types filter for text beings same number as records as filtering for AreaTypeID", {
    skip_on_cran()
    expect_equal(area_types(c("gov","ward", "statistical")), area_types(AreaTypeID = c(8, 9, 6)))

})

test_that("area_types returns 4 column table", {
    skip_on_cran()
    expect_equal(ncol(area_types(ProfileID = 156)), 4)

})

test_that("area_type warning working correctly", {
    skip_on_cran()
    expect_warning(area_types(AreaTypeName = "gov", AreaTypeID = 102),
                   "AreaTypeName used when both AreaTypeName and AreaTypeID are entered")
})

test_that("the indicator_areatypes function returns two column table", {
    skip_on_cran()
    expect_equal(ncol(indicator_areatypes()), 2)

})

test_that("indicator_areatypes works for filter on IndicatorID = 108", {
    skip_on_cran()
    expect_equal(
      ncol(
        indicator_areatypes(
          108,
          proxy_settings = "none"))
      ,
      2,
      info = "testing the function with proxy_settings = 'none'")

})

test_that("indicator_areatypes works for filter on AreaTypeID = 201", {
    skip_on_cran()
    expect_equal(ncol(indicator_areatypes(AreaTypeID = 202)), 2)

})

test_that("indicator_areatypes throws error when multiple IndicatorIDs provided", {
    skip_on_cran()
    expect_error(indicator_areatypes(c(108, 20)), "Length of IndicatorID must be 0 or 1")

})

test_that("indicator_areatypes throws error when multiple AreaTypeIDs provided", {
    skip_on_cran()
    expect_error(indicator_areatypes(AreaTypeID = c(108, 20)), "Length of AreaTypeID must be 0 or 1")
})

test_that("category_types returns data frame", {
    skip_on_cran()
    expect_type(category_types(), "list")

})

test_that("category_types returns 5 column table", {
    skip_on_cran()
    expect_equal(
      ncol(
        category_types(
          proxy_settings = "none"
        )),
      6,
      info = "testing the function with proxy_settings = 'none'")
})

test_that("nearest_neighbours returns character vector", {
    skip_on_cran()
    expect_equal(
      nearest_neighbours(
        "E09000001",
        302,
        proxy_settings = "none"),
      character(),
      info = "testing the function with proxy_settings = 'none'")
})

test_that("nearest_neighbours throws error for deprecated AreaTypeID = 166", {
  skip_on_cran()
  expect_error(
    nearest_neighbours(AreaCode = "E38000004", AreaTypeID = 166),
    "AreaTypeID = 166 is deprecated or unsupported"
  )
})


test_that("nearest_neighbour_areatypeids provides a one column table", {
  skip_on_cran()
  expect_equal(
    ncol(
      nearest_neighbour_areatypeids()
    ),
    1,
    info = "testing the function without setting proxy_settings")
})

test_that("nearest_neighbour_areatypeids provides a one column table", {
  skip_on_cran()
  expect_equal(
    ncol(
      nearest_neighbour_areatypeids(proxy_settings = "none")
    ),
    1,
    info = "testing the function setting proxy_settings = 'none'")
})

test_that("nearest_neighbours error for incorrect AreaTypeID", {
    skip_on_cran()
  expect_error(
    nearest_neighbours("E12000001", 6),
    "AreaTypeID = 6 is deprecated or unsupported"
  )
})

test_that("nearest_neighbours error for incorrect AreaCode to AreaTypeID", {
    skip_on_cran()
    expect_error(nearest_neighbours(AreaCode = "E07000033", AreaTypeID = 502),
                 "E07000033 not in AreaTypeID = 502")

})





