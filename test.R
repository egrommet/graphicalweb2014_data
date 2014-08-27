setwd("~/Documents/mpini/github/graphicalweb2014_data")
hist(rnorm(100))
hist(rnorm(1000))
x <- 8
X <- 3
ambulances_data <- read.csv('ambulances_queuing.csv', nrow=20, header=T)
other_object <- names(ambulances_data)
class(ambulances_data$Code)
class(ambulances_data$Monday)
