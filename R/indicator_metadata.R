#' Indicator metadata
#'
#' Outputs a data frame containing the metadata for selected indicators. Note, this
#' function can take up to a few minutes to run (depending on internet
#' connection speeds)
#' @param IndicatorID Numeric vector, id of the indicator of interest. Also accepts "All".
#' @inheritParams fingertips_data
#' @examples
#' \dontrun{
#' # Returns metadata for indicator ID 90362 and 1107
#' indicatorIDs <- c(90362, 1107)
#' indicator_metadata(indicatorIDs)
#'
#' # Returns metadata for the indicators within the domain 1000101
#' indicator_metadata(DomainID = 1000101)
#'
#' # Returns metadata for the indicators within the profile with the ID 129
#' indicator_metadata(ProfileID = 129)}
#' @return The metadata associated with each indicator/domain/profile identified
#' @importFrom utils read.csv
#' @importFrom httr GET content set_config config use_proxy
#' @importFrom curl ie_get_proxy_for_url
#' @importFrom readr read_csv cols
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation lookups,
#'   \code{\link{area_types}} for area types and their parent mappings,
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain
#' @export

indicator_metadata <- function(IndicatorID = NULL,
                               DomainID = NULL,
                               ProfileID = NULL,
                               path) {
        set_config(config(ssl_verifypeer = 0L))
        types <- cols(`Indicator ID` = "i",
                      Indicator = "c",
                      `Definition` = "c",
                      `Rationale` = "c",
                      `Data source` = "c",
                      `Indicator source` = "c",
                      `Methodology` = "c",
                      `Standard population/values` = "c",
                      `Confidence interval details` = "c",
                      `Source of numerator` = "c",
                      `Definition of numerator` = "c",
                      `Source of denominator` = "c",
                      `Definition of denominator` = "c",
                      `Disclosure control` = "c",
                      `Caveats` = "c",
                      `Copyright` = "c",
                      `Data re-use` = "c",
                      `Links` = "c",
                      `Indicator number` = "c",
                      `Notes` = "c",
                      `Frequency` = "c",
                      `Rounding` = "c",
                      `Data quality` = "i",
                      `Indicator Content` = "c",
                      `Specific rationale` = "c",
                      `Unit` = "c",
                      `Value type` = "c",
                      `Year type` = "c",
                      `Polarity` = "c",
                      `Impact of COVID-19` = "c")

        if (missing(path)) path <- fingertips_endpoint()
        set_config(config(ssl_verifypeer = 0L))
        fingertips_ensure_api_available(endpoint = path)
        if (!(is.null(IndicatorID))) {
                AllIndicators <- indicators(path = path)

                if (identical(IndicatorID, "All")) {
                                dataurl <- paste0(path, "indicator_metadata/csv/all")
                                indicator_metadata <- dataurl %>%
                                        GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                                        content("parsed",
                                                type = "text/csv",
                                                encoding = "UTF-8",
                                                col_types = types)

                } else if (sum(AllIndicators$IndicatorID %in% IndicatorID) == 0) {
                        stop("IndicatorID(s) do not exist, use indicators() to identify existing indicators")
                } else {
                        path <- paste0(path, "indicator_metadata/csv/by_indicator_id?indicator_ids=")
                        dataurl <- paste0(path,
                                          paste(IndicatorID, collapse = "%2C"))
                        if (!(is.null(ProfileID)) & length(ProfileID == 1))
                                dataurl <- paste0(dataurl, "&profile_id=", ProfileID)
                        indicator_metadata <- dataurl %>%
                                GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                                content("parsed",
                                        type = "text/csv",
                                        encoding = "UTF-8",
                                        col_types = types)
                }

        } else if (!(is.null(DomainID))) {
                AllProfiles <- profiles(path = path)
                if (sum(AllProfiles$DomainID %in% DomainID) == 0){
                        stop("DomainID(s) do not exist, use profiles() to identify existing domains")
                }
                path <- paste0(path, "indicator_metadata/csv/by_group_id?group_id=")
                indicator_metadata <- paste0(path, DomainID) %>%
                        lapply(function(dataurl) {
                                dataurl %>%
                                        GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                                        content("parsed",
                                                type = "text/csv",
                                                encoding = "UTF-8",
                                                col_types = types)
                        }) %>%
                        bind_rows
        } else if (!(is.null(ProfileID))) {
                AllProfiles <- profiles(path = path)
                if (sum(AllProfiles$ProfileID %in% ProfileID) == 0){
                        stop("ProfileID(s) do not exist, use profiles() to identify existing profiles")
                }
                path <- paste0(path, "indicator_metadata/csv/by_profile_id?profile_id=")
                indicator_metadata <- paste0(path, ProfileID) %>%
                        lapply(function(dataurl) {
                                dataurl %>%
                                        GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                                        content("parsed",
                                                type = "text/csv",
                                                encoding = "UTF-8",
                                                col_types = types)
                        }) %>%
                        bind_rows
        } else {
                stop("One of IndicatorID, DomainID or ProfileID must be populated")
        }
        colnames(indicator_metadata)[colnames(indicator_metadata)=="Indicator ID"] <- "IndicatorID"
        return(indicator_metadata)
}
