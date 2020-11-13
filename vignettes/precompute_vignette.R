# pre-compute the vignette
# https://ropensci.org/technotes/2019/12/08/precompute-vignettes/
knitr::knit("vignettes/lifeExpectancy.Rmd.orig", output = "vignettes/lifeExpectancy.Rmd")
knitr::knit("vignettes/selectIndicatorsRedRed.Rmd.orig", output = "vignettes/selectIndicatorsRedRed.Rmd")
images_to_move <- list.files(pattern = ".png$",
                             full.names = TRUE)

# Must manually move image files from fingertipsR/ to fingertipsR/vignettes/ after knit
for (i in images_to_move) file.rename(from = i, to = gsub("\\./", "./vignettes/", i))
