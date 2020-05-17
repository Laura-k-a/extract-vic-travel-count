#'Script for extracting daily SCATS counts for vehicles in R
#'Author: Laura Aston
#'Institution: Monash University
#'Date: 15 May 2020

--------------------------------------
  
  #'Data source:Victorian State Government 2020, Bicycle volume and speed, <https://discover.data.vic.gov.au/dataset/traffic-signal-volume-data>, viewed 15/5/2020.
  #'	15 minute traffic volumes for traffic signals by detector
  #'	A detector is a loop of wire installed into the road surface and is activated when a vehicle passes over it and sends a pulse to the traffic signal.
  #'	One file per day
  #'	Data for 2019 is aggregated into zip file by year
  #'	Data for 2020 aggregated by month

  
  #'NOTE
  #'Files must first be extracted from the zip file for this program to work
  
  #'Description
  #'#'Using a for loop, this program opens each file and puts 24 hour volumes for each counter into a column. 
  #'The output is a single spreadsheet with SCATS sites as row entries, and total daily volumes vin each column
  #'The file name is assigned as the volume header to delineate the date

-----------------------

install.packages("dplyr")
library(dplyr)

setwd("") #Specify the file path where files are located

#This approach creates a list summarised by day. It can be opened in Excel (Each row is a SCAT, with volumes for each day of year copied along top row)
#Open a file
VSDATA_20190101<- read.csv(file = 'VSDATA_20190101.csv')

#Create a new df with the list of SCATS sites (needed to join the totals to later), removing duplicate SCATS IDs
VSDATA_2019<-VSDATA_20190101[!duplicated(VSDATA_20190101$NB_SCATS_SITE),]

#Keep only the columsn with SCATS ID
VSDATA_2019<-VSDATA_2019[c("NB_SCATS_SITE")]


#get a string with the names of the files
files <- Sys.glob( "*.csv" )
#run a for loop, summing "QT_VOLUME_24HR" for each scanner and then adding the total for each scanner to a new file
for( i in files )
{
  df <- read.csv(i)
  dat<-df %>% 
    group_by(NB_SCATS_SITE) %>%
    summarize(QT_VOLUME_24HOUR = sum(QT_VOLUME_24HOUR))
  names(dat)[names(dat) == "QT_VOLUME_24HOUR"] <- i
  VSDATA_2019<-merge(VSDATA_2019,dat,by="NB_SCATS_SITE")
}

#save to CSV
write.csv(VSDATA_2019, "VSDATA_2019.csv")

#################################
#repeat for 2020

setwd("")  #Specify the file path where files are located

#This approach creates a list summarised by day. It can be opened in Excel (Each row is a SCAT, with volumes for each day of year copied along top row)
#Open a file
VSDATA_20200101<- read.csv(file = 'VSDATA_20200101.csv')

#Create a new df with the list of SCATS sites (needed to join the totals to later), removing duplicate SCATS IDs
VSDATA_2020<-VSDATA_20200101[!duplicated(VSDATA_20200101$NB_SCATS_SITE),]

#Keep only the columsn with SCATS ID
VSDATA_2020<-VSDATA_2020[c("NB_SCATS_SITE")]


#get a string with the names of the files
files <- Sys.glob( "*.csv" )
#run a for loop, summing "QT_VOLUME_24HR" for each scanner and then adding the total for each scanner to a new file
for( i in files )
{
  df <- read.csv(i)
  dat<-df %>% 
    group_by(NB_SCATS_SITE) %>%
    summarize(QT_VOLUME_24HOUR = sum(QT_VOLUME_24HOUR))
  names(dat)[names(dat) == "QT_VOLUME_24HOUR"] <- i
  VSDATA_2020<-merge(VSDATA_2020,dat,by="NB_SCATS_SITE")
}

#save to CSV
write.csv(VSDATA_2020, "VSDATA_2020.csv")


