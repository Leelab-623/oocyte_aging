suppressPackageStartupMessages(library(glmnet))
suppressPackageStartupMessages(library(ROCR))
suppressPackageStartupMessages(library(data.table))


args <- commandArgs(trailingOnly=T) #"data/gene.t.csv"

file <- args[1] #"intermediate/matrix.tab.t.sorted.join.csv"#args[1] #
seed <- as.integer(args[2])
fileout <- args[3]



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

for (i in c(1:dim(data)[1]))
{
train <- data[-i,]
test <- matrix(data[i,],1)
trainX <- train
trainY <- matrix(y[-i],,1)
testX <- matrix(test,1)
testY <- matrix(y[i],,1)

set.seed(seed)
cv.model <- cv.glmnet(trainX, trainY, alpha=1,family="binomial",
nfolds=5) #,type.measure="auc") #, lambda=)
#record each cv model for each seed#
a <- as.matrix(coef(cv.model,s = "lambda.min"))
a_non0 <- as.data.frame(a[a[,1]!=0,])#,,1)
rownames(a_non0) <- rownames(a)[a[,1]!=0]
write.table(a_non0,file=paste(fileout,".","age",".",seed,".",i,".fold",sep=""),quote=F,sep=",",row.names=T,col.names=F)
###

predicted <- predict(cv.model,testX,type="response",s=c("lambda.min"))

predicted_class <- predict(cv.model,testX,type="class",s=c("lambda.min"))
out[i,1] <- predicted
out[i,2] <- testY
out[i,3] <- (predicted_class==testY)
}


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

