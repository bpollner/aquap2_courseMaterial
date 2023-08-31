# this script can be run fully without any human interaction:
# two different analysis procedure files are used which content remains strictly UNTOUCHED.
# The call to "gdmm" is always slightly different, using the possibility to override parameters
# in the analysis procedure file.
#
# this script generates the same analysis output as routine1.r, but without manual changes in analysis procedure files
#
library(aquap2) # load aquap2 package

# 1) create sample list based on metadata file --------
esl(form = "xls", rnd = FALSE, showFirstRows = TRUE, timeEstimate = TRUE) # you can now look at the generated file in SampleLists/sl_out
#
# 2) import data after experiment  --------
fullData <- gfd(ttl = FALSE, slType = "xls", trhLog = "ESPEC") # possibly overriding values in the settings.r file
fullData <- gfd() # once importing has been done once, the file can be simply loaded
#
# 3) plot raw spectra from dataset --------
plot(fullData, colorBy = "C_waterTemp", pg.fns="_2")
#
# 4) set analysis procedure file for pca using the range 1300-1600 nm and run pca analysis -------
cu <- gdmm(fullData, getap("anp1.r", do.pca=TRUE))
plot_pca(cu, pg.fns="_2") # plot the results of pca
#
# 5) remove unwanted data from our dataset --------
dataReduced <- ssc(fullData, C_Water != "AIR")
#
# 6) do pca again with the reduced dateset --------
cu2 <- gdmm(dataReduced, getap("anp1.r", do.pca=TRUE))
plot_pca(cu2, pg.fns = "_2_noAir") # # plot the results of pca calculated on reduced dataset; pg.fns is to change the name of pdf not to overwrite previous ones 
#
# 7) plot raw spectra of different ranges --------
cu3 <- gdmm(dataReduced, getap("anp1.r", spl.wl=c("680-to-800", "900-to-1040", "1300-to-1600")))
plot_spectra(cu3, colorBy = "C_waterTemp", pg.fns = "_2_byRange") # plot spectra
#
# 7a) do pre-treatment --------
cu3 <- gdmm(dataReduced, getap("anp1.r", dpt.pre = "snv", spl.wl=c("680-to-800", "900-to-1040", "1300-to-1600")))
plot_spectra(cu3, colorBy = "C_waterTemp", pg.fns = "_2_byRangeSNV") # plot the results of pca calculated on reduced dataset
#
# 8) have a look at on the structure of data and cube (cu2), not required for analysis --------
dataReduced
cu3
#
# 9) split by water type and stay with range 1300-1600 nm (have all that in a new settings.r file) and run pca --------
cu4 <- gdmm(dataReduced, getap("anp1split.r", do.pca=TRUE))
plot_pca(cu4, pg.fns = "_2_byWaterSNV") # plot the results of pca
cu4
#
# 10) + 11)  do regression on water temperature (in each individual water) via plsr *AND* a classical aquagram together --------
cu5 <- gdmm(dataReduced, getap("anp1split.r", do.pls=TRUE, do.aqg=TRUE, aqg.mod="classic", aqg.spectra=FALSE, aqg.bootCI=FALSE))
plot(cu5, pg.fns = "_2_byWaterSNV") # plot the results of everything in cu5 
#
# 12) do classic aquagram, subtract lowest temperature --------
cu7 <- gdmm(dataReduced, getap("anp1split.r", do.aqg=TRUE, aqg.mod="classic-diff", aqg.minus="20", aqg.bootCI=FALSE))
plot_aqg(cu7, pg.fns = "_2_byWaterSNV") # plot the aquagram results
#
# 13) # do aucs.dce (the default) aquagram with spectra --------
selTemp <- reColor(ssc(dataReduced, C_waterTemp %in% c(30, 32, 34, 36, 38), include=TRUE))
cu8 <- gdmm(selTemp, getap("anp1split.r", do.aqg=TRUE))
plot_aqg(cu8, pg.fns = "_2_byWaterSNV") # plot the results of aquagram
#
# 14) choose some data, set anproc to do aucs aquagram with conf intervals and plot spectra --------
cu9 <- gdmm(selTemp, getap("anp1split.r", do.aqg=TRUE, aqg.mod = "aucs.dce-diff", aqg.spectra=FALSE))
plot_aqg(cu9, pg.fns = "_2_byWaterSNV") # plot the results of aquagram
