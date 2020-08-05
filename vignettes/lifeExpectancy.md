---
title: "Plotting healthy life expectancy and life expectancy by deprivation for English local authorities"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Life expectancy by deprivation}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

This worked example attempts to document a common workflow a user might follow when using the `fingertipsR` package.

`fingertipsR` provides users the ability to import data from the [Fingertips](http://fingertips.phe.org.uk/) website. Fingertips is a major repository of public health indicators in England. The site is structured in the following way:

* Profiles - these contain indicators related to a broad theme (such as a risk factor or a disease topic etc)
* Domains - these are subcategories of profiles, and break the profiles down to themes within the broader theme
* Indicators - this is the lowest level of the structure and sit within the domains. Indicators are presented at different time periods, geographies, sexes, ageband and categories.

This example demonstrates how you can plot healthy life expectancy and life expectancy by geographical regions for a given year of data that fingertips contains. So, *where to start*?

## Where to start

There is one function in the `fingertipsR` package that extracts data from the Fingertips API: `fingertips_data()`. This function has the following inputs:

* IndicatorID
* AreaCode
* DomainID
* ProfileID
* AreaTypeID
* ParentAreaTypeID1

At least one of *IndicatorID*, *DomainID* or *ProfileID* must be complete. These fields relate to each other as described in the introduction. *AreaTypeID* is also required, and determines the geography for which data is extracted. In this case we want County and Unitary Authority level. *AreaCode* needs completing if you are extracting data for a particular area or group of areas only. *ParentAreaTypeID* requires an area type code that the *AreaTypeID* maps to at a higher level of geography. For example, County and Unitary Authorities map to a higher level of geography called Government Office Regions. These mappings can be identified using the `area_types()` function. If ignored, a *ParentAreaTypeID* will be chosen automatically.

Therefore, the inputs to the `fingertips_data` function that we need to find out are the ID codes for:

* IndicatorID 
* AreaTypeID
* ParentAreaTypeID

We need to begin by calling the `fingertipsR` package: 

```r
library(fingertipsR)
```

## IndicatorID

There are two indicators we are interested in for this exercise. Without consulting the [Fingertips website](https://fingertips.phe.org.uk/  "Fingertips"), we know approximately what they are called:

* Healthy life expectancy
* Life expectancy

We can use the `indicators()` function to return a list of all the indicators within Fingertips. We can then filter the name field for the term *life expectancy* (note, the IndicatorName field has been converted to lower case in the following code chunk to ensure matches will not be overlooked as a result of upper case letters).


```r
inds <- indicators_unique()
life_expectancy <- inds[grepl("life expectancy", tolower(inds$IndicatorName)),]
```


| IndicatorID|IndicatorName                                                                       |
|-----------:|:-----------------------------------------------------------------------------------|
|       90362|Healthy life expectancy at birth                                                    |
|       90366|Life expectancy at birth                                                            |
|       90825|Inequality in healthy life expectancy at birth ENGLAND                              |
|       91102|Life expectancy at 65                                                               |
|       92031|Inequality in healthy life expectancy at birth LA                                   |
|       92901|Inequality in life expectancy at birth                                              |
|       93190|Inequality in life expectancy at 65                                                 |
|       93505|Healthy life expectancy at 65                                                       |
|       93523|Disability-free life expectancy at 65                                               |
|       93562|Disability-free life expectancy at birth                                            |
|         650|Life expectancy - MSOA based                                                        |
|       93249|Disability free life expectancy, (Upper age band 85+)                               |
|       93283|Life expectancy at birth, (upper age band 90+)                                      |
|       93285|Life expectancy at birth, (upper age band 85+)                                      |
|       93298|Healthy life expectancy, (upper age band 85+)                                       |
|       92641|Life expectancy at 75 (SPOT: NHSOD 1b)                                              |
|       90365|Gap in life expectancy at birth between each local authority and England as a whole |

The two indicators we are interested in from this table are:

* 90362
* 90366

## AreaTypeID

We can work out what the *AreaTypeID* codes we need using the function `area_types()`. We've decided that we want to produce the graph at County and Unitary Authority level. From the section [Where to start] we need codes for *AreaTypeID* and *ParentAreaTypeID.*


```r
areaTypes <- area_types()
```













