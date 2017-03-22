#' Live profiles
#'
#' Outputs a data frame of live profiles that data are available for in [Fingertips]<http://fingertips.phe.org.uk/>
#' @return A data frame of live profile ids and names along with their domain names and ids.
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @import tidyjson
#' @export

profiles <- function(profileId = NULL, profileName = NULL) {

        path <- "http://fingertips.phe.org.uk/api/"
        profiles <- gather_array(paste0(path,"profiles")) %>%
                #gather_array %>%
                spread_values(ID = jnumber("Id"),
                              Name = jstring("Name")
                              #Key = jstring("Key")
                ) %>%
                enter_object("GroupIds") %>%
                gather_array %>%
                append_values_number("groupid") %>%
                select(ID, Name, groupid)

        if (!is.null(profileId)) {
                profiles <- filter(profiles, ID %in% profileId)
                if (nrow(profiles) == 0){
                        stop("Profile IDs are not in the list of currently live profile IDs. Re-run the function without any inputs to see all possible IDs.")
                }
        } else if (!is.null(profileName)) {
                profiles <- filter(profiles, Name %in% profileName)
                if (nrow(profiles) == 0){
                        stop("Profile names are not in the list of currently live profile names. Re-run the function without any inputs to see all possible names.")
                }
        }


        groupDescriptions <- data.frame()
        for (i in unique(profiles$ID)){
                query <- paste0(path,"group_metadata?group_ids=",
                                paste(profiles$groupid[profiles$ID==i], collapse = "%2C"))
                groupDescriptions <- rbind(fromJSON(query), groupDescriptions)
        }
        groupDescriptions <- groupDescriptions %>%
                select(Id, Name)

        profiles <- rename(profiles,ProfileID = ID,ProfileName = Name, DomainID = groupid) %>%
                left_join(groupDescriptions, by = c("DomainID" = "Id")) %>%
                rename(DomainName = Name)

        closeAllConnections()
        return(profiles)

}
