#!/bin/bash
matrix=$1 #"input/fpkm.matrix.txt" #$1
sampleList=$2 #"input/samplelist.csv" #$2
number=2 #$3

./pipeline.sh $matrix $sampleList $number 2>&1 | tee out.log

