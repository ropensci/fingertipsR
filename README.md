
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/PublicHealthEngland/fingertipsR.svg)](https://travis-ci.org/PublicHealthEngland/fingertipsR.svg?branch=master) [![Coverage Status](https://coveralls.io/repos/github/PublicHealthEngland/fingertipsR/badge.svg?branch=master)](https://coveralls.io/github/PublicHealthEngland/fingertipsR?branch=master) [![](https://badges.ropensci.org/168_status.svg)](https://github.com/ropensci/onboarding/issues/168)

[![CRAN Status Badge](http://www.r-pkg.org/badges/version/fingertipsR)](https://cran.r-project.org/package=fingertipsR) [![CRAN Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/fingertipsR)](https://cran.r-project.org/package=fingertipsR) [![CRAN Monthly Downloads](http://cranlogs.r-pkg.org/badges/fingertipsR)](https://cran.r-project.org/package=fingertipsR)

fingertipsR
===========

This is an R package to interact with Public Health England's [Fingertips](http://fingertips.phe.org.uk/) data tool. This can be used to load data from the Fingertips API into R for further manipulation.

Installation
------------

### From zip

Download this repository from GitHub and either build from source or do:

``` r
source <- devtools:::source_pkg("C:/path/to/fingertips-master")
install(source)
```

### With devtools

You can install the latest version of fingertipsR from github with:

``` r
# install.packages("devtools")
devtools::install_github("PublicHealthEngland/fingertipsR")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
library(fingertipsR)
df <- profiles(ProfileName = "Public Health Outcomes Framework")
print(df)
#>   ProfileID                      ProfileName   DomainID
#> 1        19 Public Health Outcomes Framework    1000049
#> 2        19 Public Health Outcomes Framework    1000041
#> 3        19 Public Health Outcomes Framework    1000042
#> 4        19 Public Health Outcomes Framework    1000043
#> 5        19 Public Health Outcomes Framework    1000044
#> 6        19 Public Health Outcomes Framework 1938132983
#>                           DomainName
#> 1             Overarching indicators
#> 2       Wider determinants of health
#> 3                 Health improvement
#> 4                  Health protection
#> 5 Healthcare and premature mortality
#> 6             Supporting information
```

Use
---

Please see the vignettes for information on use.

``` r
browseVignettes("fingertipsR")
```
