# Fault Prediction in the Crowd?


An investigation was conducted into a 40 GB, 326 million record event dataset. This dataset contained anonymised event information representing performance, availability and security issues of 172,000 network devices from approximately 150 different customers. It was hypothesised that network device event data gathered from one customer environment could be used to predict events in another customer environment. After analysis of the dataset, a binary model was developed to predict when a process might request too much compute resources on a device. The model was developed on one set of customer data and tested on another unseen set of customer data. The Matthews correlation coefficient for the model on the unseen test data was 0.66, the F1 score was 0.72, and the False Negative rate was 27%. This was a substantial improvement over a model with no skill. September 2020.


Files
------------


 1. Data
      * /data/data1k.csv
      * /data/data1m.csv
      * /data/long_cpu_hog_prod126.csv

 2. Graphs 
	  * /code/graphs.R - some of this won't work because of MySQL dependency

 2. Data Preparation - needs MySQL DB
	  * /code/script1.sql
	  * /code/script2.sql
	  
 3. Data Manipulation
     * /code/data_prep_cpu_hog-exp1.r
      * /code/data_prep_cpu_hog-exp2.r
      * /code/data_prep-exp3.r

 3. Train and Test
     * /code/multivariate_cpu_hog_labels.ipynb
      * /code/multivariate_cpu_hog_module.ipynb
      * /code/xgboost_exp3.ipynb\

 3. Dissertation
     * /dissertation.pdf

Workflow
------------

 1. Download data files 
 2. Run graphs.R files (some parts won't work
    because of MySQL connector dependency)
   
 3. List item

Run Data Manipulation Code
    Run Train & Test Code

<!--stackedit_data:
eyJoaXN0b3J5IjpbMjc3MzQ5MTQzLDg1ODk2ODc4Ml19
-->