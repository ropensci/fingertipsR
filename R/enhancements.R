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

#' High level statistics on Fingertips data
#'
#' A sentence that summarises the number of unique indicators, domains and
#' profiles
#' @return A string that summarises the high level statistics of indicators in
#'   Fingertips
#' @import dplyr
#' @examples
#' \dontrun{
#' # Returns a sentence describing number of indicators, domains and profiles in Fingertips
#' fingertips_stats()}
#' @export
fingertips_stats <- function() {
        cat("This may take a few moments... ")
        fingertips_stats <- indicators()
        summarised_stats <- fingertips_stats %>%
                summarise_if(is.integer, n_distinct)
        fingertips_stats <- sprintf("On %s Fingertips consisted of %o profiles, made up of %o indicators and %o distinct indicators.",
                                    format(Sys.Date(), "%d/%m/%Y"),
                                    summarised_stats$ProfileID,
                                    nrow(fingertips_stats),
                                    summarised_stats$IndicatorID)
        return(cat(fingertips_stats))

}
