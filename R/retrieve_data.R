#' @importFrom httr set_config config
retrieve_indicator <- function(IndicatorIDs, ProfileIDs, ChildAreaTypeIDs, ParentAreaTypeIDs, generic_name = FALSE, path){
        if (missing(ProfileIDs)) {
                ProfileIDs <- ""
                profileID_bit <- ""
        } else if (any(is.na(ProfileIDs))) {
                ProfileIDs <- ""
                profileID_bit <- ""
                warning("ProfileID can not contain NAs - all ProfileIDs are ignored")
        } else {
                profileID_bit <- "&profile_id=%s"
        }
        fd <- data.frame(IndicatorIDs = IndicatorIDs,
                         ProfileIDs = ProfileIDs,
                         ChildAreaTypeIDs = ChildAreaTypeIDs,
                         ParentAreaTypeIDs = ParentAreaTypeIDs,
                         path = path,
                         profileID_bit = profileID_bit) %>%
                unique()

        set_config(config(ssl_verifypeer = 0L))

        get_data <- function(x) {
                if (!(x$ProfileIDs == "" | is.na(x$ProfileIDs))) {
                        x$profileID_bit <- sprintf(as.character(x$profileID_bit), x$ProfileIDs)
                }
                dataurl <- paste0("all_data/csv/by_indicator_id?indicator_ids=%s&child_area_type_id=%s&parent_area_type_id=%s", x$profileID_bit)
                dataurl <- paste0(x$path,
                                  sprintf(dataurl, x$IndicatorIDs, x$ChildAreaTypeIDs, x$ParentAreaTypeIDs),
                                  "&include_sortable_time_periods=yes")
                y <- new_data_formatting(dataurl, generic_name)
                y
        }

        dd <- by(fd,
                 list(fd$IndicatorIDs, fd$ProfileIDs, fd$ChildAreaTypeIDs,
                      fd$ParentAreaTypeIDs, fd$profileID_bit),
                 get_data)
        fingertips_data <- do.call("rbind", dd)
        return(fingertips_data)
}


#' @importFrom httr set_config config
retrieve_domain <- function(DomainIDs, ChildAreaTypeIDs, ParentAreaTypeIDs, path){
        fd <- data.frame(DomainIDs = DomainIDs,
                         ChildAreaTypeIDs = ChildAreaTypeIDs,
                         ParentAreaTypeIDs = ParentAreaTypeIDs,
                         path = path)
        set_config(config(ssl_verifypeer = 0L))
        get_data <- function(x) {
                dataurl <- "all_data/csv/by_group_id?child_area_type_id=%s&parent_area_type_id=%s&group_id=%s"
                dataurl <- paste0(x$path,
                                  sprintf(dataurl, x$ChildAreaTypeIDs, x$ParentAreaTypeIDs, x$DomainIDs),
                                  "&include_sortable_time_periods=yes")
                y <- new_data_formatting(dataurl)
                y
        }

        dd <- by(fd,
                 list(fd$DomainIDs,
                      fd$ChildAreaTypeIDs,
                      fd$ParentAreaTypeIDs),
                 get_data)
        fingertips_data <- do.call("rbind", dd)
        return(fingertips_data)
}

#' @importFrom httr set_config config
retrieve_profile <- function(ProfileIDs, ChildAreaTypeIDs, ParentAreaTypeIDs, path){
        fd <- data.frame(ProfileIDs = ProfileIDs,
                         ChildAreaTypeIDs = ChildAreaTypeIDs,
                         ParentAreaTypeIDs = ParentAreaTypeIDs,
                         path = path)
        set_config(config(ssl_verifypeer = 0L))
        get_data <- function(x) {
                dataurl <- "all_data/csv/by_profile_id?child_area_type_id=%s&parent_area_type_id=%s&profile_id=%s"
                dataurl <- paste0(x$path,
                                  sprintf(dataurl, x$ChildAreaTypeIDs, x$ParentAreaTypeIDs, x$ProfileIDs),
                                  "&include_sortable_time_periods=yes")
                y <- new_data_formatting(dataurl)
                y
        }

        dd <- by(fd,
                 list(fd$ProfileIDs,
                      fd$ChildAreaTypeIDs,
                      fd$ParentAreaTypeIDs),
                 get_data)
        fingertips_data <- do.call("rbind", dd)
        return(fingertips_data)
}

#' @import dplyr
#' @importFrom httr GET content use_proxy RETRY
#' @importFrom curl ie_get_proxy_for_url
#' @importFrom utils read.delim
new_data_formatting <- function(dataurl, generic_name = FALSE) {
        # df_string  <- add_timestamp(dataurl) %>%
        #         GET(use_proxy(ie_get_proxy_for_url(.), username = "", password = "", auth = "ntlm")) %>%
        #         content("text")
        df_string <- add_timestamp(dataurl)
        df_string <- RETRY("GET", url = df_string,
                           config = use_proxy(ie_get_proxy_for_url(df_string),
                                              username = "",
                                              password = "",
                                              auth = "ntlm"),
                           times = 5) %>%
                content("text")
        new_data <- read.delim(text = df_string,
                               encoding = "UTF-8",
                               sep = ",",
                               fill = TRUE,
                               header = TRUE,
                               stringsAsFactors = FALSE,
                               check.names = FALSE)
        names(new_data)[names(new_data)=="Target data"] <- "Compared to goal"
        parent_field_name <- names(new_data)[grepl("^Compared", names(new_data))]
                parent_field_name <- parent_field_name[!grepl("Compared to goal|Compared to England", parent_field_name)]

        character_fields <- c("Indicator Name", "Parent Code",
                              "Parent Name", "Area Code",
                              "Area Name", "Area Type",
                              "Sex", "Age", "Category Type",
                              "Category", "Time period",
                              "Value note", "Recent Trend",
                              "Compared to England value or percentiles",
                              parent_field_name,
                              "New data", "Compared to goal")
        numeric_fields <- c("Value", "Lower CI 95.0 limit",
                            "Upper CI 95.0 limit", "Lower CI 99.8 limit",
                            "Upper CI 99.8 limit", "Count",
                            "Denominator")
        integer_fields <- c("Indicator ID", "Time period Sortable")
        new_data <- new_data %>%
                mutate_at(.vars = character_fields, as.character)
        new_data <- new_data %>%
                mutate_at(.vars = numeric_fields, as.numeric)
        new_data <- new_data %>%
                mutate_at(.vars = integer_fields, as.integer)
        if (generic_name) {
                parent_field_name <- gsub("\\(","\\\\\\(", parent_field_name)
                parent_field_name <- gsub("\\)","\\\\\\)", parent_field_name)
                names(new_data) <- gsub(parent_field_name, "ComparedtoParentvalueorpercentiles", names(new_data))

        }

        return(new_data)
}

retrieve_all_area_data <- function(data, IndicatorID, ProfileID, AreaTypeID, ParentAreaTypeID, generic_name, path) {
        if (missing(ProfileID)) {
                all_area_data <- apply(data, 1,
                                       function(x) retrieve_indicator(IndicatorIDs = x[IndicatorID],
                                                                      ChildAreaTypeIDs = x[AreaTypeID],
                                                                      ParentAreaTypeIDs = x[ParentAreaTypeID],
                                                                      generic_name = generic_name,
                                                                      path = path)) %>%
                        bind_rows()
        } else {
                all_area_data <- apply(data, 1,
                                       function(x) retrieve_indicator(IndicatorIDs = x[IndicatorID],
                                                                      ProfileIDs = x[ProfileID],
                                                                      ChildAreaTypeIDs = x[AreaTypeID],
                                                                      ParentAreaTypeIDs = x[ParentAreaTypeID],
                                                                      generic_name = generic_name,
                                                                      path = path)) %>%
                        bind_rows()
        }

        return(all_area_data)

}
