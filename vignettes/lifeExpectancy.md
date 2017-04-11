---
title: "Plotting healthy life expectancy and life expectancy by deprivation for English local authorities"
author: "Seb Fox"
date: "2017-04-10"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Life expectancy by deprivation}
  %\VignetteEngine{knitr::knitr}
  %\VignetteEncoding{UTF-8}
---

This worked example attempts to document a common workflow a user might follow when using the `fingertipsR` package.

Suppose you want to plot healthy life expectancy and life expectancy by deprivation for a given year of data that fingertips contains - you will begin by wondering *where to start*.

## Where to start

There is one function in the `fingertipsR` package that extracts data from the Fingertips API: `fingertips_data()`. This function has the following inputs:

* IndicatorID
* AreaCode
* DomainID
* ProfileID
* AreaTypeID (this defaults to 102; County and Unitary Authority)
* ParentAreaTypeID (this defaults to 6; Government Office Region)

One of *IndicatorID*, *DomainID* or *ProfileID* must be complete. *AreaCode* needs completion if you are extracting data for a particular area or group of areas only. *AreaTypeID* determines the geography to extract the data for. In this case we want County and Unitary Authority level. *ParentAreaTypeID* requires an area type code that the *AreaTypeID* maps to.

Therefore, the inputs to the `fingertips_data` function that we need to find out are the ID codes for:

* IndicatorID 
* AreaTypeID
* ParentAreaTypeID

We need to begin by calling the `fingertipsR` package: 


## IndicatorID

There are two indicators we are interested in for this exercise. Without consulting the [Fingertips website](https://fingertips.phe.org.uk/  "Fingertips"), we know approximately what they are called:

* Healthy life expectancy
* Life expectancy

We can use the `indicators()` function to return a list of all the indicators within Fingertips. We can then filter the name field for the term *life expectancy* (note, the IndicatorName field has been converted to lower case in the following code chunk to ensure matches will not be overlooked as a result of upper case letters).


```r
inds <- indicators()
life_expectancy <- inds[grepl("life expectancy", tolower(inds$IndicatorName)),]

# Because the same indicators are used in multiple profiles, there are many repeated indicators in this table (some with varying IndicatorName but same IndicatorID)

# This returns a record for each IndicatorID
life_expectancy <- unique(life_expectancy[duplicated(life_expectancy$IndicatorID) == FALSE,
                                          c("IndicatorID", "IndicatorName")]) 
knitr::kable(life_expectancy, row.names = FALSE)
```



| IndicatorID|IndicatorName                                                                                                                                                                                                                                                                          |
|-----------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|       90362|Healthy life expectancy at birth: the average number of years a person would expect to live in good health based on contemporary mortality rates and prevalence of self-reported good health. (in PHOF 0.1i)                                                                           |
|       90364|Range in years. Slope index of inequality in life expectancy at birth within local authorities, based on local (LSOA) deprivation deciles: the range in years of life expectancy across the social gradient within each local authority, from most to least deprived. (in PHOF 0.2iii) |
|       90366|Life expectancy at birth: the average number of years a person would expect to live based on contemporary mortality rates. (in PHOF 0.1ii)                                                                                                                                             |
|       92031|Range in years. Slope index of inequality in healthy life expectancy within local authorities, based on deprivation within Middle Super Output Areas (MSOAs): the range in years of life expectancy across the social gradient within each local authority. (in PHOF 0.2vi)            |
|       91102|0.1ii - Life expectancy at 65: the average number of years a person would expect to live based on contemporary mortality rates.                                                                                                                                                        |
|       90365|0.2iv - The gap in years between overall life expectancy at birth in each English local authority and life expectancy at birth for England as a whole.                                                                                                                                 |
|         650|Life expectancy - MSOA based                                                                                                                                                                                                                                                           |
|       90363|0.2i - Slope index of inequality in life expectancy at birth based on national deprivation deciles within England: the range in years of life expectancy across the social gradient, from most to least deprived.                                                                      |
|       90823|0.2ii - Number of upper tier local authorities for which the local slope index of inequality in life expectancy (as defined in indicator 0.2iii) has decreased                                                                                                                         |
|       90825|0.2v - Slope index of inequality in healthy life expectancy at birth based on national deprivation deciles within England: the range in years of life expectancy across the social gradient, from most to least deprived.                                                              |
|       91319|0.2vii - Slope index of inequality in life expectancy at birth within English region, based on regional deprivation deciles: the range in years of life expectancy across the social gradient within each local authority, from most to least deprived.                                |

The two indicators we are interested in from this table are:

* 90362
* 90366

## AreaTypeID

We can work out what the *AreaTypeID* codes we are interested in using the function `area_types()`. We've decided that we want to produce the graph at County and Unitary Authority level. From the section [Where to start] we need codes for *AreaTypeID* and *ParentAreaTypeID.*













