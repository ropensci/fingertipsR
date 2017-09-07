#' Area types
#'
#' Outputs a data frame of area type ids, their descriptions, and how they map
#' to parent area types
#'
#' @return A data frame of area type ids and their descriptions
#' @param AreaTypeName Character vector, description of the area type; default
#'   is NULL
#' @param AreaTypeID Numeric vector, the Fingertips ID for the area type;
#'   default is NULL
#'
#' @examples # Returns a data frame with all levels of area and how they map to one another
#' @examples area_types()
#'
#' @examples # Returns a data frame of county and unitary authority mappings
#' @examples area_types("counties")
#'
#' @examples # Returns a table of both counties, district and unitary authorities and their respective mappings
#' @examples areas <- c("counties","district")
#' @examples area_types(areas)
#' @import dplyr
#' @import tidyjson
#' @importFrom jsonlite fromJSON
#' @importFrom stats complete.cases
#' @importFrom httr GET content set_config config
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{deprivation_decile}} for deprivation decile lookups and
#'   \code{\link{category_types}} for category lookups and
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups

area_types <- function(AreaTypeName = NULL, AreaTypeID = NULL){
        if (!(is.null(AreaTypeName)) & !(is.null(AreaTypeID))) {
                warning("AreaTypeName used when both AreaTypeName and AreaTypeID are entered")
        }
        path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))
        area_types <- paste0(path,"area_types") %>%
                GET %>%
                content("text") %>%
                fromJSON
        area_types <- area_types[,c("Id","Name")]
        names(area_types) <- c("AreaTypeID","AreaTypeName")
        parentAreas <- paste0(path,"area_types/parent_area_types") %>%
                GET %>%
                content("text") %>%
                gather_array %>%
                spread_values(Id = jstring("Id"),
                              Name = jstring("Name"),
                              Short = jstring("Short"))  %>%
                enter_object("ParentAreaTypes") %>%
                gather_array  %>%
                spread_values(ParentAreaID = jstring("Id"),
                              ParentAreaName = jstring("Name")) %>%
                select(Id,ParentAreaID,ParentAreaName) %>%
                rename(AreaTypeID = Id,
                       ParentAreaTypeID = ParentAreaID,
                       ParentAreaTypeName = ParentAreaName) %>%
                mutate(AreaTypeID = as.numeric(AreaTypeID),
                       ParentAreaTypeID = as.numeric(ParentAreaTypeID)) %>%
                data.frame()
        area_types <- left_join(area_types, parentAreas, by = c("AreaTypeID" = "AreaTypeID"))
        if (!is.null(AreaTypeName)) {
                AreaTypeName <- paste(AreaTypeName, collapse = "|")
                area_types <- area_types[grep(tolower(AreaTypeName),
                                              tolower(area_types$AreaTypeName)),]
        } else {
                if (!is.null(AreaTypeID)) {
                        area_types <- area_types[area_types$AreaTypeID %in% AreaTypeID,]
                }
        }
        return(area_types[complete.cases(area_types),])
}

#' Category types
#'
#' Outputs a data frame of category type ids, their name (along with a short name)
#'
#' @return A data frame of category type ids and their descriptions
#' @import dplyr
#' @import tidyjson
#' @importFrom jsonlite fromJSON
#' @importFrom purrr map_df
#' @importFrom httr GET content set_config config
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{deprivation_decile}} for deprivation decile lookups and
#'   \code{\link{area_types}} for area type lookups and
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups

category_types <- function() {
        path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))
        category_types <- paste0(path,"category_types") %>%
                GET %>%
                content("text") %>%
                fromJSON %>%
                pull(Categories) %>%
                map_df(rbind)
}

#' Area types by indicator
#'
#' Outputs a data frame of indicator ids and the area type ids that exist for that indicator
#'
#' @return A data frame of indicator ids and area type ids
#' @importFrom utils data
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{deprivation_decile}} for deprivation decile lookups and
#'   \code{\link{area_types}} for area type lookups and
#'   \code{\link{category_types}} for category type lookups
indicator_areatypes <- function() {
        data("areatypes_by_indicators", envir = environment())
        return(areatypes_by_indicators)
}
