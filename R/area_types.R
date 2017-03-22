#' Area types
#'
#' Outputs a data frame of area type ids and their descriptions
#' @return A data frame of area type ids and their descriptions
#' @import dplyr
#' @import tidyjson
#' @export

area_types <- function(){
        path <- "http://fingertips.phe.org.uk/api/"
        area_types <- fromJSON(paste0(path,
                                     "area_types"))
        area_types <- area_types[area_types$IsSearchable==TRUE,c("Id","Name")]
        names(area_types) <- c("AreaID","AreaName")

        parentAreas <- paste0(path,"area_types/parent_area_types")  %>%
                gather_array %>%
                spread_values(Id = jstring("Id"),
                              Name = jstring("Name"),
                              Short = jstring("Short"))  %>%
                enter_object("ParentAreaTypes") %>%
                gather_array  %>%
                spread_values(ParentAreaID = jstring("Id"),
                              ParentAreaName = jstring("Name")) %>%
                select(Id,ParentAreaID,ParentAreaName) %>%
                rename(AreaID = Id) %>%
                mutate(AreaID = as.numeric(AreaID),
                       ParentAreaID = as.numeric(ParentAreaID)) %>%
                data.frame()

        area_types <- left_join(area_types, parentAreas, by = c("AreaID" = "AreaID"))
        return(area_types)
}
