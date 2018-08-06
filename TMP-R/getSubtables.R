#Construct a table consisting of all active IDCN partners. NOTE: without the code is.na(`Status comments`), R will drop any member for whom there is an empty status comment.
TMP_active <- dplyr::filter(TMP, Status == "Active", `Status comments` != "Account rejected" | is.na(`Status comments`))

#Construct a table consisting of all inactive IDCN partners.
TMP_inactive <- dplyr::filter(TMP, Status == "Inactive", `Status comments` != "Account rejected" | is.na(`Status comments`)) 

#Construct a table consisting of all inactive IDCN partners who found a job. Since the values of `Status comments` that correspond to people who found a job consist of strings of the form "Job - <substring>", we are interested in isolating the substring "Job" to locate these people.
TMP_employed <- dplyr::filter(TMP_inactive, grepl('Job', `Status comments`))

TMP_employed_corporate <- dplyr::filter(TMP_employed, grepl('Corporate', `Status comments`))

#Create a frequency table of partners employed at corporations.
count_partners_employed_corporate <- 
  group_by(
    TMP_employed_corporate, 
    str_match(TMP_employed_corporate$"Status comments", '20\\d\\d')
    ) %>% summarize(count = n())

#RENAME COLUMN HEADERS

TMP_employed_other <- dplyr::filter(TMP_employed, !grepl('Corporate', `Status comments`))

#Create a frequency table of partner employed at companies that are not corporations.
count_partners_employed_other <- 
  group_by(
    TMP_employed_other, 
    str_match(TMP_employed_other$"Status comments", '20\\d\\d')
    ) %>% summarize(count = n())

#Constructs a table consisting of all relocated IDCN partners.
TMP_relocated <- dplyr::filter(TMP, Status == "Inactive", `Status comments` == "Relocation") 

#Constructs a table consisting of all individuals who attempted to join IDCN but were rejected.
TMP_rejected <- dplyr::filter(TMP, `Status comments` == "Account rejected")
