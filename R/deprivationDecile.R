#' Get deprivation deciles
#'
#' Outputs a data frame allocating deprivation decile to  area code
#' @return A lookup table providing deprivation decile and area code
#' @import dplyr
#' @export

deprivationDecile <- function(AreaTypeID = 102, Year = 2015) {
        if (!(Year %in% c(2010,2015))) {
                stop("Year must be either 2010 or 2015")
        } else if (Year == 2010) {
                IndicatorID <- 338
        } else if (Year == 2015) {
                IndicatorID <- 91872
        }

        if (!(AreaTypeID %in% c(101,102))) {
                stop("AreaTypeID must be either 101 (Local authority districts and Unitary Authorities) or 102 (Counties and Unitary Authorities).")
        }

        DomainID <- 1938132983
        ProfileID <- 19

        ParentCodes <- getParentCodes(AreaTypeID)
        deprivationDecile <- retrieveData(ParentCodes = ParentCodes,
                                            DomainIDs = DomainID,
                                            ProfileIDs = ProfileID,
                                            AreaTypeIDs = AreaTypeID) %>%
                filter(.id == IndicatorID) %>%
                mutate(decile = ntile(V,10)) %>%
                select(AreaCode,decile)

        return(deprivationDecile)

}
