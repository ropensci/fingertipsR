#' fingertipsR: A package for extracting the data behind the Fingertips website
#' (\url{fingertips.phe.gov.uk})
#'
#'
#' The fingertipsR package provides two categories of important functions: lookup
#' and data extract.
#'
#' @section Lookup functions: The lookup functions are to provide users the
#'   ability to understand the ID inputs for the data extract functions.
#' @section Data extract functions: Using ID codes as inputs, the data extract
#'   functions allow the user to extract data from the Fingertips API.
#'
#' @docType package
#' @name fingertipsR
NULL
globalVariables(c("Id",
                  "ParentAreaID",
                  "ParentAreaName",
                  "ParentAreaTypeID",
                  "AreaID",
                  "AreaType",
                  "AreaCode",
                  "Value",
                  "IMDscore",
                  "IndicatorID",
                  "IndicatorName",
                  "ID",
                  "Name",
                  "groupid",
                  "DomainName",
                  "ProfileName",
                  "CategoryType"))
