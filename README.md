# Fault Prediction in the Crowd?

Abstract from my September 2020 master's dissertation:

An investigation was conducted into a 40 GB, 326 million record event dataset. This dataset contained anonymised event information representing performance, availability and security issues of 172,000 network devices from approximately 150 different customers. It was hypothesised that network device event data gathered from one customer environment could be used to predict events in another customer environment. After analysis of the dataset, a binary model was developed to predict when a process might request too much compute resources on a device. The model was developed on one set of customer data and tested on another unseen set of customer data. The Matthews correlation coefficient for the model on the unseen test data was 0.66, the F1 score was 0.72, and the False Negative rate was 27%. This was a substantial improvement over a model with no skill. 

If you need something to read before you go to sleep, the full dissertation is at [dissertation.pdf](http://nilspeder.pairserver.com/dissertation.pdf)


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
      * /code/xgboost_exp3.ipynb


Workflow
------------
Does my code really work? Try it here:
 1. Download and unzip the data files (You'll need an app that handles split zipped files; I used [PeaZIP](https://peazip.com/)) 
 2. Run graphs.R files (some parts won't work
    because of the [RStudio MySQL DB connector](https://db.rstudio.com/databases/my-sql/) dependency)
 3. Run Data Manipulation Code
 4. Run Train & Test Code (you may need to make some edits if you don't have [NVIDIA CUDA](https://developer.nvidia.com/cuda-zone) installed)

Graphs
------------
Some example graphs from the paper.

![To 20 Issues](http://nilspeder.pairserver.com/art/Capture.PNG)

![Flaps](http://nilspeder.pairserver.com/art/Capture1.PNG)

![Zoom In](http://nilspeder.pairserver.com/art/Capture2.PNG)

![Flap Counts](http://nilspeder.pairserver.com/art/Capture3.PNG)
![Description](http://nilspeder.pairserver.com/art/Capture4.PNG)

![Over vrs Underfitting](http://nilspeder.pairserver.com/art/Capture5.PNG)

![Model](http://nilspeder.pairserver.com/art/Capture6.PNG)

![ROC](http://nilspeder.pairserver.com/art/Capture7.PNG)

![PR](http://nilspeder.pairserver.com/art/Capture8.PNG)

![Confused?](http://nilspeder.pairserver.com/art/Capture9.PNG)

![Unseen PR](http://nilspeder.pairserver.com/art/Capture10.PNG)

![Unseen CM](http://nilspeder.pairserver.com/art/Capture11.PNG)

Conculsions
------------

Conslusions from the dissertation:

To summarise, a machine learning classifier was developed for predicting a CPU hogging issue using a network event dataset. This data was generated by the Connected TAC service provided by Cisco Systems. The classifier was trained on one set of customer data and tested on an unseen set of data from other customer’s environments. Even though that dataset was not developed specifically for event prediction, the classifier was found to have some efficacy in predicting CPU hogging events.

The current classifier would need to be refined and developed further prior to production. However, if implemented in real-time, a crowdsourced prediction classifier could potentially be used to complement the existing knowledge-based Connected TAC service.

In addition, it is hypothesised that the methodology could be extended to other devices and other external performance-related issues, such as memory. However, it is unknown if it could be applied to internal issues like configuration errors. Perhaps approaches like process mining, which attempts to discover dependencies between events, might be more successful in exposing those dependencies with configuration errors.
<!--stackedit_data:
eyJoaXN0b3J5IjpbNTU1NjE2ODE0LDgwMjExMjM5MywtMTE4ND
MwNTkyMywtNTIzNTcyNDM5LDQwMzM3NDc1NiwxMjM4NjU1NDAx
LDE3MzcwMDg5NjgsMjEyOTA4NjcxMyw4NTI4ODY3MDUsLTc5Nz
U1Mzc4NCwxMDg1MTQ5MjQ2LDg1ODk2ODc4Ml19
-->