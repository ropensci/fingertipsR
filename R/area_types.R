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
#' \dontrun{
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
#' area_types(AreaTypeID = 152)}
#' @import dplyr
#' @importFrom stats complete.cases
#' @importFrom rlang .data
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
        if (missing(path)) path <- fingertips_endpoint()
        set_config(config(ssl_verifypeer = 0L))
        fingertips_ensure_api_available(endpoint = path)
        parentAreas <- paste0(path,"area_types/parent_area_types") %>%
                get_fingertips_api()
        area_types <- parentAreas[,c("Id", "Name")]
        names(area_types) <- c("AreaTypeID","AreaTypeName")
        parentAreasNoNames <- parentAreas$ParentAreaTypes
        names(parentAreasNoNames) <- parentAreas$Id
        parentAreas <- parentAreasNoNames

        parentAreas <- bind_rows(parentAreas, .id = "t") %>%
                select(.data$t, .data$Id, .data$Name) %>%
                rename(AreaTypeID = .data$t,
                       ParentAreaTypeID = .data$Id,
                       ParentAreaTypeName = .data$Name) %>%
                mutate(AreaTypeID = as.numeric(.data$AreaTypeID),
                       ParentAreaTypeID = as.numeric(.data$ParentAreaTypeID))
        area_types <- left_join(area_types, parentAreas, by = c("AreaTypeID" = "AreaTypeID")) %>%
                arrange(.data$AreaTypeID)
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
                        pull(.data$Id)
                area_types <- area_types %>%
                        filter(.data$AreaTypeID %in% areas_in_profile)
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
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' # Returns the deprivation category types
#' cats <- category_types()
#' cats[cats$CategoryTypeId == 1,]}
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
        if (missing(path)) path <- fingertips_endpoint()
        set_config(config(ssl_verifypeer = 0L))
        fingertips_ensure_api_available(endpoint = path)
        category_types <- paste0(path,"category_types") %>%
                get_fingertips_api()
        category_names <- category_types %>%
                select(.data$Id,
                       CategoryType = .data$Name)
        category_types <- category_types %>%
                pull(.data$Categories) %>%
                bind_rows() %>%
                as_tibble() %>%
                left_join(category_names, by = c("CategoryTypeId" = "Id"))
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
#' \dontrun{
#' indicator_areatypes(IndicatorID = 10101)}
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
        if (missing(path)) path <- fingertips_endpoint()
        fingertips_ensure_api_available(endpoint = path)
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
                as_tibble()
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
#' @return A character vector of area codes
#' @param AreaTypeID AreaTypeID of the nearest neighbours (see
#'   \code{\link{nearest_neighbour_areatypeids}}) for available IDs
#' @param measure deprecated. Previously a string; when AreaTypeID = 102 measure
#'   must be either "CIPFA" for CIPFA local authority nearest neighbours or
#'   "CSSN" for Children's services statistical neighbours
#' @inheritParams fingertips_data
#' @import dplyr
#' @importFrom utils head
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' nearest_neighbours(AreaCode = "E38000002", AreaTypeID = 154)}
#' @export
#' @family lookup functions
#' @seealso \code{\link{nearest_neighbour_areatypeids}} for the AreaTypeIDs
#'   available for this function
nearest_neighbours <- function(AreaCode, AreaTypeID, measure, path) {

        if (missing(path)) path <- fingertips_endpoint()
        fingertips_ensure_api_available(endpoint = path)

        url <- "https://fingertips.phe.org.uk/api/nearest_neighbour_types"

        nn_table <- get_fingertips_api(url) %>%
                rename(measure = .data$Name)

        df <- nn_table %>%
                select(.data$NeighbourTypeId, .data$ApplicableAreaTypes) %>%
                fingertips_deframe() %>%
                bind_rows(.id = "NeighbourTypeId") %>%
                mutate(NeighbourTypeId = as.integer(.data$NeighbourTypeId)) %>%
                left_join(nn_table, by = "NeighbourTypeId") %>%
                dplyr::select(AreaTypeID = .data$Id,
                              .data$NeighbourTypeId,
                              .data$measure)

        val <- if(AreaTypeID %in% df$AreaTypeID) {
                df$NeighbourTypeId[df$AreaTypeID == AreaTypeID]
        } else {
                stop("AreaTypeID not found. Use function `nearest_neighbour_areatypeids()` to see available AreaTypeIDs.")
        }

        if (!(missing(measure))) {
                warning("Measure argument is now deprecated.")
        }

        ParentAreaTypeID <- area_types(AreaTypeID = AreaTypeID) %>%
                pull(.data$ParentAreaTypeID) %>%
                head(1)

        areacheck <- paste0(path,
                            sprintf("parent_to_child_areas?child_area_type_id=%s&parent_area_type_id=%s",
                                    AreaTypeID,
                                    ParentAreaTypeID)) %>%
                get_fingertips_api() %>%
                unlist(use.names = FALSE)

        areacheck <- areacheck[grepl("^E", areacheck)]

        # Check if AreaCode in the AreaTypeID
        if (!(AreaCode %in% areacheck)) stop(paste0(AreaCode, " not in AreaTypeID = ", AreaTypeID))

        path <- paste0(path,
                       sprintf("areas/by_parent_area_code?area_type_id=%s&parent_area_code=nn-%s-%s",
                               AreaTypeID, val, AreaCode))
        set_config(config(ssl_verifypeer = 0L))
        nearest_neighbours <- path %>%
                get_fingertips_api()

        if (length(nearest_neighbours) != 0) {
                nearest_neighbours <- nearest_neighbours %>%
                        pull(.data$Code)
        } else {
                nearest_neighbours <- character()
        }
        return(nearest_neighbours)
}

areas_by_profile <- function(AreaTypeID, ProfileID, path) {
        set_config(config(ssl_verifypeer = 0L))
        fingertips_ensure_api_available(endpoint = path)

        repeats <- max(length(AreaTypeID),
                       length(ProfileID))
        areas_by_profile <- mapply(sprintf,
                                   paste0(path,
                                          rep("grouproot_summaries/by_profile_id?profile_id=%s&area_type_id=%s", repeats)),
                                   ProfileID,
                                   AreaTypeID) %>%
                lapply(function(x) get_fingertips_api(x))
        # names(areas_by_profile) <- AreaTypeID
        nrows_in_each_tibble <- lapply(areas_by_profile, function(x)
                if (is.null(nrow(x))) {
                        return(0)
                        } else {
                                return(nrow(x))
                                }) %>%
                unlist()

        AreaTypeID_field <- mapply(function(x, y) rep(x, times = y), AreaTypeID, nrows_in_each_tibble) %>%
                unlist()
        names(areas_by_profile) <- NULL
        areas_by_profile <- bind_rows(areas_by_profile) %>%
                mutate(AreaTypeID = AreaTypeID_field) %>%
                select(IndicatorID = .data$IID,
                       .data$AreaTypeID,
                       DomainID = .data$GroupId)
        profs <- profiles() %>%
                filter(.data$DomainID %in% areas_by_profile$DomainID) %>%
                select(.data$DomainID,
                       .data$ProfileID)
        areas_by_profile <- areas_by_profile %>%
                left_join(profs, by = "DomainID") %>%
                unique() %>%
                mutate(ParentAreaTypeID = 15)
        return(areas_by_profile)
}

#' Nearest neighbours area type ids
#'
#' Outputs a table of AreaTypeIDs available for the nearest_neighbour function
#' @return table of AreaTypeIDs
#' @importFrom rlang .data
#' @export
#' @seealso \code{\link{nearest_neighbours}} to access the geogaphy codes of the
#'   nearest neighbours for a locality
#' @examples
#' \dontrun{
#' nearest_neighbour_areatypeids()}
nearest_neighbour_areatypeids <- function() {

        url <- "https://fingertips.phe.org.uk/api/nearest_neighbour_types"

        areatypeid_table <- get_fingertips_api(url) %>%
                rename(measure = .data$Name)

        df <- areatypeid_table %>%
                select(.data$NeighbourTypeId, .data$ApplicableAreaTypes) %>%
                fingertips_deframe() %>%
                bind_rows(.id = "NeighbourTypeId") %>%
                mutate(NeighbourTypeId = as.integer(.data$NeighbourTypeId)) %>%
                left_join(areatypeid_table, by = "NeighbourTypeId") %>%
                dplyr::select(AreaTypeID = .data$Id)

                return(df)
}

