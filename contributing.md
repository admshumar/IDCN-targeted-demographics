<h1>Contributing to IDCN's Talent Management Platform</h1>

The following is a set of guidelines for contributing to the code base for wrangling, analyzing, and visualizing the local membership databases of IDCN's Talent Management Platform. These are guidelines, not rules. Accordingly, feel free to propose changes to this document in a pull request.

<h2>Purpose</h2>

The code base was written originally to pull demographic information from IDCN Copenhagen's membership database for the purpose of understanding where members wanted to go in the Danish economy. Copenhagen's Membership Team then realized that the code base could be used to expedite its Monthly Report on the status of the membership, as well as to generate quickly various spreadsheets of interest to other teams.

We now envision this project as an opportunity for IDCN members who are interested in data science to learn the R programming langugage in a practical business setting, as well as a chance for those who plan to enter data science to contribute to a useful open source project and thus bolster a data science portfolio. To that end, much of the code is heavily commented, so that new practitioners can treat it as a tutorial for data wrangling, data analysis, and data visualization.

This project has enormous potential for expansion, and we strongly encourage ideas for extending functionality, speeding production, and improving visualization.

<h2>Getting Started</h2>

<h2>Targeted Demographics</h2>
The Targeted Demographics Report summarizes the desired job placement outcomes of active local members.

<h2>Monthly Report</h2>
The Monthly Report gives information about the current state of a chapter's membership. It includes counts of active and inactive members, gives accounts of former and current volunteers, and tracks the job placement outcomes of inactive members. This requires the reporter to conduct many counts of various subsets of the membership, all of which are automated by the R scripts.


MonthlyReport.R controls these procedures.
