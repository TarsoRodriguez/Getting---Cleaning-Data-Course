Getting---Cleaning-Data-Course
==============================

Course Project

==============================

###The project includes the following files:

- readme.md: a guide of the contents of project and a guide to run it
- run_analysis.r: An script that creates a Tidy Data of test and train Samsung data sets
- codebook.md: explanation of each variable in tidy data created through the script run_analysis.r

==============================
###Guide

- In order to run the script (run_analysis.r), Samsung data set should be in you working directory
- Samsug data set, should be in a directory called **UCI HAR Dataset**
- the result of the script is a tidy data file in your working directory called **TidyData.txt**

==============================
###Script general explanation

- *run_analysis.r* script loads all data sets (X_test.txt and X_train.txt) and put them together
- Column names are load from features.txt, fixed some mispelling and added to the data frame
- All subjects (subject_test.txt and subject_train.txt) are loaded and added to the big data frame as a variable called subject
- All activities (Y_test.txt and Y_train.txt) are loaded and added to the big data frame as a variable called Activity
- All mean and standard deviation columns are extracted and put in another data frame
- All activities are changed in order to use their descriptive names
- A tidy data is created based on meand and standard deviation columns extrated from the complete data frame and their average is calculated
- the final tidy data file is created in the working directory