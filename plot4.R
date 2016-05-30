library(sqldf)
library(lubridate)
library(dplyr)
library(tidyr)

## SELECT ROWS DATED 2007-02-01 OR 2007-02-02
power <- read.csv.sql("./Data/household_power_consumption.txt", 
  sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'",  sep = ";")
closeAllConnections()

## CONVERT DATES AND TIMES TO DATE/TIME CLASSES
power$DateTime <- paste(power$Date, power$Time, sep = " ") %>%
  dmy_hms(power$DateTime)

## CHECKING WHETHER THERE'S ANY MISSING VALUES "?"
## IF SO CONVERT MISSING VALUES ? TO NA STRING
if (isTRUE(power[power == "?"])) {
  power[power == "?"] <- NA
}

## RESHAPE CONSUMPTION DF SO THAT SUB_METERING ARE IN SINGLE COLUMN
power <- gather(power, Sub_meter, Watt_hour, -c(1:6, DateTime))

## SETTING UP FOR LINE CHART PLOT
submeter <- unique(power$Sub_meter)
color <- c("black", "red", "blue")

## LAY OUT MATRIX OF CHARTS

## PLOT LINE CHART SUBMETERS*TIME
with(power, plot(DateTime, Global_active_power, type = "n"))
for (i in 1:length(submeter)) {
  with(subset(power, power$Sub_meter == (submeter[i])), line(DateTime, Watt_hour))
}


