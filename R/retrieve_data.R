#' @importFrom jsonlite fromJSON
#' @importFrom utils read.csv

retrieve_indicator <- function(IndicatorIDs, ChildAreaTypeIDs, ParentAreaTypeIDs){
        path <- "http://fingertips.phe.org.uk/api/"
        fingertips_data <- data.frame()
        # total <- length(IndicatorIDs) * length(ChildAreaTypeIDs) * length(ParentAreaTypeIDs)
        # i <- 0
        for (IndicatorID in IndicatorIDs) {
                for (ChildAreaTypeID in ChildAreaTypeIDs) {
                        for (ParentAreaTypeID  in ParentAreaTypeIDs) {
                                # i <- i + 1
                                # pb <- txtProgressBar(min = 0,
                                #                      max = total,
                                #                      style = 3)
                                dataurl <- paste0(path,
                                                  sprintf("/all_data/csv/by_indicator_id?indicator_ids=%s&child_area_type_id=%s&parent_area_type_id=%s",
                                                          IndicatorID,ChildAreaTypeID,ParentAreaTypeID),
                                                  "&include_sortable_time_periods=yes")
                                fingertips_data <- rbind(read.csv(dataurl),
                                                         fingertips_data)
                                # Sys.sleep(0.1)
                                # setTxtProgressBar(pb, i)
                        }
                }
        }
        #close(pb)
        return(fingertips_data)
}

retrieve_domain <- function(DomainIDs, ChildAreaTypeIDs, ParentAreaTypeIDs){
        path <- "http://fingertips.phe.org.uk/api/"
        fingertips_data <- data.frame()
        for (DomainID in DomainIDs) {
                for (ChildAreaTypeID in ChildAreaTypeIDs) {
                        for (ParentAreaTypeID  in ParentAreaTypeIDs) {
                                dataurl <- paste0(path,
                                                  sprintf("/all_data/csv/by_group_id?child_area_type_id=%s&parent_area_type_id=%s&group_id=%s",
                                                          ChildAreaTypeID,ParentAreaTypeID,DomainID),
                                                  "&include_sortable_time_periods=yes")
                                fingertips_data <- rbind(read.csv(dataurl),
                                                         fingertips_data)
                        }
                }
        }
        return(fingertips_data)
}

retrieve_profile <- function(ProfileIDs, ChildAreaTypeIDs, ParentAreaTypeIDs){
        path <- "http://fingertips.phe.org.uk/api/"
        fingertips_data <- data.frame()
        for (ProfileID in ProfileIDs) {
                for (ChildAreaTypeID in ChildAreaTypeIDs) {
                        for (ParentAreaTypeID  in ParentAreaTypeIDs) {
                                dataurl <- paste0(path,
                                                  sprintf("/all_data/csv/by_profile_id?child_area_type_id=%s&parent_area_type_id=%s&profile_id=%s",
                                                          ChildAreaTypeID,ParentAreaTypeID,ProfileID),
                                                  "&include_sortable_time_periods=yes")
                                fingertips_data <- rbind(read.csv(dataurl),
                                                         fingertips_data)
                        }
                }
        }
        return(fingertips_data)
}
