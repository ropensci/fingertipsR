#' fingertips: A package for extracting the data behind the Fingertips website
#' (\url{fingertips.phe.gov.uk})
#'
#'
#' The fingertips package provides two categories of important functions: lookup
#' and data extract.
#'
#' @section Lookup functions: The lookup functions are to provide users the
#'   ablity to understand the ID inputs for the data extract functions.
#' @section Data extract functions: Using ID codes as inputs, the data extract
#'   functions allow the user to extract data from the Fingertips API.
#'
#' @docType package
#' @name fingertipsR
NULL
## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
