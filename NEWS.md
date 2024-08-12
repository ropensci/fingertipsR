# fingertipsR 1.0.13 (2023-07-12)

* Added checks to handle cases where no data is available for the specified combination of parameters in `fingertips_data()`.
* When no data is available and `rank = TRUE`, the function now returns an empty data frame with `Polarity`, `Rank`, and `AreaValuesCount` columns set to `NA`.
* Improved error message to inform users that no data is available and an empty data frame is returned.

# fingertipsR 1.0.12 (2023-17-11)

* Automatically detects proxy settings in each function.  

# fingertipsR 1.0.11 (2023-09-11)

* Provision of ability to turn off automatic proxy settings using internet explorer's settings using `proxy_settings` argument
* bug fix to allow `rank = TRUE` when multiple ProfileIDs and IndicatorIDs passed to `fingertips_data()`
* `get_fingertips_api()` exported from package
* bug fix so `indicator_update_information()` works when an indicator is included without any update dates
* changed package maintainer

# fingertipsR 1.0.10 (2023-01-30)

* Bug fixed where character field has entirely missing values it defaulted to NA instead of ""
* Bug fix to allow indicator_update_information() to accept a long vector of IndicatorID

# fingertipsR 1.0.9 (2022-06-09)

* Bug fixes for indicators() function where many groups exist
* Fixed bug around class of the new `Time period range` field; now ensured to be a character field
* included indicator_update_information() to provide users with details of when the indicator was last updated (available from 7th June 2022)
* updated installation instructions in README

# fingertipsR 1.0.8 (2022-01-06)

* Fixed issue introduced to `fingertips_data()` where `AreaTypeID = "All"`
* More `AreaTypeID`s available for `nearest_neighbour()`
* `nearest_neighbour_areatypeids()` added

# fingertipsR 1.0.7 (2021-07-15)

* No change to previous version

# fingertipsR 1.0.6 (2021-05-17)

* fixed warning message for multiple IndicatorIDs passed to indicator_metadata()
* fixed bug in indicator_metadata(IndicatorID = "All") - thanks Luke Bradley for pointing it out
* indicator_metadata now includes `Impact of COVID19 field`

# fingertipsR 1.0.5 (2020-09-16)

* `indicator_metadata()` accepts `IndicatorID = "All"` 
* GitHub actions added

# fingertipsR 1.0.4 (2020-06-06)

* no change for users

# fingertipsR 1.0.3 (2020-04-16)

* fixed `fingertips_data()` bug introduced in 1.0.2 where multiple IndicatorIDs and ProfileIDs are provided

# fingertipsR 1.0.2 (2020-02-09)

* Bug fix for `fingertips_data()` where `AreaTypeID = "All"

# fingertipsR 1.0.1 (2020-01-28)

* Improved flexibility of `deprivation_decile()` so new deprivation data can be drawn from website without being added to the package
* url_only argument added to `fingertips_data()` function, allowing user to retrieve the API url(s) used to download their data

# fingertipsR 1.0.0 (2020-01-08)

* default value for `AreaTypeID` in `fingertips_data()` and `deprivation_decile()` removed (along with a helpful error message if `AreaTypeID` is missing)
* progress bar added when AreaTypeID = "All" in `fingertips_data()`
* fixed issue where GP deprivation_decile returned data with 0 records
* added more allowable AreaTypes to `deprivation_decile()` function
* added 2019 year to `deprivation_decile()`
* `AreaTypeID = "All"` in `fingertips_data()` function now faster and accurate for specific profile

 
# fingertipsR 0.2.9 (2019-09-25)

* fixed issue caused by v0.2.8 for users behind organisational firewall

# fingertipsR 0.2.8 (2019-09-09)

* functions will provide informative message when they fail because of no response from the API

# fingertipsR 0.2.7 (2019-07-18)
 * Added option for `AreaTypeID = "All"` in `fingertips_data()`
 * Added `ProfileID` argument to `area_types()` function
 * `category_types()` returns field called `CategoryType` which is joinable to `fingertips_data()` output when `categorytype = TRUE`
 * Added a retry function to handle occasions when the API times out when it shouldn't

# fingertipsR 0.2.6 (2019-06-07)

* fixed `indicator_order()` function

* `nearest_neighbours()` now allows AreaTypeID 154 (CCG unchanged plus new 2018), but no longer allows AreaTypeID 153

* `nearest_neighbours()` function has been fixed

# fingertipsR 0.2.4 (2019-05-19)

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
