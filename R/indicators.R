#' Live profiles
#'
#' Outputs a data frame of indicators within a profile or domain
#' @return A data frame of indicators within a profile or domain.
#' @import dplyr
#' @import jsonlite
#' @import tidyjson
#' @export

indicators <- function(profileId = NULL, profileName = NULL, DomainID = NULL, DomainName = NULL) {
        path <- "http://fingertips.phe.org.uk/api/"
        if (!is.null(profileId)){
                tempdf <- liveProfiles(profileId = profileId)
                DomainID <- tempdf$DomainID
        } else if (!is.null(profileName)){
                tempdf <- liveProfiles(profileName = profileName)
                DomainID <- tempdf$DomainID
        } else if (!is.null(DomainID)) {
                tempdf <- liveProfiles()
                DomainID <- DomainID
        } else if (!is.null(DomainName)) {
                tempdf <- liveProfiles()
                DomainID <- tempdf$DomainID[tempdf$DomainName %in% DomainName]
        } else {
                tempdf <- liveProfiles()
                DomainID <- tempdf$DomainID
        }

        for (dom in DomainID) {
                dfRaw <- fromJSON(paste0(path,
                                         "indicator_metadata/by_group_id?group_ids=",
                                         dom),
                                  flatten = TRUE)
                dfRaw <- unlist(dfRaw, recursive = FALSE)
                dfIDs <- dfRaw[grepl("IID",names(dfRaw))]

                dfDescription <- unlist(dfRaw[grepl("Descriptive",names(dfRaw))],
                                        recursive = FALSE)
                dfDescription <- dfDescription[grepl("NameLong",names(dfDescription))]

                df <- data.frame(IndicatorID = unlist(dfIDs),
                                 IndicatorName = unlist(dfDescription),
                                 DomainID = dom,
                                 row.names=NULL)


        }

        df <- left_join(df,tempdf, by = c("DomainID" = "DomainID")) %>%
                select(IndicatorID, IndicatorName, DomainID, DomainName, ProfileID, ProfileName)
        return(df)

}
