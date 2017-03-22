#' Fingertips data
#'
#' Outputs a data frame of data from [Fingertips]<http://fingertips.phe.org.uk/>
#' @return A data frame of data extracted from the Fingertips API
#' @importFrom jsonlite fromJSON
#' @import dplyr
#' @import tidyjson
#' @export

fingertips_data <- function(IndicatorID = NULL,
                           AreaCode = NULL,
                           DomainID = NULL,
                           ProfileID = NULL,
                           AreaTypeID = 102,
                           ParentCode = NULL) {

        # check on area details before calling data
        if (is.null(AreaTypeID)) {
                stop("AreaTypeID must have a value. Use function area_types() to see what codes can be used.")
        }
        AreaTypeIDs <- AreaTypeID

        if (!is.null(AreaCode)) {
                # check and set AreaTypeID to the correct levels
                AreaCodeTypeIDs <- area_lookup(AreaCode)
                AreaTypeIDs <- unique(as.numeric(AreaCodeTypeIDs$AreaTypeId))
                AreaCodeParentCodes <- get_parent_codes(AreaTypeIDs)
                if (!is.null(ParentCode)) {
                        if (!(ParentCode %in% AreaCodeParentCodes)) {
                                stop(paste0("The AreaCode requested are not covered by the entered ParentCode. ",
                                            "If data is only required for the AreaCode, leave the ParentCode input variable empty. ",
                                            "Use the function area_lookup() to find out available areas."))
                        } else {
                                ParentCode <- AreaCodeParentCodes
                        }
                } else {
                        ParentCode <- AreaCodeParentCodes
                }

        }

        # check on indicator details before calling data
        filterDomain <- NULL
        filterProfile <- NULL
        if (!is.null(IndicatorID)){

                # check domain ID covers the indicators' domains
                if (!is.null(DomainID)){
                        indicatorIDs <- indicators(DomainID = DomainID)
                        indicatorIDs <- indicatorIDs[indicatorIDs$IndicatorID %in% IndicatorID,]
                        if (!(DomainID %in% as.numeric(indicatorIDs$DomainID))){
                                stop("DomainID does not include the DomainID of the IndicatorID. Use function indicators() to see the domains for each indicator.")
                        } else {
                                # set filter for later to filter for single indicator within the domain
                                # allowing for full domains that don't include the indicator
                                filterDomain <- as.numeric(indicatorIDs$DomainID)
                                if (!is.null(ProfileID)){
                                        if (!(ProfileID %in% as.numeric(indicatorIDs$ProfileID))){
                                                stop("ProfileID does not include the ProfileID of the IndicatorID. Use function indicators() to see the profiles for each indicator.")
                                        } else {
                                                # set filter for later to filter for single indicator within the profile
                                                # allowing for full profiles that don't include the indicator
                                                filterProfile <- as.numeric(indicatorIDs$ProfileID)
                                        }
                                } else {
                                        ProfileID <- unique(as.numeric(indicatorIDs$ProfileID))
                                }
                        }
                } else {
                        if (!is.null(ProfileID)){
                                indicatorIDs <- indicators(profileId = ProfileID)
                                indicatorIDs <- indicatorIDs[indicatorIDs$IndicatorID %in% IndicatorID,]
                                if (!(ProfileID %in% as.numeric(indicatorIDs$ProfileID))){
                                        stop("ProfileID does not include the ProfileID of the IndicatorID. Use function indicators() to see the profiles for each indicator.")
                                } else {
                                        # set filter for later to filter for single indicator within the profile
                                        # allowing for full profiles that don't include the indicator
                                        filterProfile <- as.numeric(indicatorIDs$ProfileID)
                                        DomainID <- as.numeric(indicatorIDs$DomainID)
                                }
                        } else {
                                indicatorIDs <- indicators()
                                indicatorIDs <- indicatorIDs[indicatorIDs$IndicatorID %in% IndicatorID,]
                                ProfileID <- unique(as.numeric(indicatorIDs$ProfileID))
                                DomainID <- as.numeric(indicatorIDs$DomainID)
                        }
                }
        }

        # this part creates the inputs for the retrieve_data function that extracts the data from the API
        path <- "http://fingertips.phe.org.uk/api/"

        if (!is.null(ProfileID)) {
                ProfileIDs <- ProfileID
                if (!is.null(DomainID)) {
                        DomainIDs <- DomainID
                        test <- profiles(profileId = ProfileIDs)
                        test <- test[test$DomainID %in% DomainIDs,]
                        if (nrow(test) == 0 ){
                                stop("DomainID(s) do(es) not exist in profile. Use the function profiles() to see which domains are within each profile.")
                        }
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                        } else {
                                ###Need to check that get_parent_codes can take multiple values
                                ParentCodes <- get_parent_codes(AreaTypeIDs)
                        }
                } else {
                        DomainIDs <- profiles(profileId = ProfileID)
                        DomainIDs <- as.character(DomainIDs$DomainID)
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                        } else {
                                ParentCodes <- get_parent_codes(AreaTypeIDs)
                        }
                }
        } else {
                if (!is.null(DomainID)) {
                       ProfileIDs <- profiles()
                       ProfileIDs <- ProfileIDs[ProfileIDs$DomainID %in% DomainID,]
                       ProfileIDs <- as.character(unique(ProfileIDs$ProfileID))
                       DomainIDs <- DomainID
                       if (!is.null(ParentCode)) {
                               ParentCodes <- ParentCode
                       } else {
                               ParentCodes <- get_parent_codes(AreaTypeIDs)
                       }
                } else {
                        DomainIDs <- profiles()
                        ProfileIDs <- as.character(DomainIDs$ProfileID)
                        DomainIDs <- as.character(DomainIDs$DomainID)
                        if (!is.null(ParentCode)) {
                                ParentCodes <- ParentCode
                        } else {
                                ParentCodes <- get_parent_codes(AreaTypeIDs)
                        }
                }
        }

        # this pulls the data from the API
        fingertips_data <- retrieve_data(ParentCodes, ProfileIDs, DomainIDs, AreaTypeIDs)

        if (!is.null(AreaCode)){
                fingertips_data <- fingertips_data[fingertips_data$AreaCode %in% AreaCode,]
        }

        if (!is.null(IndicatorID)){
                test <- sum(fingertips_data$.id %in% IndicatorID)
                if (test == 0) {
                        stop("No IndicatorIDs are available using that combination of other inputs.")
                } else {
                        fingertips_data <- fingertips_data[fingertips_data$.id %in% IndicatorID,]
                }


                #this command duplicates records for each domain and profile requested
                # fingertips_data <- left_join(fingertips_data,indicatorIDs, by = c(".id" = "IndicatorID"))
                # if (!is.null(filterDomain)){
                #         if (!is.null(filterProfile)) {
                #                 fingertips_data <- fingertips_data[(fingertips_data$ProfileID %in% filterProfile &
                #                                                           fingertips_data$DomainID %in% filterDomain &
                #                                                           fingertips_data$.id %in% IndicatorID)|
                #                                                          !(fingertips_data$DomainID %in% filterDomain),]
                #         } else {
                #                 fingertips_data <- fingertips_data[(fingertips_data$DomainID %in% filterDomain &
                #                                                           fingertips_data$.id %in% IndicatorID)|
                #                                                          !(fingertips_data$DomainID %in% filterDomain),]
                #         }
                # } else {
                #         if (!is.null(filterProfile)) {
                #                 fingertips_data <- fingertips_data[(fingertips_data$ProfileID %in% filterProfile &
                #                                                           fingertips_data$.id %in% IndicatorID)|
                #                                                          !(fingertips_data$DomainID %in% filterDomain),]
                #         } else {
                #                 fingertips_data <- fingertips_data[(fingertips_data$.id %in% IndicatorID),]
                #         }
                # }
                fingertips_data <- select(fingertips_data,
                                         TimePeriod,
                                         .id,
                                         V,
                                         L,
                                         U,
                                         AreaCode,
                                         sex,
                                         age)
                fingertips_data <- unique(fingertips_data)
        }




        fingertips_data <- rename(fingertips_data,
                                 IndicatorID = .id,
                                 Value = V,
                                 LowerCI = L,
                                 UpperCI = U,
                                 SexID = sex,
                                 AgeID = age)
        fingertips_data[fingertips_data == "-"] <- NA

        cols = c("IndicatorID", "Value", "LowerCI", "UpperCI", "SexID", "AgeID")
        fingertips_data[, cols] <- apply(fingertips_data[, cols], 2, function(x) as.numeric(x))
        fingertips_data

        fingertips_data <- fingertips_data[,c("TimePeriod", "IndicatorID", "AreaCode"
                                            ,"Sex", "Age", "Value",
                                            "LowerCI", "UpperCI")]
        return(fingertips_data)

}





