#' Indicator metadata
#'
#' Outputs a data frame containing the metadata for selected indicators. Note, this
#' function can take up to a few minutes to run (depending on internet
#' connection speeds)
#' @param IndicatorID Numeric vector, id of the indicator of interest. Also accepts "All".
#' @inheritParams fingertips_data
#' @inheritParams area_types
#' @examples
#' \dontrun{
#' # Returns metadata for indicator ID 90362 and 1107
#' indicatorIDs <- c(90362, 1107)
#' indicator_metadata(indicatorIDs)
#'
#' # Returns metadata for the indicators within the domain 1000101
#' indicator_metadata(DomainID = 1000101)
#'
#' # Returns metadata for the indicators within the profile with the ID 129
#' indicator_metadata(ProfileID = 129)}
#' @return The metadata associated with each indicator/domain/profile identified
#' @importFrom utils read.csv
#' @importFrom readr read_csv cols
#' @importFrom rlang .data
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation lookups,
#'   \code{\link{area_types}} for area types and their parent mappings,
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain
#' @export

indicator_metadata <- function(IndicatorID = NULL,
                               DomainID = NULL,
                               ProfileID = NULL,
                               proxy_settings = "default",
                               path) {
  set_config(config(ssl_verifypeer = 0L))
  types <- cols(`Indicator ID` = "i",
                Indicator = "c",
                `Definition` = "c",
                `Rationale` = "c",
                `Data source` = "c",
                `Indicator source` = "c",
                `Methodology` = "c",
                `Standard population/values` = "c",
                `Confidence interval details` = "c",
                `Source of numerator` = "c",
                `Definition of numerator` = "c",
                `Source of denominator` = "c",
                `Definition of denominator` = "c",
                `Disclosure control` = "c",
                `Caveats` = "c",
                `Copyright` = "c",
                `Data re-use` = "c",
                `Links` = "c",
                `Indicator number` = "c",
                `Notes` = "c",
                `Frequency` = "c",
                `Rounding` = "c",
                `Indicator Content` = "c",
                `Specific rationale` = "c",
                `Unit` = "c",
                `Value type` = "c",
                `Year type` = "c",
                `Polarity` = "c",
                `Impact of COVID-19` = "c")

  if (missing(path)) path <- fingertips_endpoint()
  set_config(config(ssl_verifypeer = 0L))
  fingertips_ensure_api_available(
    endpoint = path,
    proxy_settings = proxy_settings)
  if (!(is.null(IndicatorID))) {
    AllIndicators <- indicators(
      proxy_settings = proxy_settings,
      path = path)

    if (identical(IndicatorID, "All")) {
      dataurl <- paste0(path, "indicator_metadata/csv/all")
      indicator_metadata <- dataurl %>%
        get_fingertips_api(
          content_type = "parsed",
          col_types = types,
          proxy_settings = proxy_settings
        )

    } else if (sum(AllIndicators$IndicatorID %in% IndicatorID) == 0) {
      stop("IndicatorID(s) do not exist, use indicators() to identify existing indicators")
    } else {
      path <- paste0(path, "indicator_metadata/csv/by_indicator_id?indicator_ids=")
      dataurl <- paste0(path,
                        paste(IndicatorID, collapse = "%2C"))
      if (!(is.null(ProfileID)) & length(ProfileID == 1))
        dataurl <- paste0(dataurl, "&profile_id=", ProfileID)

      indicator_metadata <- dataurl %>%
        lapply(
          get_fingertips_api,
          content_type = "parsed",
          col_types = types,
          proxy_settings = proxy_settings
        ) %>%
        bind_rows()
    }

  } else if (!(is.null(DomainID))) {
    AllProfiles <- profiles(
      proxy_settings = proxy_settings,
      path = path)
    if (sum(AllProfiles$DomainID %in% DomainID) == 0){
      stop("DomainID(s) do not exist, use profiles() to identify existing domains")
    }
    path <- paste0(path, "indicator_metadata/csv/by_group_id?group_id=")
    indicator_metadata <- paste0(path, DomainID) %>%
      lapply(
        get_fingertips_api,
        content_type = "parsed",
        col_types = types,
        proxy_settings = proxy_settings
      ) %>%
      bind_rows()
  } else if (!(is.null(ProfileID))) {
    AllProfiles <- profiles(
      proxy_settings = proxy_settings,
      path = path)
    if (sum(AllProfiles$ProfileID %in% ProfileID) == 0){
      stop("ProfileID(s) do not exist, use profiles() to identify existing profiles")
    }
    path <- paste0(path, "indicator_metadata/csv/by_profile_id?profile_id=")
    indicator_metadata <- paste0(path, ProfileID) %>%
      lapply(
        get_fingertips_api,
        content_type = "parsed",
        col_types = types,
        proxy_settings = proxy_settings
      ) %>%
      bind_rows()
  } else {
    stop("One of IndicatorID, DomainID or ProfileID must be populated")
  }
  colnames(indicator_metadata)[colnames(indicator_metadata)=="Indicator ID"] <- "IndicatorID"
  return(indicator_metadata)
}


#' Indicator update information
#'
#' Outputs a data frame which provides a date of when an indicator was last update
#' @param IndicatorID Integer, id of the indicators of interest
#' @param ProfileID Integer (optional), whether to restrict the indicators to a particular profile
#' @inheritParams fingertips_data
#' @inheritParams area_types
#' @examples
#' \dontrun{
#' # Returns metadata for indicator ID 90362 and 1107
#' indicatorIDs <- c(90362, 1107)
#' indicator_update_information(indicatorIDs)}
#' @return The date of latest data update for selected indicators
#' @importFrom rlang .data
#' @export

indicator_update_information <- function(IndicatorID, ProfileID = NULL,
                                         proxy_settings = "default", path) {

  if (missing(path)) path <- fingertips_endpoint()
  set_config(config(ssl_verifypeer = 0L))
  fingertips_ensure_api_available(
    endpoint = path,
    proxy_settings = proxy_settings)


  if (!is.null(ProfileID)) {

    IndicatorID_collapsed <- paste(IndicatorID,
                                   collapse = "%2C")

    profile_check <- indicators(ProfileID = ProfileID,
                                proxy_settings = proxy_settings,
                                path = path)
    if (!any(IndicatorID %in% profile_check$IndicatorID))
      stop("Not all IndicatorIDs are avaible within the provided ProfileID(s)")

    ProfileID_collapsed <- paste(ProfileID,
                         collapse = "%2C")
    api_path <- sprintf("indicator_metadata/by_indicator_id?indicator_ids=%s&restrict_to_profile_ids=%s",
                        IndicatorID_collapsed, ProfileID_collapsed)
  } else {

    if (length(IndicatorID) > 100) {
      IndicatorID_collapsed <- split(IndicatorID,
                        ceiling(seq_along(IndicatorID) / 100)) %>%
        lapply(paste,
               collapse = "%2C") %>%
        unlist() %>%
        unname()
    } else {
      IndicatorID_collapsed <- paste(IndicatorID,
                                     collapse = "%2C")

    }
    api_path <- sprintf("indicator_metadata/by_indicator_id?indicator_ids=%s",
                        IndicatorID_collapsed)
  }

  info <- paste0(path,
                 api_path) %>%
    lapply(function(indicator_ids) {
      indicator_ids %>%
        get_fingertips_api(
          proxy_settings = proxy_settings
        )
    }) %>%
    unlist(recursive = FALSE) %>%
    lapply(function(x) x[c("IID", "DataChange")]) %>%
    lapply(unlist) %>%
    lapply(
      function(x)
        structure(
          as.character(x),
          names = names(x)
        )
    ) %>%
    dplyr::bind_rows() %>%
    dplyr::select(IndicatorID = "IID",
                  LastDataUploadDate = "DataChange.LastUploadedAt") %>%
    dplyr::mutate(
      IndicatorID = as.integer(.data$IndicatorID),
      LastDataUploadDate = as.Date(.data$LastDataUploadDate))

  return(info)
}
