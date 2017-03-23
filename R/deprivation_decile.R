#' Deprivation deciles
#'
#' Outputs a data frame allocating deprivation decile to  area code base on the Indices of Multiple Deprivation (IMD) produced by CIPFA
#' @param AreaTypeID Numeric value, limited to either 102 (counties and unitary
#'   authorities) or 101 (local authority districts and unitary authorities); default is 102
#' @param Year Numeric value, representing the year of IMD relsease to be applied, limited to either 2010 or 2015; default is 2015
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
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{area_types}} for area types and their parent mappings

deprivation_decile <- function(AreaTypeID = 102, Year = 2015) {
        if (!(Year %in% c(2010,2015))) {
                stop("Year must be either 2010 or 2015")
        } else if (Year == 2010) {
                IndicatorID <- 338
        } else if (Year == 2015) {
                IndicatorID <- 91872
        }

        if (!(AreaTypeID %in% c(101, 102))) {
                stop("AreaTypeID must be either 101 (Local authority districts and Unitary Authorities) or 102 (Counties and Unitary Authorities).")
        }

        DomainID <- 1938132983
        ProfileID <- 19

        ParentCodes <- get_parent_codes(AreaTypeID)
        deprivation_decile <- retrieve_data(ParentCodes = ParentCodes,
                                            DomainIDs = DomainID,
                                            ProfileIDs = ProfileID,
                                            AreaTypeIDs = AreaTypeID) %>%
                filter(.id == IndicatorID) %>%
                mutate(decile = 11 - ntile(V,10)) %>%
                select(AreaCode,decile)

        return(deprivation_decile)

}
