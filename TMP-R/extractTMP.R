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

#List all sheets on the Google Sheets home screen.
gs_ls() 

#Assign to TMP the Google Sheet with title "TDP Master Table".
TMP <- gs_title("TMP.xls") 

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

