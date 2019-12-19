
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Build
Status](https://travis-ci.org/ropensci/fingertipsR.svg)](https://travis-ci.org/ropensci/fingertipsR)
[![Coverage
Status](https://coveralls.io/repos/github/ropensci/fingertipsR/badge.svg?branch=master)](https://coveralls.io/github/ropensci/fingertipsR?branch=master)
[![](https://badges.ropensci.org/168_status.svg)](https://github.com/ropensci/onboarding/issues/168)

[![CRAN Status
Badge](http://www.r-pkg.org/badges/version/fingertipsR)](https://cran.r-project.org/package=fingertipsR)
[![CRAN Total
Downloads](http://cranlogs.r-pkg.org/badges/grand-total/fingertipsR)](https://cran.r-project.org/package=fingertipsR)
[![CRAN Monthly
Downloads](http://cranlogs.r-pkg.org/badges/fingertipsR)](https://cran.r-project.org/package=fingertipsR)

# fingertipsR

This is an R package to interact with Public Health England’s
[Fingertips](http://fingertips.phe.org.uk/) data tool. Fingertips is a
major public repository of population and public health indicators for
England. The site presents the information in many ways to improve
accessibility for a wide range of audiences ranging from public health
professionals and researchers to the general public. The information
presented is a mixture of data available from other public sources, and
those that are available through user access agreements with other
organisations. The source of each indicator presented is available using
the `indicator_metadata()` function.

This package can be used to load data from the Fingertips API into R for
further use.

## Installation

### CRAN

Get the latest released, stable version from CRAN:

``` r
install.packages("fingertipsR")
```

### With devtools

You can install the latest development version from github using
[devtools](https://github.com/hadley/devtools):

``` r
# install.packages("devtools")
remotes::install_github("rOpenSci/fingertipsR",
                        build_vignettes = TRUE,
                        dependencies = "suggests")
```

### From zip

Download this repository from GitHub and either build from source or do
the following, that also requires
[devtools](https://github.com/hadley/devtools):

``` r
source <- devtools:::source_pkg("C:/path/to/fingertipsR-master")
install(source)
```

### Base R instructions

To install the package without the use of CRAN or
[devtools](https://github.com/hadley/devtools), download the `.tar.gz`
file and then run:

``` r
install.packages(path_to_file, repos = NULL, type="source")
```

Where `path_to_file` would represent the full path and file name.

## Example

This is an example of a workflow for downloading data for the indicator
on *Healthy Life Expectancy at Birth* from the *Public Health Outcomes
Framework* profile.

The `profiles()` function presents all of the available profiles:

``` r
library(fingertipsR)
profs <- profiles()
profs <- profs[grepl("Public Health Outcomes Framework", profs$ProfileName),]
head(profs)
#> # A tibble: 6 x 4
#>   ProfileID ProfileName                   DomainID DomainName                   
#>       <int> <chr>                            <int> <chr>                        
#> 1        19 Public Health Outcomes Fra~    1000049 A. Overarching indicators    
#> 2        19 Public Health Outcomes Fra~    1000041 B. Wider determinants of hea~
#> 3        19 Public Health Outcomes Fra~    1000042 C. Health improvement        
#> 4        19 Public Health Outcomes Fra~    1000043 D. Health protection         
#> 5        19 Public Health Outcomes Fra~    1000044 E. Healthcare and premature ~
#> 6        19 Public Health Outcomes Fra~ 1938132983 Supporting information
```

This table shows that the `ProfileID` for the Public Health Outcomes
Framework is 19. This can be used as an input for the `indicators()`
function:

``` r
profid <- 19
inds <- indicators(ProfileID = profid)
print(inds[grepl("Healthy", inds$IndicatorName), c("IndicatorID", "IndicatorName")])
#> # A tibble: 1 x 2
#>   IndicatorID IndicatorName                          
#>         <int> <fct>                                  
#> 1       90362 A01a - Healthy life expectancy at birth
```

Healthy Life Expectancy at Birth has the `IndicatorID` equal to 90362.

Finally, the data can be extracted using the `fingertips_data()`
function using that `IndicatorID`:

``` r
indid <- 90362
df <- fingertips_data(IndicatorID = indid, AreaTypeID = 202)
head(df)
#>   IndicatorID                    IndicatorName ParentCode ParentName  AreaCode
#> 1       90362 Healthy life expectancy at birth       <NA>       <NA> E92000001
#> 2       90362 Healthy life expectancy at birth       <NA>       <NA> E92000001
#> 3       90362 Healthy life expectancy at birth  E92000001    England E12000001
#> 4       90362 Healthy life expectancy at birth  E92000001    England E12000002
#> 5       90362 Healthy life expectancy at birth  E92000001    England E12000003
#> 6       90362 Healthy life expectancy at birth  E92000001    England E12000004
#>                          AreaName AreaType    Sex      Age CategoryType
#> 1                         England  England   Male All ages         <NA>
#> 2                         England  England Female All ages         <NA>
#> 3               North East region   Region   Male All ages         <NA>
#> 4               North West region   Region   Male All ages         <NA>
#> 5 Yorkshire and the Humber region   Region   Male All ages         <NA>
#> 6            East Midlands region   Region   Male All ages         <NA>
#>   Category Timeperiod    Value LowerCI95.0limit UpperCI95.0limit
#> 1     <NA>  2009 - 11 63.02647         62.87787         63.17508
#> 2     <NA>  2009 - 11 64.03794         63.88135         64.19453
#> 3     <NA>  2009 - 11 59.71114         59.19049         60.23179
#> 4     <NA>  2009 - 11 60.76212         60.39880         61.12544
#> 5     <NA>  2009 - 11 60.84033         60.38649         61.29417
#> 6     <NA>  2009 - 11 62.60207         62.07083         63.13332
#>   LowerCI99.8limit UpperCI99.8limit Count Denominator Valuenote RecentTrend
#> 1               NA               NA    NA          NA      <NA>        <NA>
#> 2               NA               NA    NA          NA      <NA>        <NA>
#> 3               NA               NA    NA          NA      <NA>        <NA>
#> 4               NA               NA    NA          NA      <NA>        <NA>
#> 5               NA               NA    NA          NA      <NA>        <NA>
#> 6               NA               NA    NA          NA      <NA>        <NA>
#>   ComparedtoEnglandvalueorpercentiles ComparedtoRegionvalueorpercentiles
#> 1                        Not compared                       Not compared
#> 2                        Not compared                       Not compared
#> 3                               Worse                       Not compared
#> 4                               Worse                       Not compared
#> 5                               Worse                       Not compared
#> 6                             Similar                       Not compared
#>   TimeperiodSortable Newdata Comparedtogoal
#> 1           20090000    <NA>           <NA>
#> 2           20090000    <NA>           <NA>
#> 3           20090000    <NA>           <NA>
#> 4           20090000    <NA>           <NA>
#> 5           20090000    <NA>           <NA>
#> 6           20090000    <NA>           <NA>
```

## Use

Please see the vignettes for information on use.

``` r
browseVignettes("fingertipsR")
```

## More information

  - Please note that the ‘fingertipsR’ project is released with a
    [Contributor Code of
    Conduct](https://github.com/ropensci/fingertipsR/blob/master/CODE_OF_CONDUCT.md).
    By contributing to this project, you agree to abide by its terms.
  - License: [GPL-3](https://opensource.org/licenses/GPL-3.0)

[![ropensci\_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
