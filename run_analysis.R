# run_analysis.R
# A script created in fulfillment of the requirements for the Coursera course
# on Getting and Cleaning Data.
# R. Zarnowski, July 2016

# Instructions
# You will be required to submit: 1) a tidy
# data set as described below, 2) a link to a Github repository with your script
# for performing the analysis, and 3) a code book that describes the variables,
# the data, and any transformations or work that you performed to clean up the
# data called CodeBook.md. You should also include a README.md in the repo with
# your scripts. This repo explains how all of the scripts work and how they are
# connected.
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set. 
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the
#    average of each variable for each activity and each subject.

library(dplyr)

# Read data files
trainX <- tbl_df(read.table("./UCI HAR Dataset/train/x_train.txt")) # train set 
trainY <- tbl_df(read.table("./UCI HAR Dataset/train/y_train.txt")) # test labels 1-6 (activities)
trainSubj <- tbl_df(read.table("./UCI HAR Dataset/train/subject_train.txt")) # Subject ID's, 1-30
testX <- tbl_df(read.table("./UCI HAR Dataset/test/x_test.txt")) # test set
testY <- tbl_df(read.table("./UCI HAR Dataset/test/y_test.txt")) # test labels 1-6 (activities)
testSubj <- tbl_df(read.table("./UCI HAR Dataset/test/subject_test.txt")) # Subject ID's, 1-30

# Rename Subject IDs and add column to distinguish training and testing groups
names(trainSubj)[1] <- "IDnum"
names(testSubj)[1] <- "IDnum"
trainSubj <- mutate(trainSubj, cohort = "train")
testSubj <- mutate(testSubj, cohort = "test")

# Combine x, y, and subject data (by rows) for training and testing groups 
x <- bind_rows(trainX, testX)
y <- bind_rows(trainY, testY)
subj <- bind_rows(trainSubj, testSubj)

##      Requirement 1 completed -- Training and test sets combined.

# Read features, extract those involving only mean and standard deviation
features <- read.table("./UCI HAR Dataset/features.txt")
goodindex <- grep("-mean\\(\\)|-std\\(\\)", features$V2)
x <- x[goodindex]

##      Requirement 2 completed -- Extracted only measurements on mean and s.d. 

# Rename test variables with feature names, and tidy up the names
# NOTE: The variable names cannot meet all the preferred guidelines (lowercase, etc.)
#       without losing descriptive value, so much of original names is preserved.
#
names(x) <- features$V2[goodindex]
names(x) <- gsub("-mean\\(\\)-", "Mean", names(x))
names(x) <- gsub("-mean\\(\\)", "Mean", names(x))
names(x) <- gsub("-std\\(\\)-", "StDev", names(x))
names(x) <- gsub("-std\\(\\)", "StDev", names(x))

# Rename activity variable and values
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
y <- mutate(y, newact = activities[y$V1[],2])
y <- select(y, 2)
names(y) <- "activity"

##      Requirement 3 completed -- Descriptive activity names.

# Combine subject, activity, and test set variables
mydt <- bind_cols(subj, y, x)
write.table(mydt, "TidyDataSet1.txt")

##      Requirement 4 completed -- TidyDataSet1.txt is a tidy data set with appropriate names.

mydtGrouped <- group_by(mydt, IDnum, cohort, activity) 
# Note: including "cohort" in the command above avoids warnings in next step
mydtGroupedMeans <- summarize_each(mydtGrouped, funs(mean))
write.table(mydtGroupedMeans, "TidyDataSet2.txt")

##      Requirement 5 completed -- TidyDataSet2.txt is the desired data set of averages.
