#' @importFrom jsonlite fromJSON

area_lookup <- function(AreaCode){
        path <- "http://fingertips.phe.org.uk/api/"
        AreaCode <- paste(AreaCode, collapse = "%2C")
        area_lookup <- fromJSON(paste0(path,
                                       "areas/by_area_code?area_codes=",
                                       AreaCode))
}

sex_lookup <- function() {
        path <- "http://fingertips.phe.org.uk/api/"
        sex_lookup <- fromJSON(paste0(path,"sexes"))
        names(sex_lookup)[2] <- "Sex"
        return(sex_lookup)
}

age_lookup <- function() {
        path <- "http://fingertips.phe.org.uk/api/"
        age_lookup <- fromJSON(paste0(path,"ages"))
        names(age_lookup)[2] <- "Age"
        return(age_lookup)
}
