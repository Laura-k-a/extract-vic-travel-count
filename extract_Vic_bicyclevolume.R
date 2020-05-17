#'Script for extracting daily counts for bicycle in R
#'Author: Laura Aston
#'Institution: Monash University
#'Date: 14 May 2020

--------------------------------------
  
#'Data source:Victorian State Government 2020, Bicycle volume and speed, <https://discover.data.vic.gov.au/dataset/bicycle-volume-and-speed>, viewed 11/5/2020.
#'Every time a bicycle passes a counter, a row is added to the spreadsheet, with a unique timestamp
#'Each csv file contains one week's worth of counts for one counter
  
#'NOTE
#'Files must first be extracted from the zip file for this program to work. Becausee multiple files exist for each counter, ensure that files are "renamed by default" when unzipping to avoid overwriting data for counters
  
#'Description
#'#'Using a for loop, this program opens each file and summarises the entries by day of week and hour
#'All entries for a given year are then 'bound' into a single file, and written to .csv format. 

-----------------------
  
install.packages("dplyr")
library(dplyr)
install.packages("lubridate")
library(lubridate)


setwd("")#Specify the file path where files are located


list2019 = list()#create an empty list to store results 

files2019 <- Sys.glob( "*.csv" ) #identifies .csv files in directory

#'This for loop summarises the data by date and time. Time is grouped in 1-hour intervals. The number of entries for each date/time interval combination is counted.
#'To change the parameters that are extracted, add them to the "group by" command

for (i in files2019) 
{
  df <- read.csv(i)
  df$TIME<-parse_date_time(df$TIME,"HMS")
  
  dat<-df %>%
    group_by(SITE_XN_ROUTE,DATE, TIME=floor_date(TIME, "1 hour"))%>%
    summarize(n=n())
  list2019[[i]] <- dat # add it to your list
}

list2019 = do.call(rbind, list2019)

write.csv(list2019, "BVS2019.csv")