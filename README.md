
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
devtools::install_github("rOpenSci/fingertipsR",
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
#>   ProfileID ProfileName                 DomainID DomainName                
#>       <int> <chr>                          <int> <chr>                     
#> 1        19 Public Health Outcomes Fr~    1.00e6 Overarching indicators    
#> 2        19 Public Health Outcomes Fr~    1.00e6 Wider determinants of hea~
#> 3        19 Public Health Outcomes Fr~    1.00e6 Health improvement        
#> 4        19 Public Health Outcomes Fr~    1.00e6 Health protection         
#> 5        19 Public Health Outcomes Fr~    1.00e6 Healthcare and premature ~
#> 6        19 Public Health Outcomes Fr~    1.94e9 Supporting information
```

This table shows that the `ProfileID` for the Public Health Outcomes
Framework is 19. This can be used as an input for the `indicators()`
function:

``` r
profid <- 19
inds <- indicators(ProfileID = profid)
print(inds[grepl("Healthy", inds$IndicatorName), c("IndicatorID", "IndicatorName")])
#> # A tibble: 2 x 2
#>   IndicatorID IndicatorName                                                
#>         <int> <fct>                                                        
#> 1       90362 0.1i - Healthy life expectancy at birth                      
#> 2       92543 2.05ii - Proportion of children aged 2-2½yrs receiving ASQ-3~
```

Healthy Life Expectancy at Birth has the `IndicatorID` equal to 90362.

Finally, the data can be extracted using the `fingertips_data()`
function using that `IndicatorID`:

``` r
indid <- 90362
df <- fingertips_data(IndicatorID = indid)
head(df)
#>   IndicatorID                    IndicatorName ParentCode ParentName
#> 1       90362 Healthy life expectancy at birth       <NA>       <NA>
#> 2       90362 Healthy life expectancy at birth       <NA>       <NA>
#> 3       90362 Healthy life expectancy at birth  E92000001    England
#> 4       90362 Healthy life expectancy at birth  E92000001    England
#> 5       90362 Healthy life expectancy at birth  E92000001    England
#> 6       90362 Healthy life expectancy at birth  E92000001    England
#>    AreaCode                        AreaName AreaType    Sex      Age
#> 1 E92000001                         England  England   Male All ages
#> 2 E92000001                         England  England Female All ages
#> 3 E12000001               North East region   Region   Male All ages
#> 4 E12000002               North West region   Region   Male All ages
#> 5 E12000003 Yorkshire and the Humber region   Region   Male All ages
#> 6 E12000004            East Midlands region   Region   Male All ages
#>   CategoryType Category Timeperiod    Value LowerCI95.0limit
#> 1         <NA>     <NA>  2009 - 11 63.02647         62.87787
#> 2         <NA>     <NA>  2009 - 11 64.03794         63.88135
#> 3         <NA>     <NA>  2009 - 11 59.71114         59.19049
#> 4         <NA>     <NA>  2009 - 11 60.76212         60.39880
#> 5         <NA>     <NA>  2009 - 11 60.84033         60.38649
#> 6         <NA>     <NA>  2009 - 11 62.60207         62.07083
#>   UpperCI95.0limit LowerCI99.8limit UpperCI99.8limit Count Denominator
#> 1         63.17508               NA               NA    NA          NA
#> 2         64.19453               NA               NA    NA          NA
#> 3         60.23179               NA               NA    NA          NA
#> 4         61.12544               NA               NA    NA          NA
#> 5         61.29417               NA               NA    NA          NA
#> 6         63.13332               NA               NA    NA          NA
#>   Valuenote RecentTrend ComparedtoEnglandvalueorpercentiles
#> 1      <NA>        <NA>                        Not compared
#> 2      <NA>        <NA>                        Not compared
#> 3      <NA>        <NA>                               Worse
#> 4      <NA>        <NA>                               Worse
#> 5      <NA>        <NA>                               Worse
#> 6      <NA>        <NA>                             Similar
#>   ComparedtoRegionvalueorpercentiles TimeperiodSortable Newdata
#> 1                       Not compared           20090000    <NA>
#> 2                       Not compared           20090000    <NA>
#> 3                       Not compared           20090000    <NA>
#> 4                       Not compared           20090000    <NA>
#> 5                       Not compared           20090000    <NA>
#> 6                       Not compared           20090000    <NA>
#>   Comparedtogoal
#> 1           <NA>
#> 2           <NA>
#> 3           <NA>
#> 4           <NA>
#> 5           <NA>
#> 6           <NA>
```

## Use

Please see the vignettes for information on use.

``` r
browseVignettes("fingertipsR")
```

## More information

  - Please note that the ‘fingertipsR’ project is released with a
    [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing
    to this project, you agree to abide by its terms.
  - License: [GPL-3](https://opensource.org/licenses/GPL-3.0)

[![ropensci\_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
