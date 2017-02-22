#' Area types
#'
#' Outputs a data frame of area type ids and their descriptions
#' @return A data frame of area type ids and their descriptions
#' @import dplyr
#' @import tidyjson
#' @export

areaTypes <- function(){
        path <- "http://fingertips.phe.org.uk/api/"
        areaTypes <- fromJSON(paste0(path,
                                     "area_types"))
        areaTypes <- areaTypes[areaTypes$IsSearchable==TRUE,c("Id","Name")]
        names(areaTypes) <- c("AreaID","AreaName")

        parentAreas <- paste0(path,"area_types/parent_area_types")  %>%
                gather_array %>%                                     # stack the users
                spread_values(Id = jstring("Id"),
                              Name = jstring("Name"),
                              Short = jstring("Short"))  %>%          # extract the user name
                enter_object("ParentAreaTypes") %>%
                gather_array  %>%       # stack the purchases
                spread_values(ParentAreaID = jstring("Id"),
                              ParentAreaName = jstring("Name")) %>%
                select(Id,ParentAreaID,ParentAreaName) %>%
                rename(AreaID = Id) %>%
                mutate(AreaID = as.numeric(AreaID),
                       ParentAreaID = as.numeric(ParentAreaID)) %>%
                data.frame()

        areaTypes <- left_join(areaTypes, parentAreas, by = c("AreaID" = "AreaID"))
        return(areaTypes)
}
