#Constructs a table consisting of all active IDCN partners.
TMP_active <- dplyr::filter(TMP, Status == "Active")

#Constructs a table consisting of all inactive IDCN partners.
TMP_inactive <- dplyr::filter(TMP, Status == "Inactive") 

#Construct a table consisting of all active IDCN partners that 
#responded with at least one desired industry.
#TMP_active_nonempty <- dplyr::filter(TMP, Status == "Active", TMP[,14]!="-") 
