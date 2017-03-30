## ----packages, echo=FALSE------------------------------------------------
library(fingertips)
library(ggplot2)

## ----area type-----------------------------------------------------------
areaTypes <- area_types()
DT::datatable(areaTypes, filter = "top", rownames = FALSE)


## ----dist, echo=FALSE----------------------------------------------------
knitr::kable(areaTypes[areaTypes$AreaID == 102, c("ParentAreaID","ParentAreaName")], row.names = FALSE)

## ----deprivation---------------------------------------------------------
dep <- deprivation_decile(AreaTypeID = 102, Year = 2015)
DT::datatable(dep, filter = "top", rownames = FALSE)

## ----extract-------------------------------------------------------------
indicators <- c(90362, 90366)
data <- fingertips_test(IndicatorID = indicators,
                        AreaTypeID = 102)
head(data)

## ----refine variables----------------------------------------------------
cols <- c("IndicatorID", "AreaCode", "Sex", "Timeperiod", "Value")
data <- data[data$AreaType == "County & UA" & data$Timeperiod == "2012 - 14", cols]

# merge deprivation onto data
data <- merge(data, dep, by.x = "AreaCode", by.y = "AreaCode", all.x = TRUE)

# remove NA values
data <- data[complete.cases(data),]
DT::datatable(data, filter = "top", rownames = FALSE)

## ----plot, fig.width=8, fig.height=5-------------------------------------
p <- ggplot(data, aes(x = IMDscore, y = Value, col = factor(IndicatorID)))
p <- p + 
        geom_point() +
        geom_smooth(se = FALSE, method = "loess") +
        facet_wrap(~ Sex) +
        scale_colour_manual(name = "Indicator",
                            breaks = c("90366", "90362"),
                            labels = c("Life expectancy", "Healthy life expectancy"),
                            values = c("#128c4a", "#88c857")) +
        scale_x_reverse() + 
        labs(x = "IMD deprivation",
             y = "Age",
             title = "Life expectancy and healthy life expectancy at birth \nfor Upper Tier Local Authorities (2012 - 2014)") +
        theme_bw()
print(p)

