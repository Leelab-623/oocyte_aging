suppressPackageStartupMessages(library(ggplot2))
args <- commandArgs(trailingOnly=T)
file <- args[1]

data <- read.table(file,header=F,sep=",")
colnames(data) <- "AUROC"
median <- round(median(data[,1]),3)
mean <- round(mean(data[,1]),3)

ggplot(data,aes(y=AUROC,x=""))+
geom_boxplot()+
theme_bw()+
theme(axis.text.x = element_text(size=30),
      axis.text.y = element_text(size=30),
      axis.title.x = element_text(size=30),
      axis.title.y = element_text(size=30),
      legend.position="none")+
ggtitle(paste("Median AUROC=",median,"\nMean AUROC=",mean,sep=""))+
xlab("Age prediction")
ggsave(paste(file,".pdf",sep=""))
ggsave(paste(file,".png",sep=""))
