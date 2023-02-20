test_that("Unavailable endpoint gives error message", {
        skip_if_offline()
        expect_error(area_types(path = "junk"),
                     "The API is currently unavailable")
        })

test_that("Unavailable endpoint gives error message - real url", {
        skip_if_offline()
        expect_error(area_types(path = "httpstat.us/500"),
                     "The API is currently unavailable")
})


test_that("API availability when proxy settings are removed", {
  skip_if_offline()
  expect_true(
    fingertips_ensure_api_available(proxy_settings = "none"),
    info = "when proxy_settings = `none` the function works as expected"
  )

  expect_equal(
    ncol(
      get_fingertips_api(
        api_path = "https://fingertips.phe.org.uk/api/area_types/parent_area_types",
        proxy_settings = "none"
        )),
    7,
    info = "get_fingertips_api works with proxy_settings equal to `none`"
  )
})

