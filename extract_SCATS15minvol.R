#'Script for extracting SCATS counts for vehicles in R
#'Author: Laura Aston
#'Institution: Monash University
#'Date: 15 May 2020

--------------------------------------
#'Data source:Victorian State Government 2020, Bicycle volume and speed, <https://discover.data.vic.gov.au/dataset/raffic-signal-volume-data>, viewed 15/5/2020.
  #'	15 minute traffic volumes for traffic signals by detector
#'	A detector is a loop of wire installed into the road surface and is activated when a vehicle passes over it and sends a pulse to the traffic signal.
#'	One file per day
#'	Data for 2019 is aggregated into zip file by year
#'	Data for 2020 aggregated by month
  
  
#'NOTE
#'Files must first be extracted from the zip file for this program to work


#'Description
#'This script extracts totals for 15-miute intervals. 
#'More conducive to hourly totals, but can't be analysed in excel as file is too large
#'Needs some work to 'summarise by' hour rather than curent form which has 15 minute totals. 

#'For an excel-readable version (hourly totals) see "etxract_SCATSdailytotalvol"

-------------------------------------

list2019 = list()#create an empty list to store results 

files2019 <- Sys.glob( "*.csv" )#identifies .csv files in directory

#'This for loop summarises the data by date and time. Time is grouped in 1-hour intervals. The number of entries for each date/time interval combination is counted.
#'To change the parameters that are extracted, add them to the "group by" command

for (i in files2019)
{
  df <- read.csv(i)
  dat<-df %>%
    group_by(QT_INTERVAL_COUNT, NB_SCATS_SITE)%>%
    summarize(QT_VOLUME_24HOUR=sum(QT_VOLUME_24HOUR))
  list2019[[i]] <- dat # add it to your list
}

list2019 = do.call(rbind, list2019)

write.csv(list2019, "SCATS2019.csv")