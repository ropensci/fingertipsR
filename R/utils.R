#' Retrieve data from a given Fingertips API url
#' @param api_path string; the API url to retrieve data from
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config use_proxy
#' @importFrom curl ie_get_proxy_for_url
get_fingertips_api <- function(api_path) {
        df <- api_path %>%
                GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                content("text") %>%
                fromJSON(flatten = TRUE)
        return(df)
}

#' Add timestamp onto end of api url to prevent caching issues
#' @inheritParams get_fingertips_api
add_timestamp <- function(api_path) {
        api_path <- paste0(api_path,
                           "&timestamp=",
                           as.integer(Sys.time()))
        return(api_path)
}


default_api <- 'https://fingertips.phe.org.uk/api/'

#' Get the default fingertips API endpoint
#' @export
#' @return A character string with the HTTP URL of the Fingertips API
fingertips_endpoint <- function() default_api

#' Check if the given Fingertips API endpoint is available
#' @param endpoint string, the API base URL to check
#' @return \code{TRUE} if the API is available, otherwise \code{stop()} is called.
fingertips_ensure_api_available <- function(endpoint = fingertips_endpoint()) {
        code <- FALSE
        try({
                code <- httr::status_code(httr::GET(endpoint))
        }, silent = TRUE)

        if (code == 200) return(TRUE)

        errtext <- paste('The API at', endpoint, 'is currently unavailable.')
        if (code != FALSE) errtext <- paste0(errtext, ' (HTTP code ', code, ')')
        if (endpoint == default_api) {
                errtext <- c(errtext, 'If the issue persists, please notify profilefeedback@phe.gov.uk')
        }
        stop(paste(errtext, collapse='\n  '), call. = FALSE)
}
