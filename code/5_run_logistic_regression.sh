#!/bin/bash
dir="output_apply"
rm -rf $dir
mkdir $dir
matrix="intermediate/matrix.tab.t.sorted.join.csv"
seed=1
fileout=$dir"/apply"
top="output/top10.importantgenes.csv"
Rscript 5_logistic_regression.R  $matrix $seed $fileout $top
cp $dir/apply.age.1.whole.fold output/apply.coef.csv
