rm(list = ls())
path <- "case3/plane/csvfile/"


range <- read.csv(paste(path,"angleRange.csv", sep = ""), header = FALSE)
rangeFilter <- read.csv(paste(path,"angleRangeFilter.csv", sep = ""), header = FALSE)
time <- t(read.csv(paste(path,"time.csv", sep = ""), header = FALSE))
highAverageTemperature <- read.csv(paste(path,"highAverageTemperature.csv", sep = ""), header = FALSE)
averageTemperature <- read.csv(paste(path,"averageTemperature.csv", sep = ""), header = FALSE)



# 创建一个散点图
pdf("输出matlab结果.pdf", width = 10, height = 10)
par(mar = c(5, 5, 4, 2) + 0.1)  
plot(time,highAverageTemperature , type = "l" ,main="High Average Temperature vs Time", xlab="Time", ylab="High Average Temperature", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=2)
plot(time,averageTemperature , type = "l" ,main="Average Temperature vs Time", xlab="Time", ylab="Average Temperature", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=2)
plot(time,range , type = "l" ,main="Range vs Time", xlab="Time", ylab="Range", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=2)
plot(time,rangeFilter , type = "l" ,main="Range Filter vs Time", xlab="Time", ylab="Range Filter", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=2)


dev.off()