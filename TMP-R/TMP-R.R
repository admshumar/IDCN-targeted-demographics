#TMP-R
#Written by Jon Middleton
#Membership Team, IDCN Copenhagen
#May 2018

#Script that extracts and transforms IDCN Copenhagen's Talent Management Platform (TMP). The purpose is to visualize the desired job placements of IDCN partners.

#Clear console.
cat("\014")

#Clear environment.
rm(list=ls())

#Clear plots.
#dev.off()

#Load libraries for TDP-R.
source("~/TMP-R/loadLibraries.R")

#Format dates for display on graphs.
source("~/TMP-R/formatDate.R")

#Load themes for graphs.
source("~/TMP-R/loadThemes.R")

#Extract the administrator's local copy of the TMP from
#the administrator's Google Drive. This assumes that the
#local administrator has downloaded a copy of the TMP to
#Google Drive.
source("~/TMP-R/extractTMP.R")

#Create new data frames whose rows contain exactly one job field.
source("~/TMP-R/transformTMP.R")
