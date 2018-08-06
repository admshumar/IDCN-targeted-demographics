# Copyright (c) 2018 Jon Middleton. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =============================================================================

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

#Construct subtables from the TMP that are relevant for TDP.
source("~/TMP-R/getSubtables.R")

#Create new data frames whose rows contain exactly one job field,
#then plots all data from these data fields.
source("~/TMP-R/TDP/transformandplotTMP.R")
