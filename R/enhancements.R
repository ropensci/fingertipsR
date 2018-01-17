#' Red significance and red trend
#'
#' Filters data returned by the fingertips_data function for values for areas
#' that are trending statistically significantly worse and the spot value is
#' significantly worse than the comparator (England or Parent) value in the
#' latest year of that indicator
#' @return A data frame of data extracted from
#' the Fingertips API
#' @param Comparator String, either "England" or "Parent" to determine which
#'   field to compare the spot value significance to
#' @param ... Parameters provided to fingertips_data()
#' @examples
#' \dontrun{
#' # Returns data for the two selected domains at county and unitary authority geography
#' reddata <- fingertips_redred(ProfileID = 26, AreaTypeID = 102)}
#' @family data extract functions
#' @export

fingertips_redred <- function(Comparator = "England", ...) {
        path <- "https://fingertips.phe.org.uk/api/"
        if (Comparator == "England") {
                fingertips_redred <- fingertips_data(path = path, ...) %>%
                        group_by(IndicatorID, Sex, Age, CategoryType, Category) %>%
                        filter(TimeperiodSortable == max(TimeperiodSortable) &
                                       grepl("[Ww]orse",RecentTrend) &
                                       grepl("[Ww]orse", ComparedtoEnglandvalueorpercentiles))
        } else if (Comparator == "Parent") {
                fingertips_redred <- fingertips_data(path = path, ...) %>%
                        group_by(IndicatorID, Sex, Age, CategoryType, Category) %>%
                        filter(TimeperiodSortable == max(TimeperiodSortable) &
                                       grepl("[Ww]orse",RecentTrend) &
                                       grepl("[Ww]orse", Comparedtosubnationalparentvalueorpercentiles))
        } else {
                stop("Comparator must be either England or Parent")
        }
        return(fingertips_redred)
}
