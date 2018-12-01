# this hastag (#) is to make comments for ourself in the code
library(aquap2) # load aqap2 package so we can use its functions

# 1) creat sample list based on metadata file --------
esl(form = "xls", rnd = FALSE, showFirstRows = TRUE, timeEstimate = TRUE) 
#
#
# 2) import data after experiment and copying all files on place --------
fullData <- gfd(ttl = FALSE)
#
#
# 3) plot raw spectra from dataset --------
plot(fullData, colorBy = "C_waterTemp")
#
#
# 4) set analysis procedure file for pca using the range 1300-1600 nm and run pca analysis -------
## set in anproc.r: 
### spl.wl <- c("1300-to-1600")
### do.pca <- TRUE
### pca.colorBy <- c("C_Water", "C_waterTemp")
cu <- gdmm(fullData)
# plot the results of pca
plot(cu)
#
#
# 5) remove unvanted data from our dataset --------
dataReduced <- ssc(fullData, C_Water == "AIR", include=FALSE)
#
#
# 6) do pca again with the reduced dateset --------
cu2 <- gdmm(dataReduced)
# plot the results of pca calculated on reduced dataset
plot(cu2, pg.fns = "_noAir") # pg.fns is to change the name of pdf not to overwrite previous ones 
#
#
# 7) set analysis procedure file for diff ranges and plot raw spectra of diff ranges --------
## set in anproc.r: 
### spl.wl <- c("680-to-800", "900-to-1040", "1300-to-1600")
### do.pca <- FALSE
cu3 <- gdmm(dataReduced)
# plot spectra
plot_spectra(cu3, colorBy = "C_waterTemp", pg.fns = "_byRange") 
#
#
# 7a) set analysis procedure to do pre-treatment --------
## set in anproc.r: 
### dpt.pre <- "snv"
cu3 <- gdmm(dataReduced, getap(dpt.pre = "snv"))
# plot the results of pca calculated on reduced dataset
plot_spectra(cu3, colorBy = "C_waterTemp", pg.fns = "_byRangeSNV") 
#
#
# 8) have a look at on the structure of data and cube (cu2), not required for analysis --------
dataReduced
cu3
#
#
# 9) set anproc to split by water type and stay with range 1300-1600 nm and run pca --------
## set in anproc.r:
### spl.var <- "C_Water"
### spl.wl <- c("1300-to-1600")
### do.pca <- TRUE
### pca.colorBy <- c("C_Water", "C_waterTemp", "C_conSNr")
cu4 <- gdmm(dataReduced)
# plot the results of pca
plot(cu4, pg.fns = "_byWaterSNV") 
cu4
#
#
# 10) set anproc to do regression on water temperature with plsr --------
## set in anproc.r:
### do.pca <- FALSE
### do.pls <- TRUE
### pls.ncomp <- 2
### pls.regOn <- c("Y_waterTemp")
### pls.colorBy <- "C_waterTemp"
cu5 <- gdmm(dataReduced)
# plot the results of pca
plot(cu5, pg.fns = "_byWaterSNV") 
#
#
# 11) set anproc to do classic aquagram --------
## set in anproc.r:
### do.pls <- FALSE
### do.aqg <- TRUE
### aqg.vars <- "C_waterTemp"
cu6 <- gdmm(dataReduced)
# plot the results of pca
plot(cu6, pg.fns = "_byWater") 
#
#
# 12) set anproc to do classic aquagram by subtracting lowest temperature --------
## set in anproc.r:
### aqg.spectra <- "all"
### aqg.minus <- "20"
### aqg.mod <- "classic-diff"  
cu7 <- gdmm(dataReduced)
# plot the results of pca
plot(cu7, pg.fns = "_byWater") 
#
#
# 13) choose some data, set anproc to do aucs aquagram with conf intervals and plot spectra --------
## set in anproc.r:
### aqg.minus <- "34"
### aqg.mod <- "aucs.dce"  
### aqg.bootCI <- TRUE
selTemp <- ssc(dataReduced, C_waterTemp %in% c(30, 32, 34, 36, 38), include=TRUE)
selTemp <- reColor(selTemp)
cu8 <- gdmm(selTemp, getap(aqg.mod = "aucs.dce", aqg.bootCI = TRUE))
# plot the results of pca
plot(cu8, pg.fns = "_byWater") 
#
#
# 14) choose some data, set anproc to do aucs aquagram with conf intervals and plot spectra --------
## set in anproc.r:
### aqg.mod <- "aucs.dce-diff"
cu9 <- gdmm(selTemp, getap(aqg.mod = "aucs.dce-diff", aqg.bootCI = TRUE))
# plot the results of pca
plot(cu9, pg.fns = "_byWater") 
#
#
