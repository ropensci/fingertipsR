#' Profiles
#'
#' Outputs a data frame of indicators within a profile or domain
#' @return A data frame of indicators within a profile or domain.
#' @param ProfileID Numeric vector, id of profiles of interest
#' @param DomainID Numeric vector, id of domains of interest
#' @examples
#' \dontrun{
#' # Returns a complete data frame of indicators and their domains and profiles
#' indicators()
#'
#' # Returns a data frame of all of the indicators in the Public Health Outcomes Framework
#' indicators(ProfileID = 19)}
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config
#' @family lookup functions
#' @seealso \code{\link{area_types}} for area type  and their parent mappings,
#'   \code{\link{indicator_metadata}} for indicator metadata and
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{deprivation_decile}} for deprivation decile lookups and
#'   \code{\link{category_types}} for category lookups and
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups
#' @export

indicators <- function(ProfileID = NULL,
                       DomainID = NULL) {
        path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))
        if (!is.null(ProfileID)){
                tempdf <- profiles(ProfileID = ProfileID)
                if (!is.null(DomainID)) warning("DomainID is ignored as ProfileID has also been entered")
                DomainID <- tempdf$DomainID
        } else if (!is.null(DomainID)) {
                tempdf <- profiles()
                DomainID <- DomainID
        } else {
                tempdf <- profiles()
                DomainID <- tempdf$DomainID
        }
        df <- data.frame()
        for (dom in DomainID) {
                dfRaw <- paste0(path,"indicator_metadata/by_group_id?group_ids=",dom) %>%
                        GET %>%
                        content("text") %>%
                        fromJSON(flatten = TRUE)
                if (length(dfRaw) != 0){
                        dfRaw <- unlist(dfRaw, recursive = FALSE)
                        dfIDs <- dfRaw[grepl("IID", names(dfRaw))]
                        names(dfIDs) <- gsub(".IID","",names(dfIDs))
                        dfDescription <- unlist(dfRaw[grepl("Descriptive", names(dfRaw))],
                                                recursive = FALSE)
                        dfDescription <- dfDescription[grepl("NameLong", names(dfDescription))]
                        names(dfDescription) <- gsub(".Descriptive.NameLong","",names(dfDescription))
                        commonNames <- intersect(names(dfIDs), names(dfDescription))
                        dfIDs <- dfIDs[commonNames]
                        dfDescription <- dfDescription[commonNames]
                        dfFinal <- data.frame(IndicatorID = unlist(dfIDs),
                                         IndicatorName = unlist(dfDescription),
                                         DomainID = dom,
                                         row.names=NULL)
                        df <- rbind(dfFinal, df)
                }
        }
        df <- left_join(df, tempdf, by = c("DomainID" = "DomainID")) %>%
                select(IndicatorID, IndicatorName, DomainID, DomainName, ProfileID, ProfileName)
        return(df)
}
