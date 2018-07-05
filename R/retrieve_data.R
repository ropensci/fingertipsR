#' @importFrom httr set_config config
retrieve_indicator <- function(IndicatorIDs, ProfileIDs, ChildAreaTypeIDs, ParentAreaTypeIDs, path){
        types <- "icccccccccccnnnnnnnccccic"
        set_config(config(ssl_verifypeer = 0L))
        fingertips_data <- data.frame()
        for (i in seq_len(length(IndicatorIDs))) {
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
                                new_data <- new_data_formatting(dataurl)
                                fingertips_data <- rbind(new_data,
                                                         fingertips_data)
                        }
                }
        }
        return(fingertips_data)
}

#' @importFrom httr set_config config
retrieve_domain <- function(DomainIDs, ChildAreaTypeIDs, ParentAreaTypeIDs, path){
        types <- "icccccccccccnnnnnnnccccic"
        set_config(config(ssl_verifypeer = 0L))
        fingertips_data <- data.frame()
        for (DomainID in DomainIDs) {
                for (ChildAreaTypeID in ChildAreaTypeIDs) {
                        for (ParentAreaTypeID  in ParentAreaTypeIDs) {
                                dataurl <- paste0(path,
                                                  sprintf("all_data/csv/by_group_id?child_area_type_id=%s&parent_area_type_id=%s&group_id=%s",
                                                          ChildAreaTypeID,ParentAreaTypeID,DomainID),
                                                  "&include_sortable_time_periods=yes")
                                new_data <- new_data_formatting(dataurl)
                                fingertips_data <- rbind(new_data,
                                                         fingertips_data)
                        }
                }
        }
        return(fingertips_data)
}

#' @importFrom httr set_config config
retrieve_profile <- function(ProfileIDs, ChildAreaTypeIDs, ParentAreaTypeIDs, path){
        types <- "icccccccccccnnnnnnnccccic"
        set_config(config(ssl_verifypeer = 0L))
        fingertips_data <- data.frame()
        for (ProfileID in ProfileIDs) {
                for (ChildAreaTypeID in ChildAreaTypeIDs) {
                        for (ParentAreaTypeID  in ParentAreaTypeIDs) {
                                dataurl <- paste0(path,
                                                  sprintf("all_data/csv/by_profile_id?child_area_type_id=%s&parent_area_type_id=%s&profile_id=%s",
                                                          ChildAreaTypeID,ParentAreaTypeID,ProfileID),
                                                  "&include_sortable_time_periods=yes")
                                new_data <- new_data_formatting(dataurl)
                                fingertips_data <- rbind(new_data,
                                                         fingertips_data)
                        }
                }
        }
        return(fingertips_data)
}

#' @importFrom httr GET content use_proxy
#' @importFrom curl ie_get_proxy_for_url
#' @importFrom utils read.table
new_data_formatting <- function(dataurl) {
        df_string  <- dataurl %>%
                GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
                content("text")
        new_data <- read.table(text = df_string,
                             encoding = "UTF-8",
                             sep = ",",
                             fill = TRUE,
                             header = TRUE,
                             quote = "",
                             stringsAsFactors = FALSE)
        return(new_data)
}
