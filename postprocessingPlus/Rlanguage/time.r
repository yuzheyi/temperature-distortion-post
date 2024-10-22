rm(list = ls())
# 读取文件的每一行

path <- "./"
lines <- readLines(paste(path,'averagedata', sep = ""))

varible_names <- list("custom-time")
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

df = numbers_list[["custom-time"]]
write.csv(df, file = paste(path,"/planedata/time.csv", sep = ""))
