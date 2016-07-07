CodeBook.md

Summary of transformations made to "UCI HAR Dataset" as part of project for Coursera course in Getting and Cleaning Data.

Data was provided for each of 30 volunteers: a cohort of 21 volunteers whose results were used for training, and a cohort of 9 volunteers whose results were used for testing.  For each of these two cohorts (train and test), the data was provided in three files:  X = 561 test measurements, Y = activity number (range 1-6), subject = volunteer's ID number (range 1-30).  

1. The corresponding six files were read using read.table and converted to tbl_df format.  
2. A variable called cohort was created to distinguish between the volunteers used for training data and those used for testing data.  
3. The 561 variables for each of the 21 training volunteers were combined with those of the 9 testing volunteers, to create a single data set  with 561 variables.  
4. Variables involving only mean and standard deviation were extracted, leaving 66 of the original 561 variables.  
5. Activity variables were renamed for conciseness. 
6. To the 561 measurement variables were added 3 additional variables for volunteer ID number, training or testing cohort, and activity (standing, sitting, etc.).  These were combined into a single tbl_df set, now consisting of 10299 observations (distinguished by volunteer ID and activity, with some replications) of 69 variables. 
7. A separate dataset was constructed by grouping (using dplyr's group\_by) the above data set by ID number, cohort, and activity, and then computing the mean of each of the 561 measurement variables (using "summarize\_each" ).  This data set then consisted of 180 observations (6 activities for each of 30 volunteers) and 69 variables.

For details on the R code used, see README.md

List of Variables

1. IDNum : Number assigned to volunteer (range 1-30)
2. cohort : "train" if member of training group, "test" if member of testing group
3. activity : as defined in given data (sitting, standing, etc.)
4-69 : measurements as defined in given data



