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
                        #Do I need to loop through all parent codes and then take a unique set of data at the end?
                        if (is.null(ParentCode)) {
                                pcodes <- areaTypes() %>%
                                        filter(AreaID %in% AreaTypeID)
                                pcodes <- unique(pcodes$ParentAreaID)
                                ParentCodes <- data.frame()
                                for (pcode in pcodes) {
                                        tempParentCodes <- fromJSON(paste0(path,"areas/by_area_type?area_type_id=",pcode))
                                        if (length(setdiff(names(ParentCodes),  names(tempParentCodes))) > 0) {
                                                newcols <- setdiff(names(ParentCodes),  names(tempParentCodes))
                                                if (!(newcols %in% names(ParentCodes))) {
                                                        ParentCodes[newcols] <- NA
                                                } else if (!(newcols %in% names(tempParentCodes))) {
                                                        tempParentCodes[newcols] <- NA
                                                }
                                        }
                                        ParentCodes <- rbind(tempParentCodes,
                                                             ParentCodes)
                                }
                                ParentCodes <- as.character(unique(ParentCodes$Code))
                                ParentCodes <- fromJSON(paste0(path,
                                                               "areas/by_area_code?area_codes=",
                                                               paste(ParentCodes,collapse = "%2C")))
                                smallestGroup <- filter(ParentCodes,!is.na(AreaTypeId)) %>%
                                        group_by(AreaTypeId) %>%
                                        summarise(count = n()) %>%
                                        filter(count == min(count)) %>%
                                        slice(1)
                                ParentCodes <- filter(ParentCodes,AreaTypeId %in% smallestGroup$AreaTypeId)
                                ParentCodes <- as.character(ParentCodes$Code)

                                for (ParentCode in ParentCodes) {
                                        dataurl <- paste0(path,"trend_data/all_indicators_in_profile_group_for_child_areas",
                                                          "?profile_id=",ProfileID,
                                                          "&group_id=",DomainID,
                                                          "&area_type_id=",AreaTypeID,
                                                          "&parent_area_code=",ParentCode)
                                        fingertipsData <- rbind(fingertipsData,retrieveData(dataurl))
                                }


                        } else {
                                dataurl <- paste0(path,"trend_data/all_indicators_in_profile_group_for_child_areas",
                                                  "?profile_id=",ProfileID,
                                                  "&group_id=",DomainID,
                                                  "&area_type_id=",AreaTypeID,
                                                  "&parent_area_code=",ParentCode)
                                fingertipsData <- retrieveData(dataurl)
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





