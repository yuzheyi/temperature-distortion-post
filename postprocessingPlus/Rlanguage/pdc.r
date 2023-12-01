rm(list = ls())
p <- read.csv("./resultP2.out", header = FALSE)
t <- read.csv("./resultT2.out", header = FALSE)


pdf("爆震燃烧室出口参数.pdf", width = 10, height = 10)
par(mar = c(5, 5, 4, 2) + 0.1)  
plot(p$V2,p$V3,type='l',main='Pressure vs Time',xlab='Time',ylab='Pressure',xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=1.5)
plot(t$V2,t$V3,type='l',main='Temperature vs Time',xlab='Time',ylab='Temperature',xlim=c(0, 0.05), cex.main=2, cex.lab=2, cex.axis=1.5)
dev.off()