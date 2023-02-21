#' Retrieve data from a given Fingertips API url
#' @param api_path string; the API url to retrieve data from
#' @param proxy_settings string; whether to use Internet Explorer proxy settings
#'   ("default") or "none"
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config use_proxy
#' @importFrom curl ie_get_proxy_for_url
get_fingertips_api <- function(api_path, proxy_settings = "default") {
  match.arg(proxy_settings,
            c("default",
              "none"))

  if (proxy_settings == "default") {
    df <-  api_path %>%
      GET(
        use_proxy(
          ie_get_proxy_for_url(),
          username = "",
          password = "",
          auth = "ntlm")
      ) %>%
      content("text") %>%
      fromJSON(flatten = TRUE)
  } else {
    df <-  api_path %>%
      GET() %>%
      content("text") %>%
      fromJSON(flatten = TRUE)
  }
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
#' @param proxy_settings string; whether to use Internet Explorer proxy settings
#'   ("default") or "none"
#' @return \code{TRUE} if the API is available, otherwise \code{stop()} is called.
fingertips_ensure_api_available <- function(endpoint = fingertips_endpoint(),
                                            proxy_settings = "default") {
  code <- FALSE
  endpoint <- gsub("/api/", "", endpoint)

  match.arg(proxy_settings,
            c("default",
              "none"))
  if (proxy_settings == "default") {
    try({
      code <- httr::status_code(httr::GET(endpoint,
                                          use_proxy(ie_get_proxy_for_url(endpoint),
                                                    username = "",
                                                    password = "",
                                                    auth = "ntlm")))
    }, silent = TRUE)
  } else {
    try({
      code <- httr::status_code(httr::GET(endpoint))
    }, silent = TRUE)
  }


  if (code == 200) return(TRUE)

  errtext <- paste('The API is currently unavailable')

  stop(paste(errtext, collapse='\n  '), call. = FALSE)
}

#' fingertips_deframe
#'
#' @description mimic tibble::deframe() without needing to import the function
#' @param data list whose first item is a vector of names, and second item is a
#'   list. Items 1 and 2 must be equal length
fingertips_deframe <- function(data) {
  out <- structure(.Data = data[[2]],
                   .Names = data[[1]])
  return(out)
}
