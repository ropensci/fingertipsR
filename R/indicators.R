#' Live indicators and the profiles and domains they belong to
#'
#' Outputs a data frame of indicators within a profile or domain
#' @return A data frame of indicators within a profile or domain.
#' @param ProfileID Numeric vector, id of profiles of interest
#' @param DomainID Numeric vector, id of domains of interest
#' @param path String; Fingertips API address. Function will default to the
#'   correct address
#' @examples
#' \dontrun{
#' # Returns a complete data frame of indicators and their domains and profiles
#' indicators()
#'
#' # Returns a data frame of all of the indicators in the Public Health Outcomes Framework
#' indicators(ProfileID = 19)}
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config use_proxy
#' @importFrom curl ie_get_proxy_for_url
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
                       path) {
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))
        if (!is.null(ProfileID)){
                tempdf <- profiles(ProfileID = ProfileID, path = path)
                if (!is.null(DomainID)) warning("DomainID is ignored as ProfileID has also been entered")
                DomainID <- tempdf$DomainID
        } else if (!is.null(DomainID)) {
                tempdf <- profiles(path = path)
                DomainID <- DomainID
        } else {
                tempdf <- profiles(path = path)
                DomainID <- tempdf$DomainID
        }
        df <- DomainID %>%
                lapply(function(dom) {
                        dfRaw <- paste0(path,"indicator_metadata/by_group_id?group_ids=",dom) %>%
                                GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                                content("text") %>%
                                fromJSON(flatten = TRUE)
                        if (length(dfRaw) != 0){
                                dfRaw <- unlist(dfRaw, recursive = FALSE)
                                dfIDs <- dfRaw[grepl("IID", names(dfRaw))]
                                names(dfIDs) <- gsub(".IID","",names(dfIDs))
                                dfDescription <- unlist(dfRaw[grepl("Descriptive",
                                                                    names(dfRaw))],
                                                        recursive = FALSE)
                                dfDescription <- dfDescription[grepl("NameLong",
                                                                     names(dfDescription))]
                                names(dfDescription) <- gsub(".Descriptive.NameLong","",
                                                             names(dfDescription))
                                commonNames <- intersect(names(dfIDs), names(dfDescription))
                                dfIDs <- dfIDs[commonNames]
                                dfDescription <- dfDescription[commonNames]

                                data.frame(IndicatorID = unlist(dfIDs),
                                           IndicatorName = unlist(dfDescription),
                                           DomainID = dom,
                                           row.names=NULL) %>%
                                        mutate(IndicatorName = as.character(IndicatorName))
                        }
                }) %>%
                bind_rows %>%
                mutate(IndicatorName = factor(IndicatorName))
        df <- left_join(df, tempdf, by = c("DomainID" = "DomainID")) %>%
                select(IndicatorID, IndicatorName,
                       DomainID, DomainName,
                       ProfileID, ProfileName) %>%
                as_tibble
        return(df)
}

#' Live indicators
#'
#' Outputs a data frame of indicators (their id and name only). Note, this
#' function can take up to a few minutes to run (depending on internet
#' connection speeds)
#' @return A data frame of indicator ids and names
#' @inheritParams indicators
#' @examples
#' indicators_unique(ProfileID = 21)
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
                            path) {
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        df <- indicators(ProfileID, DomainID, path = path)
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
                            path) {
        if (missing(DomainID)|missing(AreaTypeID)|missing(ParentAreaTypeID))
                stop("All of DomainID, AreaTypeID and ParentAreaTypeID are required")
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"

        ParentAreaCode <- paste0(path,
                                 sprintf("parent_to_child_areas?parent_area_type_id=%s",
                                         ParentAreaTypeID)) %>%
                GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                content("text") %>%
                fromJSON %>%
                names
        ParentAreaCode <- ParentAreaCode[grepl("^E", ParentAreaCode)][1]
        domid <- DomainID
        ProfileID <- profiles() %>%
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
                GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                content("text") %>%
                fromJSON %>%
                select(IID, Sequence, Sex, Age)
        indicator_order$Sex <- indicator_order$Sex$Name
        indicator_order$Age <- indicator_order$Age$Name
        indicator_order <- indicator_order %>%
                rename(IndicatorID = IID) %>%
                as_tibble
        return(indicator_order)
}
