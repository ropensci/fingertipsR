#' @import jsonlite
#' @importFrom data.table rbindlist setattr
#' @import dplyr
#' @import tidyjson

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
                diffFields <- setdiff(unique(timeperiod$IndicatorID),unique(dftemp$.id))
                if (length(diffFields) > 0) {
                        timeperiod <- timeperiod[timeperiod$IndicatorID != diffFields,"TimePeriod",with=FALSE]
                }
                dftemp <- cbind(TimePeriod = timeperiod$TimePeriod,
                                dftemp) %>%
                        mutate(.id = as.numeric(.id)) %>%
                        left_join(sex, by = c(".id" = "IndicatorID"))
                fingertipsData <- rbind(fingertipsData,dftemp)

        }
        return(fingertipsData)
}
