# Fault Prediction in the Crowd?


An investigation was conducted into a 40 GB, 326 million record event dataset. This dataset contained anonymised event information representing performance, availability and security issues of 172,000 network devices from approximately 150 different customers. It was hypothesised that network device event data gathered from one customer environment could be used to predict events in another customer environment. After analysis of the dataset, a binary model was developed to predict when a process might request too much compute resources on a device. The model was developed on one set of customer data and tested on another unseen set of customer data. The Matthews correlation coefficient for the model on the unseen test data was 0.66, the F1 score was 0.72, and the False Negative rate was 27%. This was a substantial improvement over a model with no skill.


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



--------  -----------------------
keyword   text
--------  -----------------------
red       Sunsets, apples, and
          other red or reddish
          things.

green     Leaves, grass, frogs
          and other things it's
          not easy being.
--------  -----------------------

A horizontal rule follows.

***

Here's a definition list:

apples
  : Good for making applesauce.
oranges
  : Citrus!
tomatoes
  : There's no "e" in tomatoe.

Again, text is indented 4 spaces. (Put a blank line between each
term/definition pair to spread things out more.)

Here's a "line block":

| Line one
|   Line too
| Line tree

and images can be specified like so:

![example image](example-image.jpg "An exemplary image")

Inline math equations go in like so: $\omega = d\phi / dt$. Display
math should get its own line and be put in in double-dollarsigns:

$$I = \int \rho R^{2} dV$$

And note that you can backslash-escape any punctuation characters
which you wish to be displayed literally, ex.: \`foo\`, \*bar\*, etc.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTE1MzY5MjEyMywtMTE0MDcxMTA0OCw1Mj
A0ODIxMThdfQ==
-->