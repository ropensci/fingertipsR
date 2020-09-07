This package provides data from the Fingertips API owned by Public Health England.
It was archived from CRAN on 2020-08-26 because of some tests failing. These tests were nothing to do with package working as it was meant to, but rather because data would be removed from the API. The tests that now require data from the API make use of the `skip_on_cran()` function, and the package uses GitHub actions to test these functions each month once the data are updated on the API.

## Test 

* local Windows 10 install, R 4.0.2
* used Travis to check on Linux (2020-08-25)

## R CMD check results

There were no NOTEs, WARNINGs or ERRORs.

## Downstream dependencies

No errors with downstream dependencies
