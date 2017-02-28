#' Fingertips data
#'
#' Outputs a data frame of data from [Fingertips]<http://fingertips.phe.org.uk/>
#' @return A data frame of data extracted from the Fingertips API
#' @import jsonlite fromJSON
#' @import dplyr
#' @import tidyjson
#' @export

fingertipsData <- function(IndicatorID = NULL, AreaCode = NULL, DomainID = NULL, ProfileID = NULL, AreaTypeID = 102, ParentCode = NULL) {

        # check on area details before calling data
        if (is.null(AreaTypeID)){
                stop("AreaTypeID must have a value. Use function areaTypes() to see what codes can be used.")
        }
        AreaTypeIDs <- AreaTypeID

        if (!is.null(AreaCode)){
                # check and set AreaTypeID to the correct levels
                ## call some function to retrieve area type ids for each area code
                ## return it to variable AreaCodeTypeIDs
                AreaTypeID <- unique(as.character(AreaCodeTypeIDs$AreaTypeID))
                AreaCodeParentCodes <- getParentCodes(AreaTypeIDs)
                if (!is.null(ParentCode)) {
                        if (!(ParentCode %in% AreaCodeParentCodes)) {
                                stop(paste0("The AreaCode requested are not covered by the entered ParentCode. ",
                                            "If data is only required for the AreaCode, leave the ParentCode input variable empty. ",
                                            "Use the function areaLookups() to find out available areas."))
                        } else {
                                ParentCode <- AreacodeParentCodes
                        }
                } else {
                        ParentCode <- AreacodeParentCodes
                }

        }

        # check on indicator details before calling data
        filterDomain <- NULL
        filterProfile <- NULL
        if (!is.null(IndicatorID)){
                indicatorIDs <- indicators() %>%
                        filter(IndicatorID %in% indicatorID)
                # check domain ID covers the indicators' domains
                if (!is.null(DomainID)){
                        if (!(DomainID %in% as.numeric(IndicatorIDs$DomainID))){
                                stop("DomainID does not include the DomainID of the IndicatorID. Use function indicators() to see the domains for each indicator.")
                        } else {
                                # set filter for later to filter for single indicator within the domain
                                # allowing for full domains that don't include the indicator
                                filterDomain <- as.numeric(IndicatorIDs$DomainID)
                        }
                } else {
                        DomainID <- as.numeric(IndicatorIDs$DomainID)
                        #filterDomain <- as.numeric(IndicatorIDs$DomainID)
                }

                if (!is.null(ProfileID)){
                        if (!(ProfileID %in% as.numeric(IndicatorIDs$ProfileID))){
                                stop("ProfileID does not include the ProfileID of the IndicatorID. Use function indicators() to see the profiles for each indicator.")
                        } else {
                                # set filter for later to filter for single indicator within the profile
                                # allowing for full profiles that don't include the indicator
                                filterProfile <- as.numeric(IndicatorIDs$ProfileID)
                        }
                } else {
                        ProfileID <- as.numeric(IndicatorIDs$ProfileID)
                        #filterProfile <- as.numeric(IndicatorIDs$ProfileID)
                }
        }

        path <- "http://fingertips.phe.org.uk/api/"

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
                        } else {
                                ###Need to check that getParentCodes can take multiple values
                                ParentCodes <- getParentCodes(AreaTypeIDs)
                        }
                } else {
                        DomainIDs <- liveProfiles(profileId = ProfileID)
                        DomainIDs <- as.character(DomainIDs$DomainID)
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                         } else {
                                ParentCodes <- getParentCodes(AreaTypeIDs)
                        }
                }
        } else {
                if (!is.null(DomainID)) {
                       ProfileIDs <- liveProfiles()
                       ProfileIDs <- ProfileIDs[ProfileIDs$DomainID %in% DomainID,]
                       ProfileIDs <- as.character(unique(ProfileIDs$ProfileID))
                       DomainIDs <- DomainID
                       if (!is.null(ParentCode)) {
                               ParentCodes <- ParentCode
                       } else {
                               ParentCodes <- getParentCodes(AreaTypeIDs)
                       }
                } else {
                        DomainIDs <- liveProfiles()
                        ProfileIDs <- as.character(DomainIDs$ProfileID)
                        DomainIDs <- as.character(DomainIDs$DomainID)
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                        } else {
                                ParentCodes <- getParentCodes(AreaTypeIDs)
                        }
                }
        }

        fingertipsData <- retrieveData(ParentCodes,ProfileIDs, DomainIDs, AreaTypeIDs)

        if (!is.null(AreaCode)){
                fingertipsData <- fingertipsData[fingertipsData$AreaCode %in% AreaCode,]
        }

        if (!is.null(IndicatorID)){
                if (!is.null(filterDomain)){
                        if (!is.null(filterProfile)) {
                                fingertipsData <- fingertipsData[(fingertipsData$ProfileID %in% filterProfile &
                                                                          fingertipsData$DomainID %in% filterDomain &
                                                                          fingertipsData$IndicatorID %in% IndicatorID)|
                                                                         !(fingertipsData$DomainID %in% filterDomain),]
                        } else {
                                fingertipsData <- fingertipsData[(fingertipsData$DomainID %in% filterDomain &
                                                                          fingertipsData$IndicatorID %in% IndicatorID)|
                                                                         !(fingertipsData$DomainID %in% filterDomain),]
                        }
                } else {
                        if (!is.null(filterProfile)) {
                                fingertipsData <- fingertipsData[(fingertipsData$ProfileID %in% filterProfile &
                                                                          fingertipsData$IndicatorID %in% IndicatorID)|
                                                                         !(fingertipsData$DomainID %in% filterDomain),]
                        } else {
                                fingertipsData <- fingertipsData[(fingertipsData$IndicatorID %in% IndicatorID),]
                        }
                }
        }




        fingertipsData <- rename(fingertipsData,
                                 IndicatorID = .id,
                                 Value = V,
                                 LowerCI = L,
                                 UpperCI = U)
        fingertipsData[fingertipsData=="-"] <- NA

        cols = c("IndicatorID","Value","LowerCI","UpperCI")
        fingertipsData[,cols] = apply(fingertipsData[,cols], 2, function(x) as.numeric(x))
        return(fingertipsData)

}





