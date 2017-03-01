library(data.table);library(dplyr);library(jsonlite);library(tidyjson)

#works (1500)
ProfileID <- 8;DomainID <- 1938132733;AreaTypeID <- 102;ParentCode <- "E12000001"
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

#works (19000)
ProfileID <- 8;DomainID <- 1938132733;AreaTypeID <- 102;ParentCode <- NULL
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# works (1500)
ProfileID <- NULL;DomainID <- 1938132733;AreaTypeID <- 102;ParentCode <- "E12000001"
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# works (19000)
ProfileID <- NULL;DomainID <- 1938132733;AreaTypeID <- 102;ParentCode <- NULL
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# works (12036)
ProfileID <- 8;DomainID <- NULL;AreaTypeID <- 102;ParentCode <- "E12000001"
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# works (140296)
ProfileID <- 8;DomainID <- NULL;AreaTypeID <- 102;ParentCode <- NULL
t <- fingertipsData(ProfileID = ProfileID,DomainID = DomainID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)

# works (1836)
IndicatorID <- 1107;AreaTypeID <- 102;ParentCode <- "E12000001"
t <- fingertipsData(IndicatorID=IndicatorID,AreaTypeID = AreaTypeID,ParentCode = ParentCode)
