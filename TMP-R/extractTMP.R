#List all sheets on the Google Sheets home screen.
gs_ls() 

#Assign to TMP the Google Sheet with title "TDP Master Table".
TMP <- gs_title("tmp14032018.xls") 

#Retrieve the titles of all the worksheets in the Google Sheet TMP.
gs_ws_ls(TMP) 

#Assign to TMP the data frame read from the worksheet "Candidates"
#in the Google Sheet TMP.
TMP <- gs_read(ss=TMP, ws="Candidates") 

#TMP <- as.data.frame(TMP) #Checks if TMP is a data frame, or 
#coerces TMP to a data frame if possible

#Constructs a table consisting of all active IDCN partners.
#Thus we ignore data about partners that have been
#deemed "inactive".
TMP_active <- dplyr::filter(TMP, Status == "Active") 

#Construct a table consisting of all active IDCN partners that 
#responded with at least one desired industry.
TMP_active_nonempty <- dplyr::filter(TMP, Status == "Active", "Desired industries"!="-") 