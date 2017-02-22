#' Fingertips data
#'
#' Outputs a data frame of data from [Fingertips]<http://fingertips.phe.org.uk/>
#' @return A data frame of data extracted from the Fingertips API
#' @import jsonlite
#' @import dplyr
#' @import tidyjson
#' @export

fingertipsData <- function(IndicatorID = NULL, DomainID = NULL, ProfileID = NULL, AreaTypeID = 102, ParentCode = NULL) {
        path <- "http://fingertips.phe.org.uk/api/"
        fingertipsData <- data.frame()
        if (!is.null(ProfileID)) {
                if (!is.null(DomainID)) {
                        test <- liveProfiles(profileId = ProfileID) %>%
                                filter(DomainID == DomainID)
                        if (nrow(test) == 0 ){
                                stop("DomainID does not exist in profile. Use the function liveProfiles() to see which domains are within each profile.")
                        }
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                                fingertipsData <- rbind(fingertipsData,retrieveData(ParentCodes,ProfileID, DomainID, AreaTypeID))
                        } else {
                                ParentCodes <- getParentCodes(AreaTypeID)
                                fingertipsData <- rbind(fingertipsData,retrieveData(ParentCodes,ProfileID, DomainID, AreaTypeID))
                        }
                } else {
                        DomainIDs <- liveProfiles(profileId = ProfileID)
                        DomainIDs <- as.character(DomainIDs$DomainID)
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                                for (DomainID in DomainIDs) {
                                        fingertipsData <- rbind(fingertipsData,retrieveData(dataurl))
                                }
                         } else {
                                ###this is returning duplicates for :
                                 # ProfileID <- 8
                                 # DomainID <- NULL
                                 # AreaTypeID <- 102
                                 # ParentCode <- NULL
                                ParentCodes <- getParentCodes(AreaTypeID)

                                for (DomainID in DomainIDs) {
                                        fingertipsData <- rbind(fingertipsData,retrieveData(dataurl))
                                }
                        }
                }
        }


        fingertipsData <- rename(fingertipsData,IndicatorID = .id,
                          Value = V,
                          LowerCI = L,
                          UpperCI = U)
        fingertipsData[fingertipsData=="-"] <- NA

        cols = c("IndicatorID","Value","LowerCI","UpperCI")
        fingertipsData[,cols] = apply(fingertipsData[,cols], 2, function(x) as.numeric(x))
        return(fingertipsData)

}





