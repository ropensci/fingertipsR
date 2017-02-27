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
        #fingertipsData <- data.frame()
        if (is.null(AreaTypeID)){
                stop("AreaTypeID must have a value. Use function areaTypes() to see what codes can be used.")
        }
        AreaTypeIDs <- AreaTypeID

        ## Need to work out if IndicatorID is not null and either DomainID or ProfileID is not null,
        ## how to return either just indicator values or full domain/profile values

        if (!is.null(IndicatorID)){
                indicatorIDs <- indicators() %>%
                        filter(IndicatorID %in% indicatorID)
                if (!is.null(DomainID)){
                        DomainID <- unique(c(DomainID,as.numeric(IndicatorIDs$DomainID)))
                } else {
                        DomainID <- as.numeric(IndicatorIDs$DomainID)
                }

                if (!is.null(ProfileID)){
                        ProfileID <- unique(c(ProfileID,as.numeric(IndicatorIDs$ProfileID)))
                } else {
                        ProfileID <- as.numeric(IndicatorIDs$ProfileID)
                }
        }

        if (!is.null(ProfileID)) {
                ProfileIDs <- ProfileID
                if (!is.null(DomainID)) {
                        DomainIDs <- DomainID
                        test <- liveProfiles(profileId = ProfileIDs) %>%
                                filter(DomainID == DomainIDs)
                        if (nrow(test) == 0 ){
                                stop("DomainID(s) do(es) not exist in profile. Use the function liveProfiles() to see which domains are within each profile.")
                        }
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                                #fingertipsData <- rbind(fingertipsData,retrieveData(ParentCodes,ProfileID, DomainID, AreaTypeID))

                        } else {
                                ###Need to check that getParentCodes can take multiple values
                                ParentCodes <- getParentCodes(AreaTypeIDs)
                                #fingertipsData <- rbind(fingertipsData,retrieveData(ParentCodes,ProfileID, DomainID, AreaTypeID))
                        }
                } else {
                        DomainIDs <- liveProfiles(profileId = ProfileID)
                        DomainIDs <- as.character(DomainIDs$DomainID)
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                                #for (DomainID in DomainIDs) {
                                #        fingertipsData <- rbind(fingertipsData,retrieveData(dataurl))
                                #}
                         } else {
                                ###this is returning duplicates for :
                                 # ProfileID <- 8
                                 # DomainID <- NULL
                                 # AreaTypeID <- 102
                                 # ParentCode <- NULL
                                ParentCodes <- getParentCodes(AreaTypeIDs)
                                #for (DomainID in DomainIDs) {
                                #        fingertipsData <- rbind(fingertipsData,retrieveData(dataurl))
                                #}
                        }
                }
        } else {
                ###All below was written in London and not tested
                if (!is.null(DomainID)) {
                       ProfileIDs <- liveProfiles()
                       ProfileIDs <- ProfileIDs[ProfileIDs$DomainID %in% DomainID,]
                       ProfileIDs <- as.character(unique(ProfileIDs$ProfileID))
                       DomainIDs <- DomainID
                       if (!is.null(ParentCode)) {
                               ParentCodes <- ParentCode

                               #fingertipsData <- rbind(fingertipsData,retrieveData(ParentCodes,ProfileID, DomainID, AreaTypeID))
                       } else {
                               ParentCodes <- getParentCodes(AreaTypeIDs)
                               #fingertipsData <- rbind(fingertipsData,retrieveData(ParentCodes,ProfileID, DomainID, AreaTypeID))
                       }
                } else {
                        DomainIDs <- liveProfiles()
                        ProfileIDs <- as.character(DomainIDs$ProfileID)
                        DomainIDs <- as.character(DomainIDs$DomainID)
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                                # for (ProfileID in ProfileIDs) {
                                #         for (DomainID in DomainIDs) {
                                #                 fingertipsData <- rbind(fingertipsData,retrieveData(dataurl))
                                #         }
                                # }
                        } else {
                                ParentCodes <- getParentCodes(AreaTypeIDs)

                                # for (DomainID in DomainIDs) {
                                #         fingertipsData <- rbind(fingertipsData,retrieveData(dataurl))
                                # }
                        }
                }
        }
        #fingertipsData <- rbind(fingertipsData,retrieveData(ParentCodes,ProfileIDs, DomainIDs, AreaTypeIDs))
        fingertipsData <- retrieveData(ParentCodes,ProfileIDs, DomainIDs, AreaTypeIDs)

        fingertipsData <- rename(fingertipsData,IndicatorID = .id,
                          Value = V,
                          LowerCI = L,
                          UpperCI = U)
        fingertipsData[fingertipsData=="-"] <- NA

        cols = c("IndicatorID","Value","LowerCI","UpperCI")
        fingertipsData[,cols] = apply(fingertipsData[,cols], 2, function(x) as.numeric(x))
        return(fingertipsData)

}





