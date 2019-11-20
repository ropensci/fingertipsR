#' Deprivation deciles
#'
#' Outputs a data frame allocating deprivation decile to  area code based on the
#' Indices of Multiple Deprivation (IMD) produced by Department of Communities
#' and Local Government
#' @details This function uses the fingertips_data function to filter for the
#'   Index of multiple deprivation score for the year and area supplied, and
#'   returns the area code, along with the score and the deprivation decile,
#'   which is calculated using the ntile function from dplyr
#' @param AreaTypeID Integer value, limited to one of 202, 201, 165, 154, 152,
#'   102, 101, 8, 7, 3; default is 102
#' @param Year Integer value, representing the year of IMD release to be
#'   applied, limited to 2015
#' @inheritParams indicators
#' @examples
#' # Return 2015 deciles for counties and unitary authorities (post 4/19)
#' deprivation_decile(202, 2015)
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

deprivation_decile <- function(AreaTypeID = 102, Year = 2015, path) {
        if (!(Year %in% c(2015))) {
                stop("Year must be 2015")
        }
        accepted_areatypes <- c(202, 201, 165, 154, 152, 102, 101, 8, 7, 3)
        if (!(AreaTypeID %in% accepted_areatypes)) {
                stop(paste("AreaTypeID must be one of", paste(accepted_areatypes, collapse = ", ")))
        }
        if (AreaTypeID %in% accepted_areatypes[!(accepted_areatypes %in% c(3, 152))]) {
                ProfileID <- 98
                IndicatorID <- 91872
        } else if (AreaTypeID %in% 152) {
                ProfileID <- 21
                IndicatorID <- 91872

        } else if (AreaTypeID == 3) {
                IndicatorID <- 93275
                ProfileID <- 143
        }

        if (missing(path)) path <- fingertips_endpoint()

        set_config(config(ssl_verifypeer = 0L))
        fingertips_ensure_api_available(endpoint = path)
        deprivation_decile <- fingertips_data(IndicatorID = IndicatorID,
                                              AreaTypeID = AreaTypeID,
                                              ProfileID = ProfileID,
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
