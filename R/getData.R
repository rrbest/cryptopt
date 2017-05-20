library(qdapRegex)
library(reshape)
files <- list.files("bittrex")

hours <- seq(0, 23)
data_hours <- seq(0, 230000, by=10000)

data <- c()
for(i in 1:length(files)){
  tmp <- read.csv(paste0("bittrex/", files[i]))
  tmp$Ticker <- rm_between(files[i], '_', '_', extract=TRUE)[[1]]
  colnames(tmp) <- c("date", "hour", "bittrex", "price", "ticker")
  data <- rbind(data, tmp)
  print(i)
}
rm(tmp)


data$hour <- replace(data$hour, data$hour %in% data_hours, hours)
data <- data[data$hour %in% hours, ]
data$time <- paste(data$date, data$hour)
data$time <- as.POSIXct(data$time, format="%Y%m%d %H")
data <- data[, c("time", "ticker", "price")]


price_matrix <- cast(data, time~ticker, mean)
