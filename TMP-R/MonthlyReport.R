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

#IDCN Monthly Report
#Written by Jon Middleton
#Membership Team, IDCN Copenhagen
#May 2018

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

#Generate counts of the membership.
source("~/TMP-R/MonthlyReport/countMembers.R")

#################################
#ACTIVE PARTNERS BY COMPANY PLOT
#Export dimensions: 14x6
#################################

#Create a frequency table of partner companies.
counts <- group_by(TMP_active, TMP_active$'Partner Company') %>% summarize(count = n())

#The above table has an awkward title for the companies column, so rename it.
colnames(counts)[1] <- "Company"

#Reorder the Company factor in the counts table in weakly decreasing order.
counts$Company <- factor(counts$Company, levels = counts$Company[order(-counts$count)])

#Plot a frequency bar chart.
ggplot(counts, aes(x = Company, y = count)) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size=rel(1.6)),
    axis.title.x = element_text(colour = "white", size=rel(1.5)),
    axis.title.y = element_text(colour = "white", size=rel(1.5)),
    plot.margin = margin(0.5,0.5,1,3, "cm"),
    plot.title = element_text(colour = "black", size=rel(1.6))
  ) +
  ggtitle("Active Partners by Company") +
  geom_text(aes(label = count, y = count+4), size = rel(7)) +
  geom_col(fill = "#038080")

##########################
#MEMBERSHIP EVOLUTION PLOT
#Export dimensions: 12x7
##########################

#Assign to Evolution the Google Sheet with title "IDCN_Evolution".
Evolution <- gs_title("IDCN_Evolution") 

#Assign to Evolution the data frame read from the worksheet "Sheet1"
#in the Google Sheet Evolution.
Evolution <- gs_read(ss=Evolution, ws="Sheet1") 

#Reorder the Month factor in the Evolution table in row order.
Evolution$Month <- factor(Evolution$Month, 
                          levels = Evolution$Month[order(row(Evolution))])

# Basic line plot with points
ggplot(Evolution, aes(x=Month, y=Count, group=1)) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size=rel(2)),
    axis.title.x = element_text(colour = "white", size=rel(1.5)),
    axis.title.y = element_text(colour = "white", size=rel(1.5)),
    plot.title = element_text(colour = "black", size=rel(2))) +
  geom_line(color="#038080")+
  geom_point(color="#038080") + 
  ggtitle("Partners' Evolution") +
  geom_text(aes(label = Count, y = Count+50), size=rel(7))

##################################
#SUCCESS STORIES PLOTS
#See: getSubtables_MonthlyReport.R
#Export dimensions: 9x5
##################################

# Line Plot of Number of Corporate Employees by Year
names(count_partners_employed_corporate) <- c("Year", "Count")

#Rename for readability
CPEC <- count_partners_employed_corporate

ggplot(CPEC, aes(x=Year, y=Count, group=1)) +
  themeIDCN_monthly_report + 
  ggtitle("Corporate Alumni") +
  geom_text(aes(label = Count, y = Count+1), size=rel(8)) +
  xlab(paste("\n","Total:", sum(CPEC$Count))) +
  geom_col(width = 0.5, fill="#038080")

# Line Plot of Number of Non-Corporate Employees by Year
names(count_partners_employed_other) <- c("Year", "Count")

#Rename for readability
CPEO <- count_partners_employed_other

ggplot(CPEO, aes(x=Year, y=Count, group=1)) +
  themeIDCN_monthly_report + 
  ggtitle("Non-corporate Alumni") +
  geom_text(aes(label = Count, y = Count+5), size=rel(8)) +
  xlab(paste("\n","Total:", sum(CPEO$Count))) +
  geom_col(width = 0.5, fill="#038080")
