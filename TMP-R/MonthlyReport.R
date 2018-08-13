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

#Directories
main_dir <- file.path("Users","jon","IDCN")
main_report_dir <- "Monthly_Report"
date_dir <- toString(Sys.Date())
plot_dir <- "plots"
getReportDir <- file.path(main_report_dir, date_dir)
getPlotDir <- file.path(main_report_dir, date_dir, plot_dir)

#Set working directory.
setwd(main_dir)

#Create directories for the Monthly Report.
ifelse(!dir.exists(getPlotDir), 
       dir.create(getPlotDir, recursive = TRUE), 
       "FALSE")

#Load libraries.
source("~/IDCN-talent-management-platform/TMP-R/loadLibraries.R")


#Format dates for display on graphs.
source("~/IDCN-talent-management-platform/TMP-R/formatDate.R")

#Load themes for graphs.
source("~/IDCN-talent-management-platform/TMP-R/loadThemes.R")

#Load fonts.
#font_import()
#loadfonts(device = "pdf", quiet = FALSE)
fonts()

#Extract the administrator's local copy of the TMP from
#the administrator's Google Drive. This assumes that the
#local administrator has downloaded a copy of the TMP to
#Google Drive.
source("~/IDCN-talent-management-platform/TMP-R/extractTMP.R")

#Create a function that resizes the column widths of
#an .xls file.
install.packages("xlsx")
library("xlsx")
sizeandsaveXLS <- function(df, sheetTitle, directory, filename) {
  wb <- createWorkbook(type = "xlsx")
  sheet <- createSheet(wb, sheetName = sheetTitle)
  addDataFrame(df, sheet, row.names = FALSE)
  setColumnWidth(sheet, colIndex = 1:2, colWidth = 20)
  autoSizeColumn(sheet, colIndex = 3:ncol(df))
  saveWorkbook(wb, file.path(directory, filename))
}


############################
#SUBTABLES OF THE MEMBERSHIP
############################
#Construct a table consisting of all active IDCN partners. NOTE: without the code is.na(`Status comments`), R will drop any member for whom there is an empty status comment.
TMP_active <- dplyr::filter(TMP, TMP[,10] == "Active", TMP[,43] != "Account rejected" | is.na(TMP[,43]))

#Construct a table consisting of all inactive IDCN partners.
TMP_inactive <- dplyr::filter(TMP, TMP[,10] == "Inactive", TMP[,43] != "Account rejected" | is.na(TMP[,43])) 

#Construct a table consisting of all inactive IDCN partners who found a job. Since the values of `Status comments` that correspond to people who found a job consist of strings of the form "Job - <substring>", we are interested in isolating the substring "Job" to locate these people.
TMP_employed <- dplyr::filter(TMP_inactive, grepl('Job', TMP_inactive[,43]))

TMP_employed_corporate <- dplyr::filter(TMP_employed, grepl('Corporate', TMP_employed[,43]))

names(TMP_employed_corporate)

#Create a frequency table of partners employed at corporations.
count_partners_employed_corporate <- 
  group_by(
    TMP_employed_corporate, 
    str_match(TMP_employed_corporate[,43], '20\\d\\d')
  ) %>% summarize(count = n())

#RENAME COLUMN HEADERS
TMP_employed_other <- dplyr::filter(TMP_employed, !grepl('Corporate', TMP_employed[,43]))

#Create a frequency table of partner employed at companies that are not corporations.
count_partners_employed_other <- 
  group_by(
    TMP_employed_other, 
    str_match(TMP_employed_other[,43], '20\\d\\d')
  ) %>% summarize(count = n())

#Constructs a table consisting of all relocated IDCN partners.
TMP_relocated <- dplyr::filter(TMP, TMP[,10] == "Inactive", TMP[,43] == "Relocation") 

#Constructs a table consisting of all individuals who attempted to join IDCN but were rejected.
TMP_rejected <- dplyr::filter(TMP, TMP[,43] == "Account rejected")


##########################
#SUBTABLES FOR OTHER TEAMS
##########################

#Active partners' names, ordered by surname
TMP_active_names <- TMP_active_nonempty[,1:2]
TMP_active_names <- as.data.frame(TMP_active_names)
TMP_active_names_s <- TMP_active_names[order(TMP_active_names[,2]),]
TMP_active_names_s <- TMP_active_names_s[,1:2]
sizeandsaveXLS(TMP_active_names_s, 
               "Active Partner Names", 
               getReportDir, 
               "TMP_active_names_s.xlsx")


#Active partners' names and emails
TMP_active_namesmails <- TMP_active_nonempty[, c(1:2,5)]
TMP_active_namesmails <- as.data.frame(TMP_active_namesmails)
TMP_active_namesmails <- TMP_active_namesmails[order(TMP_active_namesmails[,2]),]


sizeandsaveXLS(TMP_active_namesmails, 
               "Active Partner Emails", 
               getReportDir, 
               "TMP_active_namesmails.xlsx")


#Volunteers List. Use names(TMP) to see
#the correspondence between numbers and names.
volunteer_columns <- TMP[,c(1,2,5,10,33,34,36,37,38,44)]

TMP_volunteers <- dplyr::filter(volunteer_columns, volunteer_columns[,6]!="-")

#Active Volunteers List
TMP_volunteers_active <- dplyr::filter(TMP_volunteers, TMP_volunteers[,4]=="Active" & TMP_volunteers[,8]=="0000-00-00")
TMP_volunteers_active <- TMP_volunteers_active[,c(1,2,3,6,7)]
sizeandsaveXLS(TMP_volunteers_active, 
               "Active Volunteers", 
               getReportDir, 
               "TMP_volunteers_active.xlsx")

#Candidate Volunteers List
TMP_volunteers_candidates <- dplyr::filter(volunteer_columns,
                                           volunteer_columns[,4]=="Active",
                                           volunteer_columns[,5]=="Yes",
                                           volunteer_columns[,6]=="-")
sizeandsaveXLS(TMP_volunteers_candidates, 
               "Volunteer Candidates", 
               getReportDir, 
               "TMP_volunteers_candidates.xlsx")

#Candidate Volunteer Lists by Team
TMP_volunteers_candidates_split <- TMP_volunteers_candidates

stack <- strsplit(TMP_volunteers_candidates_split[,9], split = c(","))
L = sapply(stack, length)

TMP_volunteers_candidates_split <- data.frame(
  First = rep(TMP_volunteers_candidates_split[,1], L),
  Last = rep(TMP_volunteers_candidates_split[,2], L), 
  Email = rep(TMP_volunteers_candidates_split[,3], L),
  Joined = rep(TMP_volunteers_candidates_split[,10], L),
  Team = unlist(stack),
  stringsAsFactors=TRUE
)

#Edit column titles
TMP_volunteers_candidates_split[,5] <- gsub(" ", "", TMP_volunteers_candidates_split[,5])
TMP_volunteers_candidates_split[,5] <- gsub("President/Strategy", "Management", TMP_volunteers_candidates_split[,5])
TMP_volunteers_candidates_split[,5] <- gsub("-", "None", TMP_volunteers_candidates_split[,5])

#Create a string vector of the teams' names.
teams <- unique(TMP_volunteers_candidates_split[,5])

for(team in teams){
  team_list <- dplyr::filter(TMP_volunteers_candidates_split, 
                             TMP_volunteers_candidates_split[,5]==team)
  sizeandsaveXLS(team_list, 
                 paste("Volunteer Candidates for", team, sep=" "), 
                 getReportDir, 
                 paste("TMP_volunteers_candidates_",team,".xlsx",sep=""))
}


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

#Plot and save frequency bar chart.
#pdf("active_partners.pdf", width = 12, height = 7)

ggplot(counts, aes(x = Company, y = count)) +
  themeIDCN_bar_angled +
  ggtitle("Active Partners by Company") +
  geom_text(aes(label = count, y = count + 4), size = rel(7), family="Corbel") +
  geom_col(fill = "#038080")

ggsave(file.path(getPlotDir, "active_partners.jpeg"), device = "jpeg", width = 12, height = 7)


################################
#IDCN MEMBERSHIP COUNTS
################################

#ALL ACCOUNTS
accounts <- nrow(TMP)
accounts_rejected <- nrow(TMP_rejected)
accounts_valid = accounts - accounts_rejected

#ACTIVE PARTNERS
active <- nrow(TMP_active)
active_phds <- sum(TMP_active$`Highest Level of Education`=="PhD/Doctorate")
active_masters <- sum(TMP_active$`Highest Level of Education`=="Master's Degree")
active_bachelors <- sum(TMP_active$`Highest Level of Education`=="Bachelor's Degree")

#INACTIVE PARTNERS
alumni <- nrow(TMP_inactive)
alumni_employed <- nrow(TMP_employed)
alumni_employed_corporate <- nrow(TMP_employed_corporate)
alumni_employed_other <- nrow(TMP_employed_other)
alumni_relocated <- nrow(TMP_relocated)
alumni_other <- alumni - alumni_employed - alumni_relocated


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
  themeIDCN_bar_angled +
  geom_line(color="#038080")+
  geom_point(color="#038080") + 
  ggtitle("Partners' Evolution") +
  geom_text(aes(label = Count, y = Count+50), size=rel(7), family="Corbel")

ggsave(file.path(getPlotDir, "partner_evolution.jpeg"), device = "jpeg", width = 12, height = 7)


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
  geom_text(aes(label = Count, y = Count+1), size=rel(8), family="Corbel") +
  xlab(paste("\n","Total:", sum(CPEC$Count))) +
  geom_col(width = 0.5, fill="#038080")

ggsave(file.path(getPlotDir, "success_corporate.jpeg"), device = "jpeg", width = 12, height = 7)


# Line Plot of Number of Non-Corporate Employees by Year
names(count_partners_employed_other) <- c("Year", "Count")

#Rename for readability
CPEO <- count_partners_employed_other

ggplot(CPEO, aes(x=Year, y=Count, group=1)) +
  themeIDCN_monthly_report + 
  ggtitle("Non-corporate Alumni") +
  geom_text(aes(label = Count, y = Count+5), size=rel(8), family="Corbel") +
  xlab(paste("\n","Total:", sum(CPEO$Count))) +
  geom_col(width = 0.5, fill="#038080")

ggsave(file.path(getPlotDir, "success_noncorporate.jpeg"), device = "jpeg", width = 12, height = 7)



