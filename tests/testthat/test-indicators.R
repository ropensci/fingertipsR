library(testthat)
library(fingertipsR)

context("Profiles and indicators lookup")

test_that("profile warnings work", {
        expect_error(profiles(c(12,14)),
                       "ProfileID\\(s\\) are not in the list of profile IDs\\. Re-run the function without any inputs to see all possible IDs\\.")
        expect_error(profiles(ProfileName = "PHOF"),
                       "Profile names are not in the list of profile names\\. Re-run the function without any inputs to see all possible names\\.")
})

test_that("the profiles function works", {
        expect_is(profiles(ProfileName = "Public Health Outcomes Framework"),
                       "data.frame")
        expect_is(profiles(ProfileID = 19),
                  "data.frame")
        expect_is(profiles(ProfileID = c(19, 8)),
                  "data.frame")
})

test_that("the indicators function works", {
        expect_is(indicators(19),
                  "data.frame")
        expect_is(indicators(DomainID = 1938132767),
                  "data.frame")
})

test_that("the indicators_unique function works", {
        expect_is(indicators_unique(19),
                  "data.frame")
})

test_that("the indicator_order function works", {
        expect_is(indicator_order(DomainID = 3007000, AreaTypeID = 102, ParentAreaTypeID = 6),
                  "data.frame")
        expect_error(indicator_order(), "All of DomainID, AreaTypeID and ParentAreaTypeID are required")
        expect_error(indicator_order(DomainID = 100, AreaTypeID = 102, ParentAreaTypeID = 6),
                     "DomainID does not exist")
})
