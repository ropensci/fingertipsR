#' Fingertips data
#'
#' Outputs a data frame of data from [Fingertips]<http://fingertips.phe.org.uk/>
#' @return A data frame of data extracted from the Fingertips API
#' @import dplyr
#' @import jsonlite
#' @import data.table
#' @import tidyjson
#' @export

fingertipsData <- function(IndicatorID = NULL, DomainID = NULL, ProfileID = NULL, AreaTypeID = 102, ParentCode = "All") {
        path <- "http://fingertips.phe.org.uk/api/"
        fingertipsData <- data.frame()
        if (!is.null(ProfileID)) {
                if (!is.null(DomainID)) {
                        #Do I need to loop through all parent codes and then take a unique set of data at the end?
                        if (ParentCode == "All") {
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

ProfileID <- 8
DomainID <- 1000101
AreTypeID <- 102
ParentCode <- "E47000001"



retrieveData <- function(dataurl){

        df <- fromJSON(dataurl)
        fingertipsData <- data.frame()
        for (i in 1:length(df$Data)) {
                areaCode <- names(df$Data[i])
                timeperiod <- df$Periods
                timeperiod <- setattr(timeperiod,'names',df$IID)
                timeperiod <- lapply(timeperiod,data.frame)
                timeperiod <- rbindlist(timeperiod,use.names=TRUE,idcol = TRUE) %>%
                        rename(IndicatorID = .id,
                               TimePeriod = `X..i..`)
                sex <- data.frame(IndicatorID = df$IID,
                                  SexID = df$Sex$Id)
                dftemp <- unlist(df$Data[i],recursive = FALSE)
                dftemp <- setattr(dftemp, 'names', df$IID)
                dftemp <- dftemp[sapply(dftemp, length)>0] #remove lists with no data in
                dftemp <- lapply(dftemp, function(x) x[(names(x) %in% c("V","L","U"))]) #keep only variables of interest
                dftemp <- rbindlist(dftemp,use.names=TRUE,fill=TRUE,idcol = TRUE) %>%
                        mutate(AreaCode = areaCode)
                timeperiod <- timeperiod[timeperiod$IndicatorID != setdiff(unique(timeperiod$IndicatorID),unique(dftemp$.id)),"TimePeriod",with=FALSE]
                dftemp <- cbind(timeperiod,dftemp) %>%
                        mutate(.id = as.numeric(.id)) %>%
                        left_join(sex, by = c(".id" = "IndicatorID"))
                fingertipsData <- rbind(fingertipsData,dftemp)

        }
        return(fingertipsData)
}
