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
