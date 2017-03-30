## ----packages------------------------------------------------------------
library(fingertips)

## ----area type-----------------------------------------------------------
areaTypes <- area_types()
knitr::kable(areaTypes)


## ----dist, echo=FALSE----------------------------------------------------
knitr::kable(areaTypes[areaTypes$AreaID == 102, c("ParentAreaID","ParentAreaName")], row.names = FALSE)

## ----deprivation---------------------------------------------------------
dep <- deprivation_decile(AreaTypeID = 102, Year = 2015)
knitr::kable(head((dep), 10))

## ----extract-------------------------------------------------------------
indicators <- c(90362, 90366)
data <- fingertips_test(IndicatorID = indicators,
                        AreaTypeID = 102)
str(data)

## ----refine variables----------------------------------------------------
cols <- c("IndicatorID", "AreaCode", "Sex", "Timeperiod", "Value")
data <- data[data$AreaType == "County & UA" & data$Timeperiod == "2012 - 14", cols]

# merge deprivation onto data
data <- merge(data, dep, by.x = "AreaCode", by.y = "AreaCode", all.x = TRUE)

# remove NA values
data <- data[complete.cases(data),]
knitr::kable(head(data,10))

## ----plot, fig.width=8, fig.height=5-------------------------------------
data$Colour <- ifelse(data$IndicatorID == 90366, "#88c857", "#128c4a")
datamale <- data[data$Sex == "Male",]
datafemale <- data[data$Sex == "Female",]

lomalehealthy <- smooth.spline(datamale[datamale$IndicatorID == 90362, "IMDscore"], 
                               datamale[datamale$IndicatorID == 90362, "Value"], 
                               spar=0.8)
lomalelife <- smooth.spline(datamale[datamale$IndicatorID == 90366, "IMDscore"], 
                            datamale[datamale$IndicatorID == 90366, "Value"],
                            spar=0.8)

lofemalehealthy <- smooth.spline(datafemale[datafemale$IndicatorID == 90362, "IMDscore"], 
                               datafemale[datafemale$IndicatorID == 90362, "Value"], 
                               spar=0.8)
lofemalelife <- smooth.spline(datafemale[datafemale$IndicatorID == 90366, "IMDscore"], 
                            datafemale[datafemale$IndicatorID == 90366, "Value"],
                            spar=0.8)

par(mfrow = c(1, 2),
    oma=c(1, 1, 2.5, 1))
plot(datamale$IMDscore, 
     datamale$Value, 
     col = datamale$Colour, 
     cex = 0.8,
     pch = 16, 
     xlab = "IMD deprivation",
     ylab = "Age",
     font.main = 1,
     cex.main = 0.85,
     main = "Male",
     xlim = rev(range(data$IMDscore)),
     ylim = range(data$Value))
lines(lomalehealthy,
      col="black",
      lwd=2)
lines(lomalelife,
      col="black",
      lwd=2)
legend(x = 43, 
       y = 86, 
       legend = c("Healthy life expectancy","Life expectancy"), 
       col = c("#128c4a", "#88c857"), 
       pch = 16,
       cex = 0.6)

plot(datafemale$IMDscore, 
     datafemale$Value, 
     col = datafemale$Colour, 
     cex = 0.8,
     pch = 16, 
     xlab = "IMD deprivation",
     ylab = "Age",
     font.main = 1,
     cex.main = 0.85,
     main = "Female",
     xlim = rev(range(data$IMDscore)),
     ylim = range(data$Value))
lines(predict(lofemalehealthy), col="black", lwd=2)
lines(predict(lofemalelife), col="black", lwd=2)
mtext("Life expectancy and healthy life expectancy at birth \nfor upper tier local authorities (2012 - 2014)",
      outer = TRUE, 
      cex = 1.4,
      font = 2)


