# fingetipsR 0.1.3

* API structure updated to include 99.8 and 95 confidence intervals. Reflected in the outputs of `fingertips_data`. **NOTE** earlier versions of the package will not work anymore because of the underlying change in the API structure

# fingertipsR 0.1.2

* fixed issue with rank and some `fingertips_data` queries

* removed dependency on tidyjson as a result of its removal from CRAN

# fingertipsR 0.1.1

* `select_indicators()` allows user to point and click to select indicators

* stringsAsFactors parameter available in `fingertips_data()`

* automatically filter for `CategoryType = FALSE` in `fingertips_data()` - this can be set to `TRUE` if needed

* rank of area and polarity of indicator returned from `fingertips_data()` where `rank = TRUE` (polarity can also be found in `indicator_metadata()`)

* `fingertips_redred` highlights which areas are statistically different to comparator *and* trending in the wrong direction

* `category_types()` lookup function to support ordering where categories exist (eg, deprivation decile)

* `areatypes_by_indicators()` to help users determine which indicators are available for each area type (and vice versa)

* A new vignette demonstrating how some of the new functions can be used

# fingertipsR version 0.1.0

This package allows the user to retrieve tables of:

* indicators, domains and profiles and their relationships to each other
* data related to indicators for geographies where the data are already available on the Fingertips website
* indicator metadata
* deprivation data for geographies that are available on the Fingertips website
