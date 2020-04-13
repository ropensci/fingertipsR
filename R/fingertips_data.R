#' Fingertips data
#'
#' Outputs a data frame of data from
#' \href{https://fingertips.phe.org.uk/}{Fingertips}. Note, this function can
#' take up to a few minutes to run (depending on internet connection speeds and
#' parameter selection).
#' @return A data frame of data extracted from the Fingertips API
#' @details Note, polarity of an indicator is not automatically returned (eg,
#'   whether a low value is good, bad or neither). Use the rank field for this
#'   to be returned (though it adds a lot of time to the query)
#' @inheritParams indicators
#' @param IndicatorID Numeric vector, id of the indicator of interest
#' @param ProfileID Numeric vector, id of profiles of interest. Indicator
#'   polarity can vary between profiles therefore if using one of the comparison
#'   fields it is recommended to complete this field as well as IndicatorID. If
#'   IndicatorID is populated, ProfileID can be ignored or must be the same
#'   length as IndicatorID (but can contain NAs).
#' @param AreaCode Character vector, ONS area code of area of interest
#' @param ParentAreaTypeID Numeric vector, the comparator area type for the data
#'   extracted; if NULL the function will use the first record for the specified
#'   `AreaTypeID` from the area_types() function
#' @param AreaTypeID Numeric vector, the Fingertips ID for the area type. This
#'   argument accepts "All", which returns data for all available area types for
#'   the indicator(s), though this can take a long time to run
#' @param categorytype TRUE or FALSE, determines whether the final table
#'   includes categorytype data where it exists. Default to FALSE
#' @param rank TRUE or FALSE, the rank of the area compared to other areas for
#'   that combination of indicator, sex, age, categorytype and category along
#'   with the indicator's polarity. 1 is lowest NAs will be bottom and ties will
#'   return the average position. The total count of areas with a non-NA value
#'   are returned also in AreaValuesCount
#' @param url_only TRUE or FALSE, return only the url of the api call as a
#'   character vector
#' @importFrom utils txtProgressBar
#' @examples
#' \dontrun{
#' # Returns data for the two selected domains at county and unitary authority geography
#' doms <- c(1000049,1938132983)
#' fingdata <- fingertips_data(DomainID = doms, AreaTypeID = 202)
#'
#' # Returns data at local authority district geography (AreaTypeID = 101)
#' # for the indicator with the id 22401
#' fingdata <- fingertips_data(22401, AreaTypeID = 101)
#'
#' # Returns same indicator with different comparisons due to indicator polarity
#' # differences between profiles on the website
#' # It is recommended to check the website to ensure consistency between your
#' # data extract here and the polarity required
#' fingdata <- fingertips_data(rep(90282,2),
#'                             ProfileID = c(19,93),
#'                             AreaTypeID = 202,
#'                             AreaCode = "E06000008")
#' fingdata <- fingdata[order(fingdata$TimeperiodSortable, fingdata$Sex),]
#'
#' # Returns data for all available area types for an indicator
#' fingdata <- fingertips_data(10101, AreaTypeID = "All")}
#' @family data extract functions
#' @export

fingertips_data <- function(IndicatorID = NULL,
                            AreaCode = NULL,
                            DomainID = NULL,
                            ProfileID = NULL,
                            AreaTypeID,
                            ParentAreaTypeID = NULL,
                            categorytype = FALSE,
                            rank = FALSE,
                            url_only = FALSE,
                            path) {

        if (missing(path)) path <- fingertips_endpoint()
        set_config(config(ssl_verifypeer = 0L))
        fingertips_ensure_api_available(endpoint = path)

        # ensure there are the correct inputs
        if (!is.null(IndicatorID)) {
                IndicatorIDs <- IndicatorID
                if (!is.null(DomainID)) {
                        warning("If IndicatorID is populated DomainID is ignored")
                }
                if (!is.null(ProfileID)){
                        if (length(ProfileID) == 1) {
                                ProfileIDs <- rep(ProfileID, length(IndicatorIDs))
                        } else if (length(ProfileID) != length(IndicatorID)) {
                                stop("If ProfileID and IndicatorID are populated, they must be the same length")
                        } else {
                                ProfileIDs <- ProfileID
                        }
                }
        } else {
                if (!is.null(DomainID)) {
                        DomainIDs <- DomainID
                        if (!is.null(ProfileID)) {
                                warning("DomainID is complete so ProfileID is ignored")
                        }
                } else {
                        if (!is.null(ProfileID)) {
                                ProfileIDs <- ProfileID
                        } else {
                                stop("One of IndicatorID, DomainID or ProfileID must have an input")
                        }
                }
        }

        if (missing(AreaTypeID)) stop("AreaTypeID must be defined")

        if (!(categorytype %in% c(TRUE, FALSE))){
                stop("categorytype input must be TRUE or FALSE")
        }

        # check on area details before calling data
        if (is.null(AreaTypeID)) {
                stop("AreaTypeID must have a value. Use function area_types() to see what values can be used.")
        } else {
                areaTypes <- area_types(path = path)
                if (AreaTypeID == "All") {
                        if (is.null(IndicatorID)) {
                                if (!is.null(ProfileID)) {
                                        ind_to_prof <- indicators(ProfileID = ProfileIDs, path = path) %>%
                                                select(IndicatorID, ProfileID)

                                } else if (!is.null(DomainID)) {
                                        ind_to_prof <- indicators(DomainID = DomainIDs, path = path) %>%
                                                select(IndicatorID, ProfileID)
                                        ProfileIDs <- unique(ind_to_prof$ProfileID)

                                }
                                ats <- indicator_areatypes() %>%
                                        filter(IndicatorID %in% unique(ind_to_prof$IndicatorID))
                                ind_to_prof <- ind_to_prof %>%
                                        left_join(ats, by = "IndicatorID")
                                ind_ats <- areas_by_profile(ind_to_prof$AreaTypeID,
                                                            ind_to_prof$ProfileID,
                                                            path)
                                if (!is.null(DomainID)) ind_ats <- ind_ats %>%
                                        filter(DomainID %in% DomainIDs)
                        } else {
                                if (!is.null(ProfileID)) {
                                        ind_to_prof <- indicators(ProfileID = ProfileIDs, path = path) %>%
                                                select(IndicatorID, ProfileID) %>%
                                                filter(IndicatorID %in% IndicatorIDs)
                                        ats <- indicator_areatypes()
                                        indicator_profile_inputs <- data.frame(IndicatorID = IndicatorIDs,
                                                                               ProfileID = ProfileIDs)
                                        ind_ats <- ind_to_prof %>%
                                                left_join(ats, by = "IndicatorID") %>%
                                                mutate(ParentAreaTypeID = 15) %>%
                                                inner_join(indicator_profile_inputs, by = c("IndicatorID", "ProfileID"))
                                } else {
                                        at <- area_types()
                                        ind_ats <- indicator_areatypes() %>%
                                                filter(IndicatorID %in% IndicatorIDs)

                                        # some area types only exist in ParentAreaTypeID - this identifies those
                                        parent_only <- at %>%
                                                mutate(parent_only = !(ParentAreaTypeID %in% unique(at$AreaTypeID))) %>%
                                                filter(parent_only == TRUE,
                                                       AreaTypeID %in% unique(ind_ats$AreaTypeID)) %>%
                                                select(-parent_only) %>%
                                                group_by(ParentAreaTypeID) %>%
                                                slice(1) %>%
                                                ungroup() %>%
                                                select(AreaTypeID, ParentAreaTypeID)
                                        remove_ats <- unique(c(parent_only$AreaTypeID,
                                                               parent_only$ParentAreaTypeID))
                                        at <- at %>%
                                                filter(AreaTypeID %in% unique(ind_ats$AreaTypeID),
                                                       ParentAreaTypeID %in% c(15, unique(ind_ats$AreaTypeID))) %>%
                                                filter(!(AreaTypeID %in% remove_ats),
                                                       !(ParentAreaTypeID %in% remove_ats)) %>%
                                                select(AreaTypeID) %>%
                                                unique() %>%
                                                mutate(ParentAreaTypeID = 15) %>%
                                                bind_rows(parent_only)
                                        ind_ats <- ind_ats %>%
                                                inner_join(at, by = "AreaTypeID")
                                }


                        }
                } else {
                        if (sum(!(AreaTypeID %in% c(15, areaTypes$AreaTypeID)) == TRUE) > 0) {
                                stop("Invalid AreaTypeID. Use function area_types() to see what values can be used.")
                        } else {
                                if (!is.null(AreaCode)) {
                                        areacodes <- AreaTypeID %>%
                                                lapply(function(i) {
                                                        paste0(path, "areas/by_area_type?area_type_id=", i) %>%
                                                                get_fingertips_api()
                                                }) %>%
                                                bind_rows
                                        if (sum(!(AreaCode %in% c("E92000001", areacodes$Code))==TRUE) > 0) {
                                                stop("Area code not contained in AreaTypeID.")
                                        }
                                }
                                ChildAreaTypeIDs <- AreaTypeID
                        }
                        if (is.null(ParentAreaTypeID)) {
                                areaTypes <- area_types(AreaTypeID = AreaTypeID, path = path) %>%
                                        group_by(AreaTypeID) %>%
                                        filter(row_number() == 1)
                                ParentAreaTypeIDs <- unique(areaTypes$ParentAreaTypeID)
                        } else {
                                areaTypes <- areaTypes[areaTypes$AreaTypeID %in% ChildAreaTypeIDs,]
                                if (sum(!(ParentAreaTypeID %in% areaTypes$ParentAreaTypeID)==TRUE) > 0) {
                                        warning("AreaTypeID not a child of ParentAreaTypeID. There may be duplicate values in data. Use function area_types() to see mappings of area type to parent area type.")
                                }
                                ParentAreaTypeIDs <- unique(ParentAreaTypeID)
                        }
                }


        }
        # this pulls the data from the API
        if (!is.null(IndicatorID)) {
                if (is.null(ProfileID)) {
                        if (AreaTypeID == "All") {
                                fingertips_data <- retrieve_all_area_data(ind_ats,
                                                                          IndicatorID = "IndicatorID",
                                                                          AreaTypeID = "AreaTypeID",
                                                                          ParentAreaTypeID = "ParentAreaTypeID",
                                                                          path = path)
                        } else {
                                fingertips_data <- retrieve_indicator(IndicatorIDs = IndicatorIDs,
                                                                      ChildAreaTypeIDs = ChildAreaTypeIDs,
                                                                      ParentAreaTypeIDs = ParentAreaTypeIDs,
                                                                      path = path)

                        }

                } else {
                        if (AreaTypeID == "All") {
                                fingertips_data <- retrieve_all_area_data(ind_ats,
                                                                          IndicatorID = "IndicatorID",
                                                                          ProfileID = "ProfileID",
                                                                          AreaTypeID = "AreaTypeID",
                                                                          ParentAreaTypeID = "ParentAreaTypeID",
                                                                          path = path)
                        } else {
                                fingertips_data <- retrieve_indicator(IndicatorIDs = IndicatorIDs,
                                                                      ProfileIDs = ProfileIDs,
                                                                      ChildAreaTypeIDs = ChildAreaTypeIDs,
                                                                      ParentAreaTypeIDs = ParentAreaTypeIDs,
                                                                      path = path)
                        }

                }
        } else {
                if (!is.null(DomainID)) {
                        if (AreaTypeID == "All") {
                                fingertips_data <- retrieve_all_area_data(ind_ats,
                                                                          IndicatorID = "IndicatorID",
                                                                          ProfileID = "ProfileID",
                                                                          AreaTypeID = "AreaTypeID",
                                                                          ParentAreaTypeID = "ParentAreaTypeID",
                                                                          path = path)
                        } else {
                                fingertips_data <- retrieve_domain(ChildAreaTypeIDs = ChildAreaTypeIDs,
                                                           ParentAreaTypeIDs = ParentAreaTypeIDs,
                                                           DomainIDs = DomainIDs,
                                                           path = path)
                        }
                } else {
                        if (!is.null(ProfileID)) {
                                if (AreaTypeID == "All") {
                                        fingertips_data <- retrieve_all_area_data(ind_ats,
                                                                                  IndicatorID = "IndicatorID",
                                                                                  ProfileID = "ProfileID",
                                                                                  AreaTypeID = "AreaTypeID",
                                                                                  ParentAreaTypeID = "ParentAreaTypeID",
                                                                                  path = path)
                                } else {
                                        fingertips_data <- retrieve_profile(ChildAreaTypeIDs = ChildAreaTypeIDs,
                                                                    ParentAreaTypeIDs = ParentAreaTypeIDs,
                                                                    ProfileIDs = ProfileIDs,
                                                                    path = path)
                                }
                        }
                }
        }

        if (url_only) {
                return(fingertips_data)
        } else {
                if (AreaTypeID == "All") {
                        pb <- txtProgressBar(style = 3)
                        data <- data.frame(dataurl = fingertips_data) %>%
                                mutate(percentage_complete = row_number() / n())
                        fingertips_data <- apply(data, 1,
                                                 function(x) new_data_formatting(dataurl = x["dataurl"],
                                                                                 generic_name = TRUE,
                                                                                 item_of_total = x["percentage_complete"],
                                                                                 progress_bar = pb)) %>%
                                bind_rows()
                        close(pb)
                } else {
                        fingertips_data <- Map(new_data_formatting,
                                               dataurl = fingertips_data,
                                               generic_name = FALSE) %>%
                                unname() %>%
                                bind_rows()
                }

        }
        names(fingertips_data) <- gsub("\\s","",names(fingertips_data))

        if (rank == TRUE) {
                inds <- unique(fingertips_data$IndicatorID)
                if (!is.null(ProfileID)) {
                        polarities <- indicator_metadata(inds,
                                                         ProfileID = ProfileIDs,
                                                         path = path) %>%
                                select(IndicatorID, Polarity)

                } else {
                        polarities <- indicator_metadata(inds,
                                                         path = path) %>%
                                select(IndicatorID, Polarity)

                }
                fingertips_data <- left_join(fingertips_data, polarities, by = c("IndicatorID" = "IndicatorID")) %>%
                        group_by(IndicatorID, Timeperiod, Sex, Age, CategoryType, Category, AreaType) %>%
                        mutate(Rank = rank(Value, na.last = "keep"),
                               AreaValuesCount = sum(!is.na(Value))) %>%
                        ungroup()

        }
        if (!is.null(AreaCode)) {
                fingertips_data <- fingertips_data[fingertips_data$AreaCode %in% AreaCode,] %>%
                        droplevels()
        }

        if (nrow(fingertips_data) > 0){
                fingertips_data <- fingertips_data[fingertips_data$AreaType != fingertips_data$ParentName,]
                fingertips_data[fingertips_data==""] <- NA

                if (categorytype == FALSE) {
                        fingertips_data <- fingertips_data %>%
                                filter(is.na(CategoryType))
                }
        }
        return(unique(fingertips_data))
}
