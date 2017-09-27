#' @importFrom jsonlite fromJSON
#' @importFrom utils read.csv
#' @importFrom httr GET content set_config config
retrieve_indicator <- function(IndicatorIDs, ProfileIDs, ChildAreaTypeIDs, ParentAreaTypeIDs){
        path <- "https://fingertips.phe.org.uk/api/"
        types <- "icccccccccccnnnnncccci"
        set_config(config(ssl_verifypeer = 0L))
        fingertips_data <- data.frame()
        for (i in 1:length(IndicatorIDs)) {
                IndicatorID <- IndicatorIDs[i]
                for (ChildAreaTypeID in ChildAreaTypeIDs) {
                        for (ParentAreaTypeID  in ParentAreaTypeIDs) {
                                if (missing(ProfileIDs)){
                                        dataurl <- paste0(path,
                                                          sprintf("all_data/csv/by_indicator_id?indicator_ids=%s&child_area_type_id=%s&parent_area_type_id=%s",
                                                                  IndicatorID, ChildAreaTypeID, ParentAreaTypeID),
                                                          "&include_sortable_time_periods=yes")
                                } else {
                                        ProfileID <- ProfileIDs[i]
                                        if (is.na(ProfileID)) {
                                                dataurl <- paste0(path,
                                                                  sprintf("all_data/csv/by_indicator_id?indicator_ids=%s&child_area_type_id=%s&parent_area_type_id=%s",
                                                                          IndicatorID,ChildAreaTypeID,ParentAreaTypeID),
                                                                  "&include_sortable_time_periods=yes")
                                        } else {
                                                dataurl <- paste0(path,
                                                                  sprintf("all_data/csv/by_indicator_id?indicator_ids=%s&child_area_type_id=%s&parent_area_type_id=%s&profile_id=%s",
                                                                          IndicatorID, ChildAreaTypeID, ParentAreaTypeID, ProfileID),
                                                                  "&include_sortable_time_periods=yes")
                                        }
                                }
                                fingertips_data <- rbind(dataurl %>% GET %>% content("parsed", type = "text/csv", encoding = "UTF-8", col_types = types),
                                                         fingertips_data)
                        }
                }
        }
        return(fingertips_data)
}

#' @importFrom jsonlite fromJSON
#' @importFrom utils read.csv
#' @importFrom httr GET content set_config config
retrieve_domain <- function(DomainIDs, ChildAreaTypeIDs, ParentAreaTypeIDs){
        path <- "https://fingertips.phe.org.uk/api/"
        types <- "icccccccccccnnnnncccci"
        set_config(config(ssl_verifypeer = 0L))
        fingertips_data <- data.frame()
        for (DomainID in DomainIDs) {
                for (ChildAreaTypeID in ChildAreaTypeIDs) {
                        for (ParentAreaTypeID  in ParentAreaTypeIDs) {
                                dataurl <- paste0(path,
                                                  sprintf("all_data/csv/by_group_id?child_area_type_id=%s&parent_area_type_id=%s&group_id=%s",
                                                          ChildAreaTypeID,ParentAreaTypeID,DomainID),
                                                  "&include_sortable_time_periods=yes")
                                fingertips_data <- rbind(dataurl %>% GET %>% content("parsed", type = "text/csv", encoding = "UTF-8", col_types = types),
                                                         fingertips_data)
                        }
                }
        }
        return(fingertips_data)
}

#' @importFrom jsonlite fromJSON
#' @importFrom utils read.csv
#' @importFrom httr GET content set_config config
retrieve_profile <- function(ProfileIDs, ChildAreaTypeIDs, ParentAreaTypeIDs){
        path <- "https://fingertips.phe.org.uk/api/"
        types <- "icccccccccccnnnnncccci"
        set_config(config(ssl_verifypeer = 0L))
        fingertips_data <- data.frame()
        for (ProfileID in ProfileIDs) {
                for (ChildAreaTypeID in ChildAreaTypeIDs) {
                        for (ParentAreaTypeID  in ParentAreaTypeIDs) {
                                dataurl <- paste0(path,
                                                  sprintf("all_data/csv/by_profile_id?child_area_type_id=%s&parent_area_type_id=%s&profile_id=%s",
                                                          ChildAreaTypeID,ParentAreaTypeID,ProfileID),
                                                  "&include_sortable_time_periods=yes")
                                fingertips_data <- rbind(dataurl %>% GET %>% content("parsed", type = "text/csv", encoding = "UTF-8", col_types = types),
                                                         fingertips_data)
                        }
                }
        }
        return(fingertips_data)
}
