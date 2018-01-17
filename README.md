
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/PublicHealthEngland/fingertipsR.svg)](https://travis-ci.org/PublicHealthEngland/fingertipsR) [![Coverage Status](https://coveralls.io/repos/github/PublicHealthEngland/fingertipsR/badge.svg?branch=master)](https://coveralls.io/github/PublicHealthEngland/fingertipsR?branch=master) [![](https://badges.ropensci.org/168_status.svg)](https://github.com/ropensci/onboarding/issues/168)

[![CRAN Status Badge](http://www.r-pkg.org/badges/version/fingertipsR)](https://cran.r-project.org/package=fingertipsR) [![CRAN Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/fingertipsR)](https://cran.r-project.org/package=fingertipsR) [![CRAN Monthly Downloads](http://cranlogs.r-pkg.org/badges/fingertipsR)](https://cran.r-project.org/package=fingertipsR)

fingertipsR
===========

This is an R package to interact with Public Health England's [Fingertips](http://fingertips.phe.org.uk/) data tool. Fingertips is a major public repository of population and public health indicators for England. The site presents the information in many ways to improve accessibility for a wide range of audiences ranging from public health professionals and researchers to the general public. The information presented is a mixture of data available from other public sources, and those that are available through user access agreements with other organisations. The source of each indicator presented is available using the `indicator_metadata()` function.

This package can be used to load data from the Fingertips API into R for further use.

Installation
------------

### CRAN

Get the latest released, stable version from CRAN:

``` r
install.packages("fingertipsR")
```

### With devtools

You can install the latest development version from github using [devtools](https://github.com/hadley/devtools):

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
#> # A tibble: 6 x 4
#>   ProfileID ProfileName                        DomainID DomainName        
#>       <int> <chr>                                 <int> <chr>             
#> 1        19 Public Health Outcomes Framework    1000049 Overarching indic~
#> 2        19 Public Health Outcomes Framework    1000041 Wider determinant~
#> 3        19 Public Health Outcomes Framework    1000042 Health improvement
#> 4        19 Public Health Outcomes Framework    1000043 Health protection 
#> 5        19 Public Health Outcomes Framework    1000044 Healthcare and pr~
#> 6        19 Public Health Outcomes Framework 1938132983 Supporting inform~
```

This table shows that the `ProfileID` for the Public Health Outcomes Framework is 19. This can be used as an input for the `indicators()` function:

``` r
profid <- 19
inds <- indicators(ProfileID = profid)
print(inds[grepl("Healthy", inds$IndicatorName), c("IndicatorID", "IndicatorName")])
#> # A tibble: 2 x 2
#>   IndicatorID IndicatorName                                               
#>         <int> <fctr>                                                      
#> 1       90362 0.1i - Healthy life expectancy at birth: the average number~
#> 2       92543 "2.05ii - Proportion of children aged 2-2\u00bdyrs offered ~
```

Healthy Life Expectancy at Birth has the `IndicatorID` equal to 90362.

Finally, the data can be extracted using the `fingertips_data()` function using that `IndicatorID`:

``` r
indid <- 90362
df <- fingertips_data(IndicatorID = indid)
head(df)
#> # A tibble: 6 x 24
#>   Indic~ Indi~ Pare~ Pare~ Area~ Area~ Area~ Sex   Age   Cate~ Cate~ Time~
#>    <int> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr>
#> 1  90362 0.1i~ <NA>  <NA>  E920~ Engl~ Coun~ Male  All ~ <NA>  <NA>  2009~
#> 2  90362 0.1i~ <NA>  <NA>  E920~ Engl~ Coun~ Fema~ All ~ <NA>  <NA>  2009~
#> 3  90362 0.1i~ E920~ Engl~ E120~ Nort~ Regi~ Male  All ~ <NA>  <NA>  2009~
#> 4  90362 0.1i~ E920~ Engl~ E120~ Nort~ Regi~ Male  All ~ <NA>  <NA>  2009~
#> 5  90362 0.1i~ E920~ Engl~ E120~ York~ Regi~ Male  All ~ <NA>  <NA>  2009~
#> 6  90362 0.1i~ E920~ Engl~ E120~ East~ Regi~ Male  All ~ <NA>  <NA>  2009~
#> # ... with 12 more variables: Value <dbl>, LowerCI95.0limit <dbl>,
#> #   UpperCI95.0limit <dbl>, LowerCI99.8limit <dbl>, UpperCI99.8limit
#> #   <dbl>, Count <dbl>, Denominator <dbl>, Valuenote <chr>, RecentTrend
#> #   <chr>, ComparedtoEnglandvalueorpercentiles <chr>,
#> #   Comparedtosubnationalparentvalueorpercentiles <chr>,
#> #   TimeperiodSortable <int>
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
