#' @import jsonlite
#' @import dplyr

getParentCodes <- function(AreaTypeID) {
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
}
