#' Profiles
#'
#' Outputs a data frame of indicators within a profile or domain
#' @return A data frame of indicators within a profile or domain.
#' @param ProfileID Numeric vector, id of profiles of interest
#' @param DomainID Numeric vector, id of domains of interest
#' @examples # Returns a complete data frame of indicators and their domains and profiles
#' @examples indicators()
#'
#' @examples # Returns a data frame of all of the indicators in the Public Health Outcomes Framework
#' @examples indicators(ProfileID = 19)
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @family lookup functions
#' @seealso \code{\link{area_types}} for area type  and their parent mappings,
#'   \code{\link{indicator_metadata}} for indicator metadata and
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{deprivation_decile}} for deprivation decile lookups
#' @export

indicators <- function(ProfileID = NULL,
                       DomainID = NULL) {
        path <- "http://fingertips.phe.org.uk/api/"
        if (!is.null(ProfileID)){
                tempdf <- profiles(ProfileID = ProfileID)
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
                dfRaw <- fromJSON(paste0(path,
                                         "indicator_metadata/by_group_id?group_ids=",
                                         dom),
                                  flatten = TRUE)
                if (length(dfRaw) != 0){
                        dfRaw <- unlist(dfRaw, recursive = FALSE)
                        dfIDs <- dfRaw[grepl("IID", names(dfRaw))]
                        dfDescription <- unlist(dfRaw[grepl("Descriptive", names(dfRaw))],
                                                recursive = FALSE)
                        dfDescription <- dfDescription[grepl("NameLong", names(dfDescription))]
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
