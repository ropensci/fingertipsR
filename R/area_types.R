#' Area types
#'
#' Outputs a data frame of area type ids, their descriptions, and how they map
#' to parent area types. To understand more on mappings of areas, see the Where
#' to start section of the Life Expectancy vignette.
#'
#' @return A data frame of area type ids and their descriptions
#' @param AreaTypeName Character vector, description of the area type; default
#'   is NULL
#' @param AreaTypeID Numeric vector, the Fingertips ID for the area type;
#'   default is NULL
#' @inheritParams indicators
#' @examples
#' # Returns a data frame with all levels of area and how they map to one another
#' area_types()
#'
#' # Returns a data frame of county and unitary authority mappings
#'  area_types("counties")
#'
#' # Returns a data frame of both counties, district
#' # and unitary authorities and their respective mappings
#' areas <- c("counties","district")
#' area_types(areas)
#'
#' # Uses AreaTypeID to filter area types
#' area_types(AreaTypeID = 152)
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom stats complete.cases
#' @importFrom httr GET content set_config config
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation decile lookups,
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain

area_types  <- function(AreaTypeName = NULL, AreaTypeID = NULL, path){
        if (!(is.null(AreaTypeName)) & !(is.null(AreaTypeID))) {
                warning("AreaTypeName used when both AreaTypeName and AreaTypeID are entered")
        }
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))
        parentAreas <- paste0(path,"area_types/parent_area_types") %>%
                GET %>%
                content("text") %>%
                fromJSON
        area_types <- parentAreas[,c("Id", "Name")]
        names(area_types) <- c("AreaTypeID","AreaTypeName")
        parentAreasNoNames <- parentAreas$ParentAreaTypes
        names(parentAreasNoNames) <- parentAreas$Id
        parentAreas <- parentAreasNoNames

        parentAreas <- bind_rows(parentAreas, .id = "t") %>%
                select(t, Id, Name) %>%
                rename(AreaTypeID = t,
                       ParentAreaTypeID = Id,
                       ParentAreaTypeName = Name) %>%
                mutate(AreaTypeID = as.numeric(AreaTypeID),
                       ParentAreaTypeID = as.numeric(ParentAreaTypeID))
        area_types <- left_join(area_types, parentAreas, by = c("AreaTypeID" = "AreaTypeID")) %>%
                arrange(AreaTypeID)
        if (!is.null(AreaTypeName)) {
                AreaTypeName <- paste(AreaTypeName, collapse = "|")
                area_types <- area_types[grep(tolower(AreaTypeName),
                                              tolower(area_types$AreaTypeName)),]
        } else {
                if (!is.null(AreaTypeID)) {
                        area_types <- area_types[area_types$AreaTypeID %in% AreaTypeID,]
                }
        }
        area_types[vapply(area_types, is.numeric, logical(1))] <-
                lapply(area_types[vapply(area_types, is.numeric, logical(1))],
                       as.integer)
        return(area_types[complete.cases(area_types),])
}

#' Category types
#'
#' Outputs a data frame of category type ids, their name (along with a short name)
#'
#' @inheritParams indicators
#' @return A data frame of category type ids and their descriptions
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config
#' @examples
#' # Returns the deprivation category types
#' cats <- category_types()
#' cats[cats$CategoryTypeId == 1,]
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation decile lookups,
#'   \code{\link{area_types}} for area type lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain

category_types <- function(path) {
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))
        category_types <- paste0(path,"category_types") %>%
                GET %>%
                content("text") %>%
                fromJSON %>%
                pull(Categories) %>%
                bind_rows %>%
                as_tibble
        return(category_types)
}

#' Area types by indicator
#'
#' Outputs a data frame of indicator ids and the area type ids that exist for
#' that indicator
#'
#' @return A data frame of indicator ids and area type ids
#' @param AreaTypeID integer; the Area Type ID (can be ignored or of length 1)
#' @param IndicatorID integer; the Indicator ID (can be ignored or of length 1).
#'   Takes priority over AreaTypeID if both are entered
#' @inheritParams indicators
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config
#' @examples
#' indicator_areatypes()
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation decile lookups,
#'   \code{\link{area_types}} for area type lookups,
#'   \code{\link{category_types}} for category type lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain
indicator_areatypes <- function(IndicatorID, AreaTypeID, path) {
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        path <- paste0(path, "available_data")
        if (!missing(IndicatorID)) {
                if (length(IndicatorID) > 1) {
                        stop("Length of IndicatorID must be 0 or 1")
                } else {
                        path <- paste0(path, "?indicator_id=", IndicatorID)
                }
        }
        if (!missing(AreaTypeID)) {
                if (length(AreaTypeID) > 1) {
                        stop("Length of AreaTypeID must be 0 or 1")
                } else {
                        path <- paste0(path, "?area_type_id=", AreaTypeID)
                }
        }
        set_config(config(ssl_verifypeer = 0L))
        areatypes_by_indicators <- path %>%
                GET %>%
                content("text") %>%
                fromJSON %>%
                as_tibble
        names(areatypes_by_indicators) <- c("IndicatorID", "AreaTypeID")
        return(areatypes_by_indicators)
}

#' Nearest neighbours
#'
#' Outputs a character vector of similar areas for given area. Currently returns
#' similar areas for Clinical Commissioning Groups (old and new) based on
#' \href{https://www.england.nhs.uk/publication/similar-10-ccg-explorer-tool/}{NHS
#' England's similar CCG explorer tool} or upper tier local authorities based on
#' \href{https://www.cipfastats.net/resources/nearestneighbours/}{CIPFA's
#' Nearest Neighbours Model}
#'
#' @details Use AreaTypeID = 102 for the AreaTypeID related to Children's
#'   services statistical neighbours
#' @return A character vector of area codes
#' @param AreaTypeID AreaTypeID of the nearest neighbours (see
#'   \code{\link{area_types}}) for IDs. Only returns information on AreaTypeIDs
#'   101, 102, 152, and 153
#' @inheritParams fingertips_data
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config
#' @examples
#' nearest_neighbours(AreaCode = "E38000003", AreaTypeID = 153)
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation decile lookups,
#'   \code{\link{area_types}} for area type lookups,
#'   \code{\link{category_types}} for category type lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain
nearest_neighbours <- function(AreaCode, AreaTypeID = 102, path) {
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        val <- case_when(
                AreaTypeID == 101 ~ 1,
                AreaTypeID == 153 ~ 2,
                AreaTypeID == 102 ~ 3,
                AreaTypeID == 152 ~ 4,
                TRUE ~ -1
        )
        areacheck <- paste0(path,
                            sprintf("parent_to_child_areas?parent_area_type_id=%s",
                                    AreaTypeID)) %>%
                GET %>%
                content("text") %>%
                fromJSON %>%
                names
        areacheck <- areacheck[grepl("^E", areacheck)]
        if (!(AreaCode %in% areacheck)) stop(paste0(AreaCode, " not in AreaTypeID = ", AreaTypeID))
        if (val == -1) stop("AreaTypeID must be one of 101, 102, 152 or 153")
        path <- paste0(path,
                       sprintf("areas/by_parent_area_code?area_type_id=%s&parent_area_code=nn-%s-%s",
                               AreaTypeID, val, AreaCode))
        set_config(config(ssl_verifypeer = 0L))
        nearest_neighbours <- path %>%
                GET %>%
                content("text") %>%
                fromJSON %>%
                pull(Code)
        return(nearest_neighbours)
}
