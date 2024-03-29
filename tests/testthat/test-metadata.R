library(testthat)
library(fingertipsR)

ncols <- 32

# Error tests -------------------------------------------------------------

test_that("indicator_metadata errors when bad input to IndicatorID provided", {
  skip_on_cran()
  expect_error(indicator_metadata("blah blah"),
               "IndicatorID\\(s\\) do not exist, use indicators\\(\\) to identify existing indicators")
})

test_that("indicator_metadata errors when incorrect DomainID provided", {
  skip_on_cran()
  expect_error(indicator_metadata(DomainID = 1),
               "DomainID\\(s\\) do not exist, use profiles\\(\\) to identify existing domains")

})

test_that("indicator_metadata errors when incorrect ProfileID provided", {
  skip_on_cran()
  expect_error(indicator_metadata(ProfileID = "1234 blah blah"),
               "ProfileID\\(s\\) do not exist, use profiles\\(\\) to identify existing profiles")

})

test_that("indicator_metadata errors when nothing provided", {
  skip_on_cran()
  expect_error(indicator_metadata(),
               "One of IndicatorID, DomainID or ProfileID must be populated")

})

test_that("indicator_update_information errors when there is no relationship between IndicatorID and ProfileID", {
  skip_on_cran()
  expect_error(
    indicator_update_information(
      IndicatorID = c(10301, 10401),
      ProfileID = c(18)),
    "Not all IndicatorIDs are avaible within the provided ProfileID\\(s\\)")
})


test_that("indicator_metadata returns correct number of columns when IndicatorID provided", {
  skip_on_cran()
  expect_equal(ncol(indicator_metadata(IndicatorID = 10101)), ncols)
})

# testing dimensions ------------------------------------------------------

test_that("indicator_metadata returns correct number of columns when DomainID provided", {
  skip_on_cran()
  expect_equal(
    ncol(
      indicator_metadata(
        DomainID = 1938133294,
        proxy_settings = "none")),
    ncols,
    info = "function works with proxy_settings = 'none'")

})

test_that("indicator_metadata returns correct number of columns when ProfileID provided", {
  skip_on_cran()
  expect_equal(ncol(indicator_metadata(ProfileID = 156)), ncols)

})

test_that("indicator_metadata returns correct number of columns when ProfileID and IndicatorID provided", {
  skip_on_cran()
  expect_equal(ncol(indicator_metadata(IndicatorID = 90362, ProfileID = 156)), ncols)

})

test_that("indicator_metadata returns correct number of columns when IndicatorID option 'All' is supplied", {
  skip_on_cran()
  expect_equal(ncol(indicator_metadata(IndicatorID = "All")), ncols)
})

test_that("dimensions of indicator_update_information are correct when ProfileID isn't provided", {
  skip_on_cran()
  expect_equal(
    dim(
      indicator_update_information(
        IndicatorID = c(10301, 10401))),
    c(2, 2))
})

test_that("dimensions of indicator_update_information are correct when ProfileID is provided", {
  skip_on_cran()
  expect_equal(
    dim(
      indicator_update_information(
        IndicatorID = c(10301, 10401),
        ProfileID = c(19),
        proxy_settings = "none")),
    c(2, 2),
    info = "function works when proxy_settings = 'none'")

})

test_that("indicator_update_information works when a large number of IndicatorIDs are provided", {
  skip_on_cran()
  profiles_filter <- c(18, 19, 26, 29)
  inds <- indicators(ProfileID = profiles_filter)

  indicatorIDs <- unique(inds$IndicatorID)
  indicator_date_update <- indicator_update_information(
    IndicatorID = indicatorIDs
  )
  expect_gt(
    nrow(indicator_date_update),
    200)

})
