This script is only for binary classification (2 classes: Young and
Advanced). 

1) Prepare two files in the input folder:
fpkm.matrix.txt
samplelist.csv 

2) How to run:

./run_pipeline.sh input/fpkm.matrix.txt input/samplelist.csv

3) Result collection:
AUROC: output/AUROC.csv, output/AUROC.csv.pdf, output/AUROC.csv.png
Top 10 genes: output/top10.importantgenes.csv
Formula: output_formula/formula.csv
Cross-validation scores (10 seeds): output_score/cv.age.*.prediction.tab.csv 
Final Logistic Regression model score: output_score/apply.age.1.prediction.tab.csv
Score [0,10] interpretation: [0,5):Advanced, [5,10]:Young. 
Running information: out.log

4) Important notes
For the input samplelist.csv, please always name the two classes as
"Young" and "Advanced", not "Young" and "Old". 

5) A model output of a successful run, check out.log. 

matrix file is input/fpkm.matrix.txt
sampleList file is input/samplelist.csv                                       
number is 2
Coverting files into linux format
Checking sample names
Success
Checking sample classes
Success
Transposing the matrix
Sorting the matrix
Sorting sample information
Adding class information
Adding header
Cross-validation...
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
There were 50 or more warnings (use warnings() to see the first 50)           
Done with CV
Counting important genes
Generating AUROC figure...
Saving 7 x 7 in image
Saving 7 x 7 in image
Building the final Logistic Regression model...                               
Printing the formula
Printing the scores
The pipeline is done

