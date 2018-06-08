#Targeted Demographics Project - R Script
#Written by Jon Middleton
#Membership Team, IDCN Copenhagen
#May 2018

#Script that extracts and transforms IDCN Copenhagen's Talent Management Platform (TMP). The purpose is to visualize the desired job placements of IDCN partners.

#Clear console
cat("\014")

#Clear environment
rm(list=ls())

#Clear plots
dev.off()

#Libraries
library(dplyr) #dplyr is a grammar of data manipulation (https://dplyr.tidyverse.org/)

library(googlesheets) #Provides access and management of Google spreadsheets from R (https://github.com/jennybc/googlesheets#google-sheets-r-api). In particular, a copy of the Talent Management Platform is placed on a Google Drive, and the data therein are extracted and transformed in R.

library(magrittr) #Provides the so-called "pipe operator" %>% to improve code readability and maintainability (https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html)

library(ggplot2) #Provides a system for declaratively creating graphics (http://ggplot2.tidyverse.org/). All plots in this script are ggplots.

#Print current Month and Year.
today <-format(Sys.Date(), format="%B %Y")

#Print a previous Month and Year. This is needed for title displays after rerunning older versions of the TMP.
today <- "March 2018"

#Theme for barplots topped with values. These are useful for displaying data about the part of the membership that is interested in a given sector of the economy.
themeIDCN <- function(){
  theme(
    axis.text.x = element_text(colour = "white", size=rel(1.5)),
    axis.title.x = element_text(colour = "white", size=rel(1.5)),
    axis.text.y = element_text(colour = "black", size=rel(1.5)),
    axis.title.y = element_text(colour = "black", size=rel(1.5)),
    #axis.title.y = element_text(colour = "blue", angle=45),
    panel.background = element_rect(fill="gray97"),
    panel.grid.minor = element_line(colour = "white"),
    panel.grid.major = element_line(colour = "white"),
    plot.background = element_rect(fill="white"),
    plot.title = element_text(colour = "black", size=rel(1.7)),
    legend.position = "left"
  )
}

themeIDCN_counts <- function(){
  theme(
    axis.text.x = element_text(colour = "white", size=rel(1.5)),
    axis.title.x = element_text(colour = "black", size=rel(1.5)),
    axis.text.y = element_text(colour = "black", size=rel(1.5)),
    axis.title.y = element_text(colour = "black", size=rel(1.5)),
    #axis.title.y = element_text(colour = "blue", angle=45),
    panel.background = element_rect(fill="gray97"),
    panel.grid.minor = element_line(colour = "white"),
    panel.grid.major = element_line(colour = "white"),
    plot.background = element_rect(fill="white"),
    plot.title = element_text(colour = "black", size=rel(1.7)),
    legend.position = "left"
  )
}


gs_ls() #List all sheets on the Google Sheets home screen.

tdp <- gs_title("tmp14032018.xls") #Assigns to tdp the Google Sheet with title "TDP Master Table"

gs_ws_ls(tdp) #Retrieves the titles of all the worksheets in the Google Sheet TDP

tdp <- gs_read(ss=tdp, ws="Candidates") #Assigns to tdp the data frame read from the worksheet "Candidates" in the Google Sheet tdp

#tdp <- as.data.frame(tdp) #Checks if tdp is a data frame, or coerces tdp to a data frame if possible (redundant?)

tdp_active <- dplyr::filter(tdp, Status == "Active") #Constructs a table consisting of all active IDCN partners. Thus we ignore data about partners that have been deemed "inactive".

tdp_active_nonempty <- dplyr::filter(tdp, Status == "Active", "Desired industries"!="-") #Constructs a table consisting of all active IDCN partners that responded with at least one desired industry.

#IMPORTANT. Many active IDCN members have specified more than one job field, and these job fields appear in the "Desired industries" column as a comma separated list. For a proper analysis, it's necessary to split these lists.

B <- tdp_active #B is the data frame to be analysed

member_count <- nrow(B) #Assigns to member_count the number of rows in the data frame of interest.

#x-axis text for plots
x_numbers <- paste("Number of Active Members: ", member_count, "\n", "Number of Responses: ", response_count, sep="")

#For display purposes, we rename some values in the "Desired industries" column.
B$`Desired industries`[B$`Desired industries` == "-"] <- "(No Response)"
B$Subdomain[B$Subdomain == "-"] <- "(No Response)"
B$"Highest Level of Education"[B$"Highest Level of Education" == "-"] <- "(No Response)"

#For display purposes, we create functions that return a string that depends on the choice of job market segementation
unknown_title <- function(segmentation){
  paste("Active Members of IDCN Copenhagen with Unknown",
        segmentation,
        "Preference", 
        sep = " ")
}

fieldplot_title <- function(segmentation){
  paste("Active IDCN Copenhagen Members Interested in", segmentation, sep=" ")
}

desired_title <- function(segmentation){
  paste("Desired",segmentation,"of Active IDCN Copenhagen Members", sep=" ")
}

#There are two job market segmentations in the TMP. One is "Desired Industry", in which the economy is segmented into broad categories, like "Health/Pharma", "Legal/Government/Non-profit", and "Media/Entertainment/Hospitality". The second is "Subdomain", which has several similar values, but also includes more descriptive job roles such as "Project Management" and "General Management".
B1 <- data.frame(
  First = B$"First name",
  Last = B$"Name",
  Education = B$"Highest Level of Education",
  Desired = B$`Desired industries`,
  stringsAsFactors=FALSE
)

B2 <- data.frame(
  First = B$"First name",
  Last = B$"Name",
  Education = B$"Highest Level of Education",
  Desired = B$Subdomain,
  stringsAsFactors=FALSE
)

stack3 <- strsplit(B1$Desired, split = c(",")) #stack3 is a column whose entries are lists of strings
L = sapply(stack3, length) #L is a column whose entries are the lengths of the entries of A

stack4 <- strsplit(B2$Desired, split = c(","))
M=sapply(stack4, length)

A <- data.frame(
  First = rep(B1$First, L),
  Last = rep(B1$Last, L),
  Education = rep(B1$Education, L),
  Desired = unlist(stack3),
  stringsAsFactors=FALSE
)

A1 <- data.frame(
  First = rep(B2$First, M),
  Last = rep(B2$Last, M),
  Education = rep(B2$Education, M),
  Desired = unlist(stack4),
  stringsAsFactors=FALSE
)

jobreport_basic <- function(table, N)
{
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table, desc(`n()`))
  
  #Response label
  response_count <- sum(table$`n()`)
  
  #Sample size label
  samplesize <- paste("(N = ", sum(table$`n()`), ")", sep="")
  
  #Basic barplot
  ggplot(table[which(table$`n()`>N),], aes(x=reorder(Desired,-`n()`), y=`n()`)) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.margin = margin(0.5,0.5,1,3, "cm")
    ) +
    xlab(paste("Number of Active Members: ", member_count, "\n", "Number of Responses: ", response_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(paste(desired_title("Industries"), "\n",today, sep = "")
    )+
    geom_text(aes(label=`n()`), position="stack", vjust=1) +
    geom_col()
}

jobreport_basic(A,2)

#Stacked barplot of IDCN Copenhagen's desired job placements.
jobreport_stacked <- function(table, N)
{  
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table[which(table$`Desired`!="(No Response)" & table$`n()`>N & table$Education!="(No Response)" & table$Education!="High School" & table$Education!="Other"), ], desc(`n()`))
  
  #Response label
  response_count <- sum(table$`n()`)
  
  #Sample size label
  samplesize <- paste("(N = ", sum(table$`n()`), ")", sep="")
  
  #Stacked barplot
  ggplot(table, aes(fill=Education, x=reorder(Desired,-`n()`), y=`n()`, label = `n()`)) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "left"
    ) +
    xlab(paste("Number of Active Members: ", member_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(paste(desired_title("Job Fields"), "\n",today, sep = "")
    )+
    geom_col()+
    geom_text(size=5, position = position_stack(vjust = 0.5))
}

print(jobreport_stacked(A,1))
print(jobreport_stacked(A1,1))

#Grouped barplot of IDCN Copenhagen's desired job placements.
jobreport_grouped <- function(table, N)
{
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table, desc(`n()`))
  
  #Response label
  response_count <- sum(table$`n()`)
  
  #Sample size label
  samplesize <- paste("(N = ", sum(table$`n()`), ")", sep="")
  
  #Grouped barplot
  ggplot(table[which(table$`n()`>N),], aes(fill=Education, x=reorder(Desired,-`n()`), y=`n()`)) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1), 
      legend.position = "left"
    ) +
    xlab(paste("Number of Active Members: ", member_count, "\n", "Number of Responses: ", response_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(paste(desired_title("Professional Areas"), "\n",today, sep = "")
    )+
    geom_col(position="dodge")  
}

print(jobreport_grouped(A,1))
print(jobreport_grouped(A1,1))

#Restricted barplot of IDCN Copenhagen's desired job placements.
jobreport_restricted <- function(table, N)
{  
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table, desc(`n()`))
  
  #Response label
  response_count <- sum(table$`n()`)
  
  #Restricted grouped barplot
  ggplot(table[which(table$`n()`>N),], 
         aes(fill=Education, x=reorder(Desired,-`n()`), y=`n()`)) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1), 
      legend.position = "left"
    ) +
    xlab(paste("Number of Active Members: ", member_count, "\n", "Number of Responses: ", response_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(paste(desired_title("Professional Areas"), "\n",today, sep = "")
    )+
    geom_bar(position="dodge", stat="identity") 
}

print(jobreport_restricted(A,1))
print(jobreport_restricted(A1,1))

jobreport_fieldplot <- function(table, string)
{  
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table, desc(`n()`))
  
  #Restricted table
  r_table <- table[which(table$Desired==string),]
  
  #Sample size label
  response_count <- sum(r_table$`n()`)
  
  #Restricted grouped barplot
  ggplot(
    r_table, 
    aes(
      fill=Education, 
      x=reorder(Desired,-`n()`), 
      y=`n()`,
      label=`n()`
    )
  ) +
    themeIDCN_counts() +
    xlab(paste("Number of Active Members: ", response_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(
      paste(fieldplot_title(string),"\n",today, sep = "")
    ) +
    geom_text(position = position_dodge(width=0.9),
              size = 7,
              aes(
                colour = Education, 
                y=2+`n()`, 
                label=`n()`,
                hjust=0.5) #hjust=0.5 corresponds to centered text
    ) +
    #annotate(size = 5, "text",x = Inf,y = Inf,label = samplesize, hjust = 1.5, vjust = 1.5) +
    geom_bar(aes(fill=Education), position=position_dodge(width=0.9), stat="identity")
  #geom_col() 
}

#Export dimensions
#Width: 12.44 inches
#Height: 7 inches
print(jobreport_fieldplot(A, "(No Response)"))
print(jobreport_fieldplot(A1, "Research & Development"))
