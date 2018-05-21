#' Live profiles
#'
#' Outputs a data frame of live profiles that data are available for in
#' Fingertips \url{http://fingertips.phe.org.uk/}
#' @return A data frame of live profile ids and names along with their domain
#'   names and ids.
#' @inheritParams indicators
#' @param ProfileName Character vector, full name of profile(s)
#' @examples
#' \dontrun{
#' # Returns a complete data frame of domains and their profiles
#' profiles()}
#'
#' # Returns a data frame of all of the domains in the Public Health Outcomes Framework
#' profiles(ProfileName = "Public Health Outcomes Framework")
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config use_proxy
#' @importFrom curl ie_get_proxy_for_url
#' @family lookup functions
#' @seealso \code{\link{area_types}} for area type  and their parent mappings,
#'   \code{\link{indicators}} for indicator lookups,
#'   \code{\link{indicator_metadata}} for indicator metadata,
#'   \code{\link{deprivation_decile}} for deprivation decile lookups,
#'   \code{\link{category_types}} for category lookups,
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups,
#'   \code{\link{indicators_unique}} for unique indicatorids and their names,
#'   \code{\link{nearest_neighbours}} for a vector of nearest neighbours for an area and
#'   \code{\link{indicator_order}} for the order indicators are presented on the
#'   Fingertips website within a Domain
#' @export

profiles <- function(ProfileID = NULL, ProfileName = NULL, path) {
        if (missing(path)) path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))

        profiles <- paste0(path,"profiles") %>%
                GET(use_proxy(ie_get_proxy_for_url(.))) %>%
                content("text") %>%
                fromJSON
        idname <- profiles[,c("Id", "Name")]

        profiles <- lapply(profiles$GroupIds, data.frame)
        names(profiles) <- idname$Id
        profiles <- bind_rows(profiles,
                              .id = "profiles") %>%
                mutate(profiles = as.integer(profiles)) %>%
                left_join(idname, by = c("profiles" = "Id"))
        names(profiles) <- c("ID", "groupid", "Name")
        profiles <- profiles[, c("ID", "Name", "groupid")]
        if (!is.null(ProfileID)) {
                profiles <- filter(profiles, ID %in% ProfileID)
                if (nrow(profiles) == 0){
                        stop("ProfileID(s) are not in the list of profile IDs. Re-run the function without any inputs to see all possible IDs.")
                }
        } else if (!is.null(ProfileName)) {
                profiles <- filter(profiles, Name %in% ProfileName)
                if (nrow(profiles) == 0){
                        stop("Profile names are not in the list of profile names. Re-run the function without any inputs to see all possible names.")
                }
        }
        i <- profiles %>%
                group_by(ID) %>%
                summarise(combined = paste(groupid, collapse = "%2C"))
        groupDescriptions <- data.frame(ID = unique(profiles$ID),
                                        path = paste0(path,"group_metadata?group_ids=")) %>%
                left_join(i, by = c("ID" = "ID")) %>%
                mutate(dataurl = paste0(path, combined)) %>%
                               pull %>%
                lapply(function(dataurl) {
                        dataurl %>%
                                GET %>%
                                content("text") %>%
                                fromJSON
                }) %>%
                bind_rows
        groupDescriptions <- groupDescriptions %>%
                select(Id, Name)
        profiles <- rename(profiles,ProfileID = ID,ProfileName = Name, DomainID = groupid) %>%
                left_join(groupDescriptions, by = c("DomainID" = "Id")) %>%
                rename(DomainName = Name) %>%
                as_tibble
        return(profiles)
}
