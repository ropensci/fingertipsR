#' Deprivation deciles
#'
#' Outputs a data frame allocating deprivation decile to  area code base on the Indices of Multiple Deprivation (IMD) produced by Department of Communities and Local Government
#' @param AreaTypeID Numeric value, limited to either 102 (counties and unitary
#'   authorities), 101 (local authority districts and unitary authorities) or 7 (General Practice); default is 102
#' @param Year Numeric value, representing the year of IMD release to be applied, limited to either 2010 or 2015; default is 2015
#' @examples # Return 2015 deciles for counties and unitary authorities
#' @examples deprivation_decile()
#'
#' @examples # Return 2010 deciles for local authority districts and unitary authorities
#' @examples deprivation_decile(101, 2010)
#' @return A lookup table providing deprivation decile and area code
#' @import dplyr
#' @export
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups
#'   \code{\link{indicator_metadata}} for the metadata for each indicator and
#'   \code{\link{area_types}} for area types and their parent mappings and
#'   \code{\link{category_types}} for category lookups and
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups and
#'   \code{\link{indicators_unique}} for unique indicatorids and their names

deprivation_decile <- function(AreaTypeID = 102, Year = 2015) {
        if (!(Year %in% c(2010, 2011, 2012, 2015))) {
                stop("Year must be either 2010 or 2015")
        } else if (Year %in% c(2010, 2011, 2012)) {
                IndicatorID <- 338
        } else if (Year == 2015) {
                IndicatorID <- 91872
        }
        if (AreaTypeID == 101) {
                if (Year %in% c(2010, 2015)) {
                        AreaFilter <- "District & UA"
                } else if (Year %in% c(2011, 2012)) {
                        stop("Year must be either 2010 or 2015 for AreaTypeID of 101 or 102")
                }
        } else if (AreaTypeID == 102) {
                if (Year %in% c(2010, 2015)) {
                        AreaFilter <- "County & UA"
                } else if (Year %in% c(2011, 2012)) {
                        stop("Year must be either 2010 or 2015 for AreaTypeID of 101 or 102")
                }
        } else if (AreaTypeID == 7) {
                AreaFilter <- "GP"
        } else {
                stop("AreaTypeID must be either 101 (Local authority districts and Unitary Authorities), 102 (Counties and Unitary Authorities) or 7 (General Practice).")
        }
        deprivation_decile <- fingertips_data(IndicatorID = IndicatorID, AreaTypeID = AreaTypeID) %>%
                filter(AreaType == AreaFilter &
                               Timeperiod == Year) %>%
                select(AreaCode, Value) %>%
                rename(IMDscore = Value) %>%
                mutate(decile = 11 - ntile(IMDscore, 10))
        return(deprivation_decile)
}
