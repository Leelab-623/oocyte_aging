#!/bin/bash

files="output_cv/*.out"

cat $files > output/AUROC.csv

Rscript 4_AUROC.R output/AUROC.csv 


