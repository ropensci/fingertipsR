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
#' @importFrom stats complete.cases
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

area_types  <- function(AreaTypeName = NULL, AreaTypeID = NULL, ProfileID = NULL, path){
        if (!(is.null(AreaTypeName)) & !(is.null(AreaTypeID))) {
                warning("AreaTypeName used when both AreaTypeName and AreaTypeID are entered")
        }
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))
        parentAreas <- paste0(path,"area_types/parent_area_types") %>%
                get_fingertips_api()
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

        if (!is.null(ProfileID)) {
                areas_in_profile <- paste0(path, "area_types?profile_ids=", ProfileID) %>%
                        get_fingertips_api() %>%
                        pull(Id)
                area_types <- area_types %>%
                        filter(AreaTypeID %in% areas_in_profile)
        }
        return(area_types[complete.cases(area_types),])
}

#' Category types
#'
#' Outputs a data frame of category type ids, their name (along with a short name)
#'
#' @inheritParams indicators
#' @return A data frame of category type ids and their descriptions
#' @import dplyr
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
                get_fingertips_api()
        category_names <- category_types %>%
                select(Id, CategoryType = Name)
        category_types <- category_types %>%
                pull(Categories) %>%
                bind_rows %>%
                as_tibble %>%
                left_join(category_names, by = "Id")
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
                get_fingertips_api() %>%
                as_tibble
        names(areatypes_by_indicators) <- c("IndicatorID", "AreaTypeID")
        return(areatypes_by_indicators)
}

#' Nearest neighbours
#'
#' Outputs a character vector of similar areas for given area. Currently returns
#' similar areas for Clinical Commissioning Groups (old and new) based on
#' \href{https://www.england.nhs.uk/publication/similar-10-ccg-explorer-tool/}{NHS
#' England's similar CCG explorer tool} or lower and upper tier local
#' authorities based on
#' \href{https://www.cipfastats.net/resources/nearestneighbours/}{CIPFA's
#' Nearest Neighbours Model} or upper tier local authorities based on
#' \href{https://www.gov.uk/government/publications/local-authority-interactive-tool-lait}{Children's
#' services statistical neighbour benchmarking tool}
#'
#' @details Use AreaTypeID = 102 for the AreaTypeID related to Children's
#'   services statistical neighbours
#' @return A character vector of area codes
#' @param AreaTypeID AreaTypeID of the nearest neighbours (see
#'   \code{\link{area_types}}) for IDs. Only returns information on AreaTypeIDs
#'   101, 102, 152, and 154
#' @param measure string; when AreaTypeID = 102 measure must be either "CIPFA"
#'   for CIPFA local authority nearest neighbours or "CSSN" for Children's
#'   services statistical neighbours
#' @inheritParams fingertips_data
#' @import dplyr
#' @importFrom utils head
#' @examples
#' nearest_neighbours(AreaCode = "E38000002", AreaTypeID = 154)
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
nearest_neighbours <- function(AreaCode, AreaTypeID = 101, measure, path) {
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        if (AreaTypeID == 102) {
                if (missing(measure)) {
                        stop("If using AreaTypeID = 102, you must specify measure (CIPFA or CSSN)")
                } else if (!(measure %in% c("CIPFA","CSSN"))) {
                        stop("Measure must be either CIPFA or CSSN")
                }
        }
        if (missing(measure)) measure <- NA
        if (AreaTypeID == 101) {
                val <- 1
        } else if (AreaTypeID == 154) {
                val <- 2
        } else if (AreaTypeID == 102 & measure == "CSSN") {
                val <- 3
        } else if (AreaTypeID == 102 & measure == "CIPFA") {
                val <- 1
        } else if (AreaTypeID == 152) {
                val <- 4
        } else {
                val <- NA
        }
        ParentAreaTypeID <- area_types(AreaTypeID = AreaTypeID) %>%
                pull(ParentAreaTypeID) %>%
                head(1)

        areacheck <- paste0(path,
                            sprintf("parent_to_child_areas?child_area_type_id=%s&parent_area_type_id=%s",
                                    AreaTypeID,
                                    ParentAreaTypeID)) %>%
                get_fingertips_api() %>%
                unlist(use.names = FALSE)
        areacheck <- areacheck[grepl("^E", areacheck)]
        if (!(AreaCode %in% areacheck)) stop(paste0(AreaCode, " not in AreaTypeID = ", AreaTypeID))
        if (is.na(val)) stop("AreaTypeID must be one of 101, 102, 152 or 154")
        path <- paste0(path,
                       sprintf("areas/by_parent_area_code?area_type_id=%s&parent_area_code=nn-%s-%s",
                               AreaTypeID, val, AreaCode))
        set_config(config(ssl_verifypeer = 0L))
        nearest_neighbours <- path %>%
                get_fingertips_api()
        if (length(nearest_neighbours) != 0) {
                nearest_neighbours <- nearest_neighbours %>%
                        pull(Code)
        } else {
                nearest_neighbours <- character()
        }
        return(nearest_neighbours)
}
