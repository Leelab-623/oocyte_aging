suppressPackageStartupMessages(library(data.table))

args <- commandArgs(trailingOnly=T)
idt <- args[1] #"ENSG00000158825"
file <- "intermediate/matrix.tab.t.sorted.join.csv"
my_data <- data.frame(fread(file))
print(my_data[,c("sample",idt,"class")]) 
