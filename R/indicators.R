#' Live indicators and the profiles and domains they belong to
#'
#' Outputs a data frame of indicators within a profile or domain
#' @return A data frame of indicators within a profile or domain.
#' @param ProfileID Numeric vector, id of profiles of interest
#' @param DomainID Numeric vector, id of domains of interest
#' @param path String; Fingertips API address. Function will default to the
#'   correct address
#' @inheritParams area_types
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' # Returns a complete data frame of indicators and their domains and profiles
#' indicators()
#'
#' # Returns a data frame of all of the indicators in the Public Health Outcomes Framework
#' indicators(ProfileID = 19)}
#' @import dplyr
#' @family lookup functions
#' @seealso \code{\link{area_types}} for area type  and their parent mappings,
#'   \code{\link{indicator_metadata}} for indicator metadata,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation decile lookups,
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain
#' @export

indicators <- function(ProfileID = NULL,
                       DomainID = NULL,
                       proxy_settings = "default",
                       path) {
        if (missing(path)) path <- fingertips_endpoint()
        set_config(config(ssl_verifypeer = 0L))
        fingertips_ensure_api_available(
          endpoint = path,
          proxy_settings = proxy_settings)
        if (!is.null(ProfileID)){
                tempdf <- profiles(
                  ProfileID = ProfileID,
                  proxy_settings = proxy_settings,
                  path = path)
                if (!is.null(DomainID)) warning("DomainID is ignored as ProfileID has also been entered")
                DomainID <- tempdf$DomainID
        } else if (!is.null(DomainID)) {
                tempdf <- profiles(
                  proxy_settings = proxy_settings,
                  path = path)
                DomainID <- DomainID
        } else {
                tempdf <- profiles(
                  proxy_settings = proxy_settings,
                  path = path)
                DomainID <- tempdf$DomainID
        }
        if (length(DomainID) > 100) {
                DomainID <- split(DomainID,
                                  ceiling(seq_along(DomainID) / 100)) %>%
                    lapply(paste,
                           collapse = ",") %>%
                    unlist() %>%
                    unname()
        }
        url <- paste0(path,
                      "indicator_names/by_group_id?group_ids=",
                      DomainID)
        df <- url %>%
                lapply(function(dom) {
                        dom %>%
                    get_fingertips_api(
                      proxy_settings = proxy_settings)

                }) %>%
                bind_rows() %>%
                left_join(tempdf, by = c("GroupId" = "DomainID")) %>%
                select(IndicatorID = "IndicatorId",
                       "IndicatorName",
                       DomainID = "GroupId",
                       "DomainName",
                       "ProfileID",
                       "ProfileName") %>%
                mutate(IndicatorName = factor(.data$IndicatorName)) %>%
                as_tibble()

        return(df)
}

#' Live indicators
#'
#' Outputs a data frame of indicators (their id and name only). Note, this
#' function can take up to a few minutes to run (depending on internet
#' connection speeds)
#' @return A data frame of indicator ids and names
#' @inheritParams indicators
#' @inheritParams area_types
#' @examples
#' \dontrun{
#' indicators_unique(ProfileID = 21)}
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicators and their parent domains and
#'   profiles, \code{\link{area_types}} for area type  and their parent
#'   mappings, \code{\link{indicator_metadata}} for indicator metadata and
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{deprivation_decile}} for deprivation decile lookups and
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain
#' @export
indicators_unique <- function(ProfileID = NULL,
                            DomainID = NULL,
                            proxy_settings = "default",
                            path) {
        if (missing(path)) path <- fingertips_endpoint()
        fingertips_ensure_api_available(
          endpoint = path,
          proxy_settings = proxy_settings)
        df <- indicators(
          ProfileID,
          DomainID,
          proxy_settings = proxy_settings,
          path = path)
        df <- unique(df[,c("IndicatorID", "IndicatorName")])
        return(df)

}

#' Indicator order number
#'
#' Outputs a tibble of indicator ids and their sequence number for the provided
#' domain and area type. This enables the user to order the indicators as they
#' are ordered on the Fingertips website.
#' @return A data frame of indicator ids and sequence number
#' @inheritParams fingertips_data
#' @inheritParams area_types
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' indicator_order(DomainID = 1938133161, AreaTypeID = 102, ParentAreaTypeID = 6)}
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicators and their parent domains and profiles,
#'   \code{\link{area_types}} for area type and their parent mappings,
#'   \code{\link{indicator_metadata}} for indicator metadata,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation decile lookups,
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups and
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area
#' @export
indicator_order <- function(DomainID,
                            AreaTypeID,
                            ParentAreaTypeID,
                            proxy_settings = "default",
                            path) {
        if (missing(DomainID)|missing(AreaTypeID)|missing(ParentAreaTypeID))
                stop("All of DomainID, AreaTypeID and ParentAreaTypeID are required")
        if (missing(path)) path <- fingertips_endpoint()
        fingertips_ensure_api_available(
          endpoint = path,
          proxy_settings = proxy_settings)

        ParentAreaCode <- paste0(path,
                                 sprintf("parent_to_child_areas?child_area_type_id=%s&parent_area_type_id=%s",
                                         AreaTypeID,
                                         ParentAreaTypeID)) %>%
                get_fingertips_api(
                  proxy_settings = proxy_settings
                ) %>%
                names()
        ParentAreaCode <- ParentAreaCode[grepl("^E", ParentAreaCode)][1]
        domid <- DomainID
        ProfileID <- profiles(
          proxy_settings = proxy_settings,
          path = path) %>%
          filter(DomainID == domid)
        if (nrow(ProfileID) == 0) {
                stop("DomainID does not exist")
        } else {
                ProfileID <- unique(ProfileID$ProfileID)
        }

        path <- paste0(path,
                       sprintf("latest_data/all_indicators_in_profile_group_for_child_areas?profile_id=%s&group_id=%s&area_type_id=%s&parent_area_code=%s",
                               ProfileID, DomainID, AreaTypeID, ParentAreaCode))
        set_config(config(ssl_verifypeer = 0L))
        indicator_order <- path %>%
          get_fingertips_api(
            proxy_settings = proxy_settings
          ) %>%
          select(
            IndicatorID = "IID",
            "Sequence",
            Sex = "Sex.Name",
            Age = "Age.Name") %>%
          as_tibble()
        return(indicator_order)
}
