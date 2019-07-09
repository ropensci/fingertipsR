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


