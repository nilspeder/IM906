# Fault Prediction in the Crowd?


An investigation was conducted into a 40 GB, 326 million record event dataset. This dataset contained anonymised event information representing performance, availability and security issues of 172,000 network devices from approximately 150 different customers. It was hypothesised that network device event data gathered from one customer environment could be used to predict events in another customer environment. After analysis of the dataset, a binary model was developed to predict when a process might request too much compute resources on a device. The model was developed on one set of customer data and tested on another unseen set of customer data. The Matthews correlation coefficient for the model on the unseen test data was 0.66, the F1 score was 0.72, and the False Negative rate was 27%. This was a substantial improvement over a model with no skill.


Files
------------


 1. Data
      * /data/data1k.csv
      * /data/data1m.csv
      * /data/long_cpu_hog_prod126.csv

 2. Graphs.
	  * /data/data1k.csv

 4. Dump everything in the pot and follow
    this algorithm:

        find wooden spoon
        uncover pot
        stir
        cover pot
        balance wooden spoon precariously on pot handle
        wait 10 minutes
        goto first step (or shut off burner when done)

    Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 4-space indents (including
that last line which continues item 3 above).

Here's a link to [a website](http://foo.bar), to a [local
doc](local-doc.html), and to a [section heading in the current
doc](#an-h2-header). Here's a footnote [^1].

[^1]: Footnote text goes here.

Tables can look like this:

size  material      color
----  ------------  ------------
9     leather       brown
10    hemp canvas   natural
11    glass         transparent

Table: Shoes, their sizes, and what they're made of

(The above is the caption for the table.) Pandoc also supports
multi-line tables:

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
eyJoaXN0b3J5IjpbLTUxNzc3Mzk5LC0xMTQwNzExMDQ4LDUyMD
Q4MjExOF19
-->