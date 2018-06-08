#IMPORTANT. Many active IDCN members have specified more than 
#one job field, and these job fields appear in the "Desired industries"
#column as a comma separated list. For a proper analysis, it's
#necessary to split these lists.

#Set B to the data frame of interest
B <- TMP_active

#Assign to member_count the number of rows in the data frame of interest.
member_count <- nrow(B) 

#For display purposes, rename some values in the "Desired industries"
#column.
B$`Desired industries`[B$`Desired industries` == "-"] <- "(No Response)"
B$Subdomain[B$Subdomain == "-"] <- "(No Response)"
B$"Highest Level of Education"[B$"Highest Level of Education" == "-"] <- "(No Response)"

#For display purposes, create functions that return a string that
#depends on the choice of job market segementation.
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

#There are two job market segmentations in the TMP. One is 
#"Desired Industry", in which the economy is segmented into
#broad categories, like "Health/Pharma", "Legal/Government/Non-profit",
#and "Media/Entertainment/Hospitality". The second is "Subdomain",
#which has several similar values, but also includes more descriptive
#job roles such as "Project Management" and "General Management".

#For each segmentation, create a data frame for analysis.
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

#Construct columns whose entries are lists of strings.
stack3 <- strsplit(B1$Desired, split = c(","))
stack4 <- strsplit(B2$Desired, split = c(","))

#Construct columns whose entries are the lengths of the entries of A.
L = sapply(stack3, length) 
M=sapply(stack4, length)

#Complete the construction of data frames for analysis.
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

#Construct "job reports". That is, graphs that indicate the number 
#of IDCN members that are interested in a particular job sector 
#or job role.
source("~/TMP-R/constructGraphs.R")

#Export graphs to pdf files.
source("~/TMP-R/exportGraphs.R")