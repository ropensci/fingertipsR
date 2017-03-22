#' @importFrom jsonlite fromJSON
#' @importFrom data.table rbindlist setattr
#' @import dplyr
#' @import tidyjson

retrieve_data <- function(ParentCodes,ProfileIDs,DomainIDs,AreaTypeIDs){
        path <- "http://fingertips.phe.org.uk/api/"
        fingertips_data <- data.frame()
        for (ProfileID in ProfileIDs) {
                for (DomainID in DomainIDs) {
                        if (DomainID  %in% profiles(ProfileID)$DomainID) {
                                for (ParentCode in ParentCodes) {
                                        for (AreaTypeID in AreaTypeIDs){
                                                dataurl <- paste0(path,"trend_data/all_indicators_in_profile_group_for_child_areas",
                                                                  "?profile_id=",ProfileID,
                                                                  "&group_id=",DomainID,
                                                                  "&area_type_id=",AreaTypeID,
                                                                  "&parent_area_code=",ParentCode)

                                                df <- fromJSON(dataurl)
                                                if (length(df) != 0) {
                                                        for (i in 1:length(df$Data)) {
                                                                areaCode <- names(df$Data[i])
                                                                timeperiod <- df$Periods
                                                                timeperiod <- setattr(timeperiod, 'names', df$IID)
                                                                timeperiod <- lapply(timeperiod, data.frame)
                                                                timeperiod <- rbindlist(timeperiod, use.names = TRUE, idcol = TRUE) %>%
                                                                        rename(IndicatorID = .id,
                                                                               TimePeriod = `X..i..`)
                                                                IID.sex.age <- paste(df$IID,
                                                                                     df$Sex$Id,
                                                                                     df$Age$Id,
                                                                                     sep = ".")
                                                                dftemp <- unlist(df$Data[i], recursive = FALSE)
                                                                dftemp <- setattr(dftemp, 'names', IID.sex.age)
                                                                dftemp <- dftemp[sapply(dftemp, length) > 0] #remove lists with no data in
                                                                dftemp <- lapply(dftemp, function(x) x[(names(x) %in% c("V", "L", "U"))]) #keep only variables of interest
                                                                dftemp <- rbindlist(dftemp, use.names = TRUE, fill = TRUE, idcol = TRUE) %>%
                                                                        mutate(AreaCode = areaCode)
                                                                parsecols <- do.call(rbind, strsplit(dftemp$.id,"[.]"))
                                                                parsecols <- data.frame(parsecols)
                                                                parsecols[,1:3] <- apply(parsecols[,1:3], 2, function(x) as.numeric(as.character(x)))
                                                                parsecols <- data.frame(parsecols)
                                                                names(parsecols) <- c(".id", "sex", "age")
                                                                dftemp <- select(dftemp, -.id) %>%
                                                                        cbind(parsecols)
                                                                diffFields <- setdiff(unique(timeperiod$IndicatorID), unique(dftemp$.id))
                                                                if (length(diffFields) > 0) {
                                                                        timeperiod <- timeperiod[timeperiod$IndicatorID != diffFields, "TimePeriod", with=FALSE]
                                                                }
                                                                dftemp <- cbind(TimePeriod = timeperiod$TimePeriod,
                                                                                dftemp) %>%
                                                                        mutate(.id = as.numeric(.id))
                                                                fingertips_data <- rbind(fingertips_data, dftemp)
                                                        }
                                                }
                                        }
                                }
                        }
                }
        }
        fingertips_data <- unique(fingertips_data)
        return(fingertips_data)
}
