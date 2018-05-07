# Count-based-Threat-Assessment
This repository contains data and R code for assessing the impact of two local threats, encroachment by woody invasive species and herbivory by White-tailed deer, the impact of climate change, and their interaction on a rare, perennial forb in the Upper Midwest. 
There are two main data files, each has accompanying code and/or secondary data files required for analyses.

1. DataS1.csv and DataS1_RCode.R

These files can be used to assess the effect of local threats. Specific instructions for running code provided within DataS1_RCode.R.

Headers in DataS1.csv:
- site = population number
- subpop = subpopulation number
- first.year = the year Nt was measured
- r.t. = LRR
- first.num.stems = Nt
- den.first.year = the stem density in the year that Nt was measured
- woody = woody invasive species threat category
- deer = deer browsing threat category

2. DataS2.csv and DataS2_RCode.R

These files can be used to assess the effect of climate change and the interactions between local threats and climate change. Specific instructions for running code provided within DataS2_RCode.R. To run the code file, the following secondary data files are required:
- TAVGsummerWORLDCLIM.csv
- TAVGwinterWOLDCLIM.csv
- precWSWORLDCLIM.csv

Headers for DataS2.csv:
- site = population number
- subpop = subpopulation number
- first.year = the year Nt was measured
- station_ID = closest weather station
- SUtemp = average temperature for the summer in-between Nt and Nt+1
- WINtemp = average temperature for the winter in-between Nt and Nt+1
- WSprcp = total precipitation for the winter and spring in-between Nt and Nt+1
- woody = woody invasive species threat category
- deer = deer browsing threat category
- avgr.t. = LRR averaged by subpopulation and year
- avgden = stem density averaged by subpopulation and year in the year that Nt was measured

Headers for ‘WORLDCLIM’ files:
- VALUE = the climate variable (either temperature or precipitiation)
- COUNT = the number of those values in the buffered region
 
