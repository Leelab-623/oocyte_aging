suppressPackageStartupMessages(library(glmnet))
suppressPackageStartupMessages(library(ROCR))
suppressPackageStartupMessages(library(data.table))


args <- commandArgs(trailingOnly=T) #"data/gene.t.csv"

file <- args[1] #"intermediate/matrix.tab.t.sorted.join.csv"#args[1] #
seed <- as.integer(args[2])
fileout <- args[3]
top <- args[4] #"output/top10.importantgenes.csv"

collist <-
as.vector(read.table(top,header=T,sep=",",stringsAsFactors=F)[,2])





my_data <- data.frame(fread(file))
features <- c(2:(dim(my_data)[2]-1))
class <- dim(my_data)[2]
data <- my_data[,c(features,class)]
rownames(data) <- my_data[,1]


y <- as.factor(data[,dim(data)[2]])
dummy <- model.matrix(~y)[,-1]
y <- as.factor(dummy)


data <- data.matrix(data[,1:(dim(data)[2]-1)])
out <- as.data.frame(matrix(0,dim(data)[1],3))
rownames(out) <- rownames(data)
colnames(out) <- c("prediction","true_label","correct_or_wrong")

train <- data
trainX <- train[,collist]
trainY <- matrix(y,,1)



set.seed(seed)
model <- glmnet(trainX, trainY, alpha=1,family="binomial",
lambda=0) 

a <- as.matrix(coef(model,s = "lambda.min"))
write.table(a,file=paste(fileout,".","age",".",seed,".","whole",".fold",sep=""),quote=F,sep=",",row.names=T,col.names=F)
###

predicted <- predict(model,trainX,type="response",s=c(0))

predicted_class <- predict(model,trainX,type="class",s=c(0))
out[,1] <- predicted
out[,2] <- trainY
out[,3] <- (predicted_class==trainY)



label <- 2
j <- 1
data.label <- as.numeric(out[,label])
data.prediction <- as.numeric(out[,j])
pred <- prediction(data.prediction, data.label)
auc.tmp <- performance(pred,"auc"); 
auc <- as.numeric(auc.tmp@y.values);
#print(auc)
write.table(auc,file=paste(fileout,".","age",".",seed,".out",sep=""),quote=F,sep=",",row.names=F,col.names=F)

write.table(out,file=paste(fileout,".","age",".",seed,".prediction.tab",sep=""),quote=F,sep="\t",row.names=T,col.names=T)

