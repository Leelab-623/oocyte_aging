#!/bin/bash
dir="output_formula"
rm -rf $dir
mkdir $dir
file="output/apply.coef.csv"

Rscript 6_formula.R $file $dir"/formula.csv"

