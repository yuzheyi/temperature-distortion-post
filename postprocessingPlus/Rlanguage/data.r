rm(list = ls())
# 读取文件的每一行
lines <- readLines("case3/AIP_1700mm/time/data")

varible_names <- list("Mass Flow Rate","Total Temperature","Static Pressure","custom-time","Static Temperature" )
numbers_list <- list()

for (varible_name in varible_names) {
    # 找出包含变量名的行
    index <- grep(varible_name, lines)
    # 提取该行下面的一行
    selected_line <- lines[(index+2)]
    number <- gsub(".*\\s(-?\\d+\\.\\d+(e[+-]?\\d+)?)$", "\\1", selected_line)
    # 将字符向量转换为数字向量
    number <- as.numeric(number)
    # 将数字添加到列表中
    numbers_list[[varible_name]] <- number
}


time <- numbers_list[["custom-time"]]
totalTemperature <- numbers_list[["Total Temperature"]]
temperature <- numbers_list[["Static Temperature"]]
mass_flow_rate <- -numbers_list[["Mass Flow Rate"]]
pressure <- numbers_list[["Static Pressure"]]




######输出文件部分
# 创建一个散点图
# 创建一个PDF文件
pdf("AIP面输出结果.pdf", width = 10, height = 10)
# 添加第一个图形
par(mar = c(5, 5, 4, 2) + 0.1)  
plot(time,totalTemperature , type = "l" ,main="Total Temperature vs Time", xlab="Time", ylab="Total Temperature", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=2)
# 添加第二个图形
plot(time,mass_flow_rate , type = "l" ,main="Mass Flow Rate vs Time", xlab="Time", ylab="Mass Flow Rate", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=2)
# 添加第三个图形
plot(time,pressure  , type = "l" ,main="Static Pressure vs Time", xlab="Time", ylab="Static Pressure", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=2)
# 添加第四个图形
plot(time,totalTemperature , type = "l" ,main="Static Temperature vs Time", xlab="Time", ylab="Static Temperature", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=2)

# 关闭PDF文件
dev.off()
# # 添加一条平滑曲线
# spline <- smooth.spline(time, temperature)
# lines(spline, col="red")
# # 筛选出x在0到0.05范围内的y值
selected_temperature <- temperature[time >= 0 & time <= 0.05]
selected_mass_flow_rate <- mass_flow_rate[time >= 0 & time <= 0.05]
selected_pressure <- pressure[time >= 0 & time <= 0.05]
selected_totalTemperature <- totalTemperature[time >= 0 & time <= 0.05]
# 获取selected_temperature的概要，并保存为字符向量
summary_temperature <- capture.output(summary(selected_temperature))
# 获取selected_mass_flow_rate的概要，并保存为字符向量
summary_mass_flow_rate <- capture.output(summary(selected_mass_flow_rate))
# 获取selected_pressure的概要，并保存为字符向量
summary_pressure <- capture.output(summary(selected_pressure))
# 获取selected_totalTemperature的概要，并保存为字符向量
summary_totalTemperature <- capture.output(summary(selected_totalTemperature))



# 打开一个文件进行写入
fileConn <- file("AIP面统计.txt")
# 写入summary_temperature的说明
write("Summary of selected_temperature:", "AIP面统计.txt")
# 写入summary_temperature
write(summary_temperature, "AIP面统计.txt", append = TRUE)
# 写入summary_totalTemperature的说明
write("\nSummary of summary_totalTemperature:", "AIP面统计.txt", append = TRUE)
# 写入summary_totalTemperature
write(summary_totalTemperature, "AIP面统计.txt", append = TRUE)
# 写入summary_mass_flow_rate的说明
write("\nSummary of selected_mass_flow_rate:", "AIP面统计.txt", append = TRUE)
# 添加summary_mass_flow_rate
write(summary_mass_flow_rate, "AIP面统计.txt", append = TRUE)
# 写入summary_pressure的说明
write("\nSummary of selected_pressure:", "AIP面统计.txt", append = TRUE)
# 添加summary_pressure
write(summary_pressure, "AIP面统计.txt", append = TRUE)
# 关闭文件连接
close(fileConn)
