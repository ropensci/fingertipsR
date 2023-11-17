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
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' # Returns data for the two selected domains at county and unitary authority geography
#' reddata <- fingertips_redred(ProfileID = 26, AreaTypeID = 102)}
#' @family data extract functions
#' @export

fingertips_redred <- function(Comparator = "England", ...) {
        fingertips_redred <- fingertips_data(...)
        filter_field <- names(fingertips_redred)[grepl("^Compared", names(fingertips_redred))]
        if (Comparator == "England") {
                filter_field <- filter_field[grepl("^ComparedtoEngland", filter_field)]
        } else if (Comparator == "Parent") {
                filter_field <- filter_field[!grepl("Comparedtogoal|ComparedtoEngland", filter_field)]
        } else if (Comparator == "Goal") {
                filter_field <- filter_field[grepl("^Comparedtogoal", filter_field)]
        } else {
                stop("Comparator must be either England, Parent or Goal")
        }
        fingertips_redred <- fingertips_redred %>%
                group_by(.data$IndicatorID,
                         .data$Sex,
                         .data$Age,
                         .data$CategoryType,
                         .data$Category) %>%
                filter(.data$TimeperiodSortable == max(.data$TimeperiodSortable) &
                               grepl("[Ww]orse", .data$RecentTrend) &
                               grepl("[Ww]orse", !!as.name(filter_field)))
        return(fingertips_redred)
}

#' High level statistics on Fingertips data
#'
#' A sentence that summarises the number of indicators, unique indicators and
#' profiles
#' @inheritParams area_types
#' @return A string that summarises the high level statistics of indicators and
#'   profiles in Fingertips
#' @import dplyr
#' @examples
#' \dontrun{
#' # Returns a sentence describing number of indicators and profiles in Fingertips
#' fingertips_stats()}
#' @export
fingertips_stats <- function(proxy_settings = fingertips_proxy_settings()) {
        fingertips_stats <- indicators(proxy_settings = proxy_settings)
        summarised_stats <- fingertips_stats %>%
                summarise_if(is.integer, n_distinct)
        fingertips_stats <- sprintf("On %s Fingertips consisted of %s profiles, made up of %s indicators and %s distinct indicators.",
                                    format(Sys.Date(), "%d/%m/%Y"),
                                    summarised_stats$ProfileID,
                                    nrow(fingertips_stats),
                                    summarised_stats$IndicatorID)
        return(cat(fingertips_stats))

}
