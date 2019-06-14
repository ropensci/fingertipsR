# fingertipsR 0.2.6.9000
 * Added option for `AreaTypeId = "All"` in `fingertips_data()`
 * Added `ProfileID` argument to `area_types()` function

# fingertipsR 0.2.6

* fixed `indicator_order()` function

* `nearest_neighbours()` now allows AreaTypeID 154 (CCG unchanged plus new 2018), but no longer allows AreaTypeID 153

* `nearest_neighbours()` function has been fixed

# fingertipsR 0.2.4

* no changes from a user perspective to previous versions

# fingertipsR 0.2.3 (2019-05-14)

* no changes from a user perspective to previous versions

# fingertipsR 0.2.2 (2019-04-08)

* no changes from a user perspective to previous versions

# fingertipsR 0.2.1 (2019-03-07)

 * `deprivation_decile()` for `AreaTypeID = 7` (General Practice) now only contains 2015 deprivation deciles. 2010 to 2012 have been removed

* bug fix around entering vectors of `IndicatorID`s and `ProfileID`s into `fingertips_data()` function

# fingertipsR 0.2.0 (2018-11-12)

* `select_indicators()` fixed for selecting more than one indicator

* `deprivation_decile()` now includes MSOA (AreaTypeID = 3)

* removed deprecated `inequalities` argument from `fingertips_data()`

* increased speed of `indicators()` function (and therefore `select_indicators()` and other functions that rely on it)

* IndicatorName field in `indicators()` table returns short name rather than long name

# fingertipsR 0.1.9 (2018-08-31)

* New field "Compared to goal" in `fingertips_data()`

* New field name "Compared to [AreaType]" in `fingertips_data()`

* Improved tests

# fingertipsR 0.1.8 (2018-07-05)

* fingertips_data function adapted for "New data" field in API

# fingertipsR 0.1.7 (27/05/2018)

* nearest_neighbours() modified to include `measure` parameter - so user can get 15 CIPFA nn for upper tier local authorities

* data retrieval functions now use local proxy settings

# fingertipsR 0.1.6 (03/05/2018)

* nearest_neighbours() function added

* indicator_order() function added

# fingertipsR 0.1.5 (06/02/2018)

* corrected fingertips_stats to give accurate stats

# fingertipsR 0.1.4 (03/02/2018)

* modifications to the fingertipsR paper

* badges added to README

* package approved by ropensci

* fingertips_stats function added to give high level statistics of indicators in Fingertips

* indicator_areatypes now links to API rather than built in dataset

* indicators_unique function provides unique table of indicators

# fingertipsR 0.1.3 (5/10/2017)

* API structure updated to include 99.8 and 95 confidence intervals. Reflected in the outputs of `fingertips_data`. **NOTE** earlier versions of the package will not work anymore because of the underlying change in the API structure

# fingertipsR 0.1.2 (27/9/2017)

* fixed issue with rank and some `fingertips_data` queries

* removed dependency on tidyjson as a result of its removal from CRAN

# fingertipsR 0.1.1 (7/9/2017)

* `select_indicators()` allows user to point and click to select indicators

* stringsAsFactors parameter available in `fingertips_data()`

* automatically filter for `CategoryType = FALSE` in `fingertips_data()` - this can be set to `TRUE` if needed

* rank of area and polarity of indicator returned from `fingertips_data()` where `rank = TRUE` (polarity can also be found in `indicator_metadata()`)

* `fingertips_redred` highlights which areas are statistically different to comparator *and* trending in the wrong direction

* `category_types()` lookup function to support ordering where categories exist (eg, deprivation decile)

* `areatypes_by_indicators()` to help users determine which indicators are available for each area type (and vice versa)

* A new vignette demonstrating how some of the new functions can be used

# fingertipsR version 0.1.0 (17/6/2017)

This package allows the user to retrieve tables of:

* indicators, domains and profiles and their relationships to each other
* data related to indicators for geographies where the data are already available on the Fingertips website
* indicator metadata
* deprivation data for geographies that are available on the Fingertips website
