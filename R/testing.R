#' @import dplyr
#' @import jsonlite
#' @import data.table
#' @import tidyjson

#works
ProfileID <- 8;DomainID <- 1938132733;AreaTypeID <- 102;ParentCode <- "E12000001"
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

#works
ProfileID <- 8;DomainID <- 1938132733;AreaTypeID <- 102;ParentCode <- NULL
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# works
ProfileID <- NULL;DomainID <- 1938132733;AreaTypeID <- 102;ParentCode <- "E12000001"
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# works
ProfileID <- NULL;DomainID <- 1938132733;AreaTypeID <- 102;ParentCode <- NULL
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# only returning one domain
ProfileID <- 8;DomainID <- NULL;AreaTypeID <- 102;ParentCode <- "E12000001"
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# returning duplicate records
ProfileID <- 8;DomainID <- NULL;AreaTypeID <- 102;ParentCode <- NULL
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

test <- fromJSON("http://fingertips.phe.org.uk/api/area_addresses/by_parent_area_code?parent_area_code=E45000016&area_type_id=102")
