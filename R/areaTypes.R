#' Area types
#'
#' Outputs a data frame of area type ids and their descriptions
#' @return A data frame of area type ids and their descriptions
#' @import jsonlite
#' @export

areaTypes <- function(){
        path <- "http://fingertips.phe.org.uk/api/"
        areaTypes <- fromJSON(paste0(path,
                                     "area_types"))
        areaTypes <- areaTypes[,c("Id","Name")]
        names(areaTypes) <- c("AreaID","AreaName")
        return(areaTypes)
}
