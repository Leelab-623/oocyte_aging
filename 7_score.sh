#!/bin/bash
dir="output_score"
rm -rf $dir
mkdir $dir
SUFFIX="output_cv/*.tab output_apply/*.tab"

list=`ls $SUFFIX`

for i in $list
do
#echo $i
fileout=$dir/`echo $i|awk -F'/' '{print $NF;}'`".csv"
#echo $fileout
cat $i |awk -F'\t' '{
if(NR==1)
{
print "Sample\t"$0;
}else{
if($4==1)
{
$4="TRUE";
}
if($4==0)
{
$4="FALSE";
}
print $1"\t"$2*10"\t"$3"\t"$4;}}' > $fileout
done
