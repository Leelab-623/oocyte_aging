args <- commandArgs(trailingOnly=T)
file <- args[1] #"intermediate/matrix.tab"#args[1]


data <- read.table(file,header=T,sep="\t",stringsAsFactors=F,row.names=1)

out <- t(data)
#out <- as.data.frame(out)
write.table(out,file=paste(file,".t",sep=""),row.names=T,col.names=F,quote=F,sep=",")
header <- matrix(colnames(out),1)
write.table(header,file=paste(file,".header",sep=""),row.names=F,col.names=F,quote=F,sep=",")
