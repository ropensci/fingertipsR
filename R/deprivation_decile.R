#' Deprivation deciles
#'
#' Outputs a data frame allocating deprivation decile to  area code based on the
#' Indices of Multiple Deprivation (IMD) produced by Department of Communities
#' and Local Government
#' @details This function uses the fingertips_data function to filter for the Index
#'   of multiple deprivation score for the year and area supplied, and returns
#'   the area code, along with the score and the deprivation decile, which is
#'   calculated using the ntile function from dplyr
#' @param AreaTypeID Numeric value, limited to either 102 (counties and unitary
#'   authorities), 101 (local authority districts and unitary authorities) or 7
#'   (General Practice); default is 102
#' @param Year Numeric value, representing the year of IMD release to be
#'   applied, limited to either 2010 or 2015; default is 2015
#' @examples
#' # Return 2015 deciles for counties and unitary authorities
#' deprivation_decile(102, 2015)
#' @return A lookup table providing deprivation decile and area code
#' @import dplyr
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{indicator_metadata}} for the metadata for each indicator,
#'   \code{\link{area_types}} for area types and their parent mappings,
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain

deprivation_decile <- function(AreaTypeID = 102, Year = 2015) {
        if (!(Year %in% c(2010, 2011, 2012, 2015))) {
                stop("Year must be either 2010, 2011, 2012 or 2015")
        }
        if (!(AreaTypeID %in% c(101, 102, 7, 3))) {
                stop("AreaTypeID must be either 101 (Local authority districts and Unitary Authorities), 102 (Counties and Unitary Authorities), 3 (Middle Super Output Areas) or 7 (General Practice).")
        }
        if ((AreaTypeID %in% c(101, 102, 3)) && !(Year %in% c(2015))) {
                stop("Year must be 2015 for AreaTypeID of 101, 102 or 3")
        }
        if ((AreaTypeID == 7 & !(Year %in% 2010:2012))) {
                stop("Year must be between 2010 and 2012 for AreaTypeID 7")
        }
        if (AreaTypeID == 7) {
                IndicatorID <- 338
                ProfileID <- 20
        } else if (AreaTypeID %in% c(101, 102)) {
                IndicatorID <- 91872
                ProfileID <- 19
        } else if (AreaTypeID == 3) {
                IndicatorID <- 93275
                ProfileID <- 143
        }
        if (AreaTypeID == 101) AreaFilter <- "District & UA"
        if (AreaTypeID == 102) AreaFilter <- "County & UA"
        if (AreaTypeID == 7) AreaFilter <- "GP"
        if (AreaTypeID == 3) AreaFilter <- "MSOA"
        path <- "https://fingertips.phe.org.uk/api/"
        deprivation_decile <- fingertips_data(IndicatorID = IndicatorID,
                                              AreaTypeID = AreaTypeID,
                                              ProfileID = ProfileID,
                                              path = path) %>%
                filter(AreaType == AreaFilter &
                               Timeperiod == Year) %>%
                select(AreaCode, Value) %>%
                rename(IMDscore = Value) %>%
                mutate(decile = as.integer(11 - ntile(IMDscore, 10)))
        return(deprivation_decile)
}
