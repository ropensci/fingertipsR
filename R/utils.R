#' Retrieve data from a given Fingertips API url
#' @param api_path string; the API url to retrieve data from
#' @param proxy_settings string; whether to use Internet Explorer proxy settings
#'   ("default") or "none"
#' @param content_type string; "text" or "parsed"
#' @param col_types character; vector of column classes
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config use_proxy
#' @importFrom curl ie_get_proxy_for_url
#' @export
#' @examples
#' df <- get_fingertips_api(
#'   api_path = paste0(
#'     fingertips_endpoint(),
#'     "/area/parent_areas?child_area_code=E12000005&parent_area_type_ids=15"))
get_fingertips_api <- function(api_path, content_type = "text",
                               col_types,
                               proxy_settings = fingertips_proxy_settings()) {
  match.arg(proxy_settings,
            c("default",
              "none"))

  match.arg(content_type,
            c("text", "parsed"))

  if (content_type == "parsed") {
    if (missing(col_types))
      stop("With content_type == 'text', col_types must be provided")
  }

  if (proxy_settings == "default") {
    if (content_type == "text") {
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
      df <- api_path %>%
        GET(use_proxy(ie_get_proxy_for_url(),
                      username = "",
                      password = "",
                      auth = "ntlm")) %>%
        content("parsed",
                type = "text/csv",
                encoding = "UTF-8",
                col_types = col_types)
    }

  } else {
    if (content_type == "text") {
      df <-  api_path %>%
        GET() %>%
        content("text") %>%
        fromJSON(flatten = TRUE)
    } else {
      df <-  api_path %>%
        GET() %>%
        content("parsed",
                type = "text/csv",
                encoding = "UTF-8",
                col_types = col_types)
    }

  }
  return(df)
}

#' Add timestamp onto end of api url to prevent caching issues
#' @inheritParams get_fingertips_api
#' @noRd
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
#' @noRd
fingertips_ensure_api_available <- function(endpoint = fingertips_endpoint(),
                                            proxy_settings = fingertips_proxy_settings()) {
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
#' @noRd
fingertips_deframe <- function(data) {
  out <- structure(.Data = data[[2]],
                   .Names = data[[1]])
  return(out)
}


#' fingertips_proxy_settings
#' @description determines which proxy settings are used
#' @return A character string with the proxy settings
#' @noRd
fingertips_proxy_settings <- function() {

  # First try using default as proxy settings
  fingertips_proxy <- "default"
  errtext <- tryCatch(
    {
      fingertips_ensure_api_available(proxy_settings = "default")
    }, error=function(e) {"The API is currently unavailable."}
  )

  # Second try using "none" as proxy settings
  if (errtext != TRUE) {
    fingertips_proxy <- "none"
    errtext <- tryCatch(
      {
        fingertips_ensure_api_available(proxy_settings = "none")
      }, error=function(e) {"The API is currently unavailable."}
    )

    # Stop if neither settings work
    if (errtext != TRUE) {
      stop(paste(errtext, collapse='\n  '), call. = FALSE)
    }
  }
  return(fingertips_proxy)
}
