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

#Recommended export dimensions:
#Width: 12.44 inches
#Height: 7 inches
#These display nicely on large widescreens.

print(jobreport_fieldplot(A, "(No Response)"))
pdf("IDCN-RD.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Research & Development"))
dev.off()
pdf("IDCN-ProjectManagement.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Project Management"))
dev.off()
pdf("IDCN-EducationTraining.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Education / Training"))
dev.off()
pdf("IDCN-Communications.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Communications"))
dev.off()
pdf("IDCN-SalesCustomerServiceBusinessDevelopment.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Sales / Customer Service / Business Development"))
dev.off()
pdf("IDCN-GeneralManagement.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "General Management"))
dev.off()
pdf("IDCN-HumanResources.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Human Resources"))
dev.off()
pdf("IDCN-Other.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Other"))
dev.off()
pdf("IDCN-MarketingAdvertising.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Marketing / Advertising"))
dev.off()
pdf("IDCN-ITEngineering.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "IT / Engineering"))
dev.off()
pdf("IDCN-OperationsLogistics.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Operations / Logistics"))
dev.off()
pdf("IDCN-AccountingFinance.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Accounting/Finance"))
dev.off()
pdf("IDCN-LegalCorporateAffairsCompliance.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Legal / Corporate Affairs / Compliance"))
dev.off()
pdf("IDCN-OperationsLogistics.pdf", width = 12.44, height = 7)
print(jobreport_fieldplot(A1, "Operations / Logistics"))
dev.off()


x <- c("Research & Development","Project Management","Education / Training",
       "Communications","Sales / Customer Service / Business Development",
       "General Management", "Human Resources","Marketing / Advertising", 
       "IT / Engineering", "Operations / Logistics", 
       "Legal / Corporate Affairs / Compliance", "Operations / Logistics")

pdf("All.pdf", width = 12.44, height = 7)
for (i in x){
  print(jobreport_fieldplot(A1, i))
}
dev.off()
