#' Deprivation deciles
#'
#' Outputs a data frame allocating deprivation decile to  area code based on the
#' Indices of Multiple Deprivation (IMD) produced by Department of Communities
#' and Local Government
#' @details This function uses the fingertips_data function to filter for the
#'   Index of multiple deprivation score for the year and area supplied, and
#'   returns the area code, along with the score and the deprivation decile,
#'   which is calculated using the ntile function from dplyr
#' @param AreaTypeID Integer value; this function uses the IndicatorIDs 91872,
#'   93275 and 93553, please use the \code{indicator_areatypes()} function to
#'   see what AreaTypeIDs are available
#' @param Year Integer value, representing the year of IMD release to be
#'   applied, limited to 2015 or 2019
#' @inheritParams indicators
#' @examples
#' \dontrun{
#' # Return 2019 deprivation scores for Sustainability and Transformation Footprints
#' deprivation_decile(120, 2019)}
#' @return A lookup table providing deprivation decile and area code
#' @import dplyr
#' @importFrom rlang  .data
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{indicator_metadata}} for the metadata for each indicator,
#'   \code{\link{area_types}} for area types and their parent mappings,
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an
#'   area and \code{\link{indicator_order}} for the order indicators are
#'   presented on the Fingertips website within a Domain

deprivation_decile <- function(AreaTypeID, Year = 2019, path) {
        if (missing(AreaTypeID)) stop("AreaTypeID must be specified")

        if (!(Year %in% c(2015, 2019))) {
                stop("Year must be 2015 or 2019")
        }

        indicators_2015 <- c(91872, 93275)
        accepted_areatypes_2015 <- lapply(indicators_2015, indicator_areatypes) %>%
                bind_rows()

        indicators_2019 <- 93553
        accepted_areatypes_2019 <- lapply(indicators_2019, indicator_areatypes) %>%
                bind_rows()

        accepted_areatypes <- unique(c(accepted_areatypes_2015$AreaTypeID,
                                       accepted_areatypes_2019$AreaTypeID))

        if (!(AreaTypeID %in% accepted_areatypes)) {
                stop("AreaTypeID not available")
        }
        area_type_filter <- AreaTypeID
        if (Year == 2015) {
                if (!(AreaTypeID %in% accepted_areatypes_2015$AreaTypeID)) {
                        stop("AreaTypeID unavailable for 2015")
                }
                IndicatorID <- accepted_areatypes_2015 %>%
                        filter(AreaTypeID == area_type_filter) %>%
                        slice(1) %>%
                        pull(IndicatorID)
        } else if (Year == 2019) {
                if (!(AreaTypeID %in% accepted_areatypes_2019$AreaTypeID)) {
                        stop("AreaTypeID unavailable for 2019")
                }
                IndicatorID <- accepted_areatypes_2019 %>%
                        filter(AreaTypeID == area_type_filter) %>%
                        slice(1) %>%
                        pull(IndicatorID)
        }


        if (missing(path)) path <- fingertips_endpoint()

        set_config(config(ssl_verifypeer = 0L))
        fingertips_ensure_api_available(endpoint = path)
        deprivation_decile <- fingertips_data(IndicatorID = IndicatorID,
                                              AreaTypeID = AreaTypeID,
                                              path = path) %>%
                group_by(AreaType) %>%
                mutate(records = n()) %>%
                ungroup() %>%
                filter(.data$records == max(.data$records),
                       Timeperiod == Year) %>%
                select(AreaCode, Value) %>%
                rename(IMDscore = Value) %>%
                mutate(decile = as.integer(11 - ntile(IMDscore, 10)))

        return(deprivation_decile)
}
