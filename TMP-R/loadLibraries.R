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

#TMP-R Libraries

library(dplyr) 
#dplyr is a grammar of data manipulation (https://dplyr.tidyverse.org/)

library(googlesheets) 
#Provides access and management of Google spreadsheets from R 
#(https://github.com/jennybc/googlesheets#google-sheets-r-api). 
#In particular, a copy of the Talent Management Platform is placed 
#on a Google Drive, and the data therein are extracted and 
#transformed in R.

library(magrittr) 
#Provides the so-called "pipe operator" %>% to 
#improve code readability and maintainability 
#(https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html)

library(ggplot2)
#Provides a system for declaratively creating graphics 
#(http://ggplot2.tidyverse.org/). All plots in this 
#script are ggplots.