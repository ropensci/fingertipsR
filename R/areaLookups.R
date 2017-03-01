#' @importFrom jsonlite fromJSON

areaLookups <- function(AreaCode){
        path <- "http://fingertips.phe.org.uk/api/"
        AreaCode <- paste(AreaCode, collapse = "%2C")
        areaLookups <- fromJSON(paste0(path,
                                       "areas/by_area_code?area_codes=",
                                       AreaCode))
}
