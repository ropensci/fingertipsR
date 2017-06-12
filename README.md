
<!-- README.md is generated from README.Rmd. Please edit that file -->
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
#> 1        19 Public Health Outcomes Framework    1000041
#> 2        19 Public Health Outcomes Framework    1000042
#> 3        19 Public Health Outcomes Framework    1000043
#> 4        19 Public Health Outcomes Framework    1000044
#> 5        19 Public Health Outcomes Framework    1000049
#> 6        19 Public Health Outcomes Framework 1938132983
#>                           DomainName
#> 1       Wider determinants of health
#> 2                 Health improvement
#> 3                  Health protection
#> 4 Healthcare and premature mortality
#> 5             Overarching indicators
#> 6             Supporting information
```

Use
---

Please see the vignette for information on use.

``` r
vignette("lifeExpectancy")
```
