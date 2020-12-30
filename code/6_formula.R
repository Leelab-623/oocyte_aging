args <- commandArgs(trailingOnly=T)

file <- args[1] #"output/apply.coef.csv"
fileout <- args[2]
data <- read.table(file,header=F,sep=",",stringsAsFactors=F)

b <- data[1,2]

str <- "("
for(gene in 2:dim(data)[1])
{
line <- data[gene,]
str <- paste(str,line[1],"*",line[2],"+",sep="")
}
str <- paste(str,b,")",sep="")

formula <- paste("score=10/(1+e^-",str,")",sep="")

out <- matrix(0,1,1)
out[1,1] <- formula
write.table(out,file=fileout,quote=F,sep=",",row.names=F,col.names=F)

