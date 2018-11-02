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
