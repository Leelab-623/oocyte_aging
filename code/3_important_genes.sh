#!/bin/bash
dir=output
files="output_cv/*.fold"
sum=`ls $files | wc -l`

cat $files |awk -F',' '{
if($1!~/(Intercept)/)
{
print $1;}}' | sort | uniq -c | awk '{
print $1","$2;}' | sort -t',' -k1,1nr | awk -F',' 'BEGIN{
print "occurance,genes,ratio";}{print $0","$1/'$sum';}' > $dir"/all.selectedgenes.csv"

head -n 11 $dir"/all.selectedgenes.csv" > $dir"/top10.importantgenes.csv"
