library(testthat)
library(fingertipsR)

context("Profiles and indicators lookup")

test_that("profiles errors work when multiple PRofileIDs provided", {
        skip_on_cran()
        expect_error(profiles(c(12, 14)),
                       "ProfileID\\(s\\) are not in the list of profile IDs\\. Re-run the function without any inputs to see all possible IDs\\.")

})

test_that("profiles errors work when incorrect ProfileName provided", {
        skip_on_cran()
        expect_error(profiles(ProfileName = "PHOF"),
                     "Profile names are not in the list of profile names\\. Re-run the function without any inputs to see all possible names\\.")

})


test_that("the profiles function returns data frame", {
        skip_on_cran()
        expect_is(profiles(ProfileName = "Public Health Outcomes Framework"),
                  "data.frame")
        })

test_that("the profiles function returns data frame when ProfileID = 19", {
        skip_on_cran()
        expect_is(profiles(ProfileID = 19),
                  "data.frame")

})

test_that("the profiles function returns data frame when multiple ProfileIDs provided", {
        skip_on_cran()
        expect_is(profiles(ProfileID = c(19, 8)),
                  "data.frame")

})

test_that("profile indicators work", {
        skip_on_cran()
        expect_warning(indicators(ProfileID = 156, DomainID = 1938133294),
                       "DomainID is ignored as ProfileID has also been entered")

})

test_that("the indicators function works when ProfileID provided", {
        skip_on_cran()
        expect_is(indicators(19),
                  "data.frame")
        })

test_that("the indicators function works when DomainID provided", {
        skip_on_cran()
        expect_is(indicators(DomainID = 1938133294),
                  "data.frame")

})


test_that("the indicators_unique function works with ProfileID provided", {
        skip_on_cran()
        expect_is(indicators_unique(19),
                  "data.frame")
})

test_that("the indicator_order function works", {
        skip_on_cran()
        expect_is(indicator_order(DomainID = 1938133301, AreaTypeID = 6, ParentAreaTypeID = 15),
                  "data.frame")
       })

test_that("the indicator_order function errors when nothing provided", {
        skip_on_cran()
        expect_error(indicator_order(), "All of DomainID, AreaTypeID and ParentAreaTypeID are required")

})

test_that("the indicator_order function errors when incorrect DomainID provided", {
        skip_on_cran()
        expect_error(indicator_order(DomainID = 100, AreaTypeID = 102, ParentAreaTypeID = 6),
                     "DomainID does not exist")

})

