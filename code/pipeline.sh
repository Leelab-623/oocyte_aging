#!/bin/bash

matrix=$1
sampleList=$2
number=$3

if [[ -z "$matrix" || -z "$sampleList" ]]
then
echo "Error! Please read README.txt to learn how to run."
else
echo "matrix file is "$matrix
echo "sampleList file is "$sampleList
echo "number is "$number

#clear and make folders
rm -rf output
mkdir output
rm -rf intermediate
mkdir intermediate
###

echo "Coverting files into linux format"
awk '{ sub("\r$", ""); print }' $sampleList > intermediate/sampleList.csv
sed -i 's/\xEF\xBB\xBF//g' intermediate/sampleList.csv
awk '{ sub("\r$", ""); print }' $matrix > intermediate/matrix.tab 
sed -i 's/\xEF\xBB\xBF//g' intermediate/matrix.tab
p_sampleList=intermediate/sampleList.csv
p_matrix=intermediate/matrix.tab

echo "Checking sample names"
head -n 1 $p_matrix |tr "\t" "\n" |awk '{
if($0!="")
{
print $0;
}}' |LANG=en_US sort -u > $p_matrix".sample"

cat $p_sampleList |awk -F',' '{
print $1;}' | LANG=en_US sort -u > $p_sampleList".sample"

diff=`diff $p_matrix".sample" $p_sampleList".sample"`

if [ "$diff" != "" ]
then
echo "Error: The sample names are not consistent between matrix and sampleList!"
else
echo "Success"
fi

echo "Checking sample classes"
classNum=`cat $p_sampleList |awk -F',' '{
print $2;}' | LANG=en_US sort -u | wc -l |awk '{print $1;}'`

if [ "$classNum" != "$number" ]
then
echo "Error: The sample number is wrong!"
else
echo "Success"
fi

echo "Transposing the matrix"
Rscript 1_transpose.R "intermediate/matrix.tab"
echo "Sorting the matrix"
t="intermediate/matrix.tab.t"
LANG=en_US sort -t',' -k1,1 $t > $t".sorted"
echo "Sorting sample information"
sample="intermediate/sampleList.csv"
LANG=en_US sort -t',' -k1,1 $sample > $sample".sorted"

echo "Adding class information"
LANG=en_US join -t',' $t".sorted" $sample".sorted" > $t".sorted.join"

echo "Adding header"
header="intermediate/matrix.tab.header"
cat $header |awk -F',' '{print "sample,"$0",class";}' > $header".tmp"
cat $header".tmp" $t".sorted.join" > $t".sorted.join.csv"
rm $header".tmp"

echo "Cross-validation..."
dir=output_cv
rm -rf $dir
mkdir $dir
file="intermediate/matrix.tab.t.sorted.join.csv"
for((i=1;i<=10;i++))
do
nohup Rscript 2_logistic_regression_l1.R $file $i $dir/cv &
done
wait
echo "Done with CV"

echo "Counting important genes"
./3_important_genes.sh
echo "Generating AUROC figure..."
./4_AUROC.sh
echo "Building the final Logistic Regression model..."
./5_run_logistic_regression.sh
echo "Printing the formula"
./6_print_formula.sh
echo "Printing the scores"
./7_score.sh
echo "The pipeline is done"
fi
