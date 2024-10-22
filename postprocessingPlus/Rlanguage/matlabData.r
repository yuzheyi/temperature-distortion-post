rm(list = ls())
path <- "plane2.2/planeData/csvfile/"


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

selected_highAverageTemperature <- highAverageTemperature[time >= 0 & time <= 0.05]
summary_highAverageTemperature <-capture.output(summary(selected_highAverageTemperature))
# 打开一个文件进行写入
fileConn <- file("输出matlab结果.txt")
# 写入summary_massFlow
write("Summary of highAverageTemperature :", "输出matlab结果.txt")
# 写入summary_massFlow
write(summary_highAverageTemperature, "输出matlab结果.txt", append = TRUE)

selected_averageTemperature <- averageTemperature[time >= 0 & time <= 0.05]
summary_averageTemperature <-capture.output(summary(selected_averageTemperature))
# 写入summary_massFlow
write("Summary of averageTemperature :", "输出matlab结果.txt", append = TRUE)
# 写入summary_massFlow
write(summary_averageTemperature, "输出matlab结果.txt", append = TRUE)