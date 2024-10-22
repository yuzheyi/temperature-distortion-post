rm(list = ls())
# 读取文件的每一行
lines <- readLines("./mfinlet")

varible_names <- list("plane-xy","pres_inlet_1","pres_inlet_2", "pres_inlet_3","pres_inlet_4","pres_inlet_5","pres_inlet_6","pres_inlet_7","pres_inlet_8","Net")
numbers_list <- list()

for (varible_name in varible_names) {
    # 找出包含变量名的行
    index <- grep(varible_name, lines)
    # 提取该行下面的一行
    selected_line <- lines[(index)]
    number <- gsub(".*\\s(-?\\d*\\.?\\d+(e[+-]?\\d+)?)$", "\\1", selected_line)
    # 将字符向量转换为数字向量
    number <- as.numeric(number)
    # 将数字添加到列表中
    numbers_list[[varible_name]] <- number
}


time <- numbers_list[["plane-xy"]]
massFlow <- numbers_list[["Net"]]





######输出文件部分
# 创建一个散点图
# 创建一个PDF文件
pdf("入口边界条件流量.pdf", width = 10, height = 10)
# 添加第一个图形
par(mar = c(5, 5, 4, 2) + 0.1)  
plot(time, massFlow, type = "l", col = "blue", xlab = "time", ylab = "massFlow", main = "massFlow-time", xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=1.5)
# 关闭PDF文件
dev.off()
# # 添加一条平滑曲线
# spline <- smooth.spline(time, temperature)
# lines(spline, col="red")
# # 筛选出x在0到0.05范围内的y值
selected_massFlow <- massFlow[time >= 0 & time <= 0.05]
# 获取selected_temperature的概要，并保存为字符向量
summary_massFlow <- capture.output(summary(massFlow))




# 打开一个文件进行写入
fileConn <- file("入口流量统计.txt")
# 写入summary_massFlow
write("Summary of massFlow :", "入口流量统计.txt")
# 写入summary_massFlow
write(summary_massFlow, "入口流量统计.txt", append = TRUE)

# 关闭文件连接
close(fileConn)
