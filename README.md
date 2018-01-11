
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/PublicHealthEngland/fingertipsR.svg)](https://travis-ci.org/PublicHealthEngland/fingertipsR.svg?branch=master) [![Coverage Status](https://coveralls.io/repos/github/PublicHealthEngland/fingertipsR/badge.svg?branch=master)](https://coveralls.io/github/PublicHealthEngland/fingertipsR?branch=master) [![](https://badges.ropensci.org/168_status.svg)](https://github.com/ropensci/onboarding/issues/168)

[![CRAN Status Badge](http://www.r-pkg.org/badges/version/fingertipsR)](https://cran.r-project.org/package=fingertipsR) [![CRAN Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/fingertipsR)](https://cran.r-project.org/package=fingertipsR) [![CRAN Monthly Downloads](http://cranlogs.r-pkg.org/badges/fingertipsR)](https://cran.r-project.org/package=fingertipsR)

fingertipsR
===========

This is an R package to interact with Public Health England's [Fingertips](http://fingertips.phe.org.uk/) data tool. Fingertips is a major public repository of population and public health indicators for England. The site presents the information in many ways to improve accesibility for a wide range of audiences ranging from public health professionals and researchers to the general public. This package can be used to load data from the Fingertips API into R for further use.

Installation
------------

### CRAN

Get the latest released, stable version from CRAN:

`{ r CRAN install, eval=FALSE} install.packages("fingertipsR")`

### With devtools

You can install the latest development version from github unsing [devtools](https://github.com/hadley/devtools):

``` r
# install.packages("devtools")
devtools::install_github("PublicHealthEngland/fingertipsR",
                         build_vignettes = TRUE,
                         dependencies = "suggests")
```

### From zip

Download this repository from GitHub and either build from source or do the following, that also requires [devtools](https://github.com/hadley/devtools):

``` r
source <- devtools:::source_pkg("C:/path/to/fingertips-master")
install(source)
```

### Base R instructions

To install the package without the use of CRAN or [devtools](https://github.com/hadley/devtools), download the `.tar.gz` file and then run:

``` r
install.packages(path_to_file, repos = NULL, type="source")
```

Where `path_to_file` would represent the full path and file name.

Example
-------

This is an example of a workflow for downloading data for the indicator on *Healthy Life Expectancy at Birth* from the *Public Health Outcomes Framework* profile.

The `profiles()` function presents all of the available profiles:

``` r
library(fingertipsR)
profs <- profiles()
profs <- profs[grepl("Public Health Outcomes Framework", profs$ProfileName),]
head(profs)
#>    ProfileID                      ProfileName   DomainID
#> 22        19 Public Health Outcomes Framework    1000049
#> 23        19 Public Health Outcomes Framework    1000041
#> 24        19 Public Health Outcomes Framework    1000042
#> 25        19 Public Health Outcomes Framework    1000043
#> 26        19 Public Health Outcomes Framework    1000044
#> 27        19 Public Health Outcomes Framework 1938132983
#>                            DomainName
#> 22             Overarching indicators
#> 23       Wider determinants of health
#> 24                 Health improvement
#> 25                  Health protection
#> 26 Healthcare and premature mortality
#> 27             Supporting information
```

This table shows that the `ProfileID` for the Public Health Outcomes Framework is 19. This can be used as an input for the `indicators()` function:

``` r
profid <- 19
inds <- indicators(ProfileID = profid)
print(inds[grepl("Healthy", inds$IndicatorName), c("IndicatorID", "IndicatorName")])
#>     IndicatorID
#> 122       92543
#> 168       90362
#>                                                                                                                                                                                            IndicatorName
#> 122                                                                               2.05ii - Proportion of children aged 2-2½yrs offered ASQ-3 as part of the Healthy Child Programme or integrated review
#> 168 0.1i - Healthy life expectancy at birth: the average number of years a person would expect to live in good health based on contemporary mortality rates and prevalence of self-reported good health.
```

Healthy Life Expectancy at Birth has the `IndicatorID` equal to 90362.

Finally, the data can be extracted using the `fingertips_data()` function using that `IndicatorID`:

``` r
indid <- 90362
df <- fingertips_data(IndicatorID = indid)
head(df)
#>   IndicatorID                           IndicatorName ParentCode
#> 1       90362 0.1i - Healthy life expectancy at birth       <NA>
#> 2       90362 0.1i - Healthy life expectancy at birth       <NA>
#> 3       90362 0.1i - Healthy life expectancy at birth  E92000001
#> 4       90362 0.1i - Healthy life expectancy at birth  E92000001
#> 5       90362 0.1i - Healthy life expectancy at birth  E92000001
#> 6       90362 0.1i - Healthy life expectancy at birth  E92000001
#>   ParentName  AreaCode                        AreaName AreaType    Sex
#> 1       <NA> E92000001                         England  Country   Male
#> 2       <NA> E92000001                         England  Country Female
#> 3    England E12000001               North East region   Region   Male
#> 4    England E12000002               North West region   Region   Male
#> 5    England E12000003 Yorkshire and the Humber region   Region   Male
#> 6    England E12000004            East Midlands region   Region   Male
#>        Age CategoryType Category Timeperiod    Value LowerCI95.0limit
#> 1 All ages         <NA>     <NA>  2009 - 11 63.03181         62.88849
#> 2 All ages         <NA>     <NA>  2009 - 11 64.07049         63.92063
#> 3 All ages         <NA>     <NA>  2009 - 11 59.74471         59.22943
#> 4 All ages         <NA>     <NA>  2009 - 11 60.77587         60.41411
#> 5 All ages         <NA>     <NA>  2009 - 11 60.84513         60.39213
#> 6 All ages         <NA>     <NA>  2009 - 11 62.61274         62.08066
#>   UpperCI95.0limit LowerCI99.8limit UpperCI99.8limit Count Denominator
#> 1         63.17513               NA               NA    NA          NA
#> 2         64.22036               NA               NA    NA          NA
#> 3         60.26000               NA               NA    NA          NA
#> 4         61.13762               NA               NA    NA          NA
#> 5         61.29812               NA               NA    NA          NA
#> 6         63.14483               NA               NA    NA          NA
#>   Valuenote RecentTrend ComparedtoEnglandvalueorpercentiles
#> 1      <NA>        <NA>                        Not compared
#> 2      <NA>        <NA>                        Not compared
#> 3      <NA>        <NA>                        Not compared
#> 4      <NA>        <NA>                        Not compared
#> 5      <NA>        <NA>                        Not compared
#> 6      <NA>        <NA>                        Not compared
#>   Comparedtosubnationalparentvalueorpercentiles TimeperiodSortable
#> 1                                  Not compared           20090000
#> 2                                  Not compared           20090000
#> 3                                  Not compared           20090000
#> 4                                  Not compared           20090000
#> 5                                  Not compared           20090000
#> 6                                  Not compared           20090000
```

Use
---

Please see the vignettes for information on use.

``` r
browseVignettes("fingertipsR")
```

More
----

-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms
-   License: [GPL-3](https://opensource.org/licenses/GPL-3.0)
