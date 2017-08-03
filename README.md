# GettingAndCleaningData

In the first part of the analysis I have loaded all the datasets to the R. Each dataset contained rows separated by tab, within each row values were separated by spaces (sometimes more than one). In order to separate the values i ised dplyr function 'separate'. For test.set and train.set there was need to handle multiple spaces - this (in particular) is done by function clean.set, written in the code.

Having loaded all the needed data, i.e. sets, labels, subjects, I combined them together. At first, I combined sets with label and subject. Then I binded train set and test set. adding (just in case) and id variable indicating its source (train or test).

The next step was to select only the variables of mean and standard deviation. This I achieved selecting columns that contains words like "mean" and "std".

In the next step I merged combined dataset with dictionary label vs activity, in order to have descriptive variable activity instead of integer variable label.

Next, I cleaned names of the variable, removing multiple '.', in order to be able to manipulate their names easier.

Finally, a tidy dataset was created in a few steps:

(1) data was grouped by subject and activity

(2) all variables were summarized as means (average value)

(3) in order to achieve tidyness, I gatheres variables into three columns, indicating: variable(what is measured), axis(X, Y, Z or NA) and statistics(mean or standard deviation - std)

(4) finally, I removed unnecessary columns, earranged the order of the remaining ones and obtained a tidy dataset.
