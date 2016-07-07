README.md

Script info to accompany  made to "UCI HAR Dataset" as part of project for Coursera course in Getting and Cleaning Data.

The files were read in tbl_df format to facilitate tidying operations
    
    # Read data files
    trainX <- tbl_df(read.table("./data/UCI HAR Dataset/train/x_train.txt")) # train set 
    trainY <- tbl_df(read.table("./data/UCI HAR Dataset/train/y_train.txt")) # test labels 1-6 (activities)
    trainSubj <- tbl_df(read.table("./data/UCI HAR Dataset/train/subject_train.txt")) # Subject ID's, 1-30
    testX <- tbl_df(read.table("./data/UCI HAR Dataset/test/x_test.txt")) # test set
    testY <- tbl_df(read.table("./data/UCI HAR Dataset/test/y_test.txt")) # test labels 1-6 (activities)
    testSubj <- tbl_df(read.table("./data/UCI HAR Dataset/test/subject_test.txt")) # Subject ID's, 1-30
    
The following block renamed the subject identification and added a cohort variable to distinguish
between those subjects used for training and those used for training.

    # Rename Subject IDs and add column to distinguish training and testing groups
    names(trainSubj)[1] <- "IDnum"
    names(testSubj)[1] <- "IDnum"
    trainSubj <- mutate(trainSubj, cohort = "train")
    testSubj <- mutate(testSubj, cohort = "test")

The following block combined the measurements, activities, and IDs for the two cohorts into one set.
    
    # Combine x, y, and subject data (by rows) for training and testing groups 
    x <- bind_rows(trainX, testX)
    y <- bind_rows(trainY, testY)
    subj <- bind_rows(trainSubj, testSubj)
    
    ##      Requirement 1 completed -- Training and test sets combined.
    
The following block extracts only measurements of means and standard deviations.

    # Read features, extract those involving only mean and standard deviation
    features <- read.table("./data/UCI HAR Dataset/features.txt")
    goodindex <- grep("-mean\\(\\)|-std\\(\\)", features$V2)
    x <- x[goodindex]
    
    ##      Requirement 2 completed -- Extracted only measurements on mean and s.d. 
    
The following blocks rename variables

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
    activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
    y <- mutate(y, newact = activities[y$V1[],2])
    y <- select(y, 2)
    names(y) <- "activity"
    
    ##      Requirement 3 completed -- Descriptive activity names.

The following block combines the components into a single tidy data set.
    
    # Combine subject, activity, and test set variables
    mydt <- bind_cols(subj, y, x)
    write.table(mydt, "TidyDataSet1.txt")
    
    ##      Requirement 4 completed -- TidyDataSet1.txt is a tidy data set with appropriate names.
    
The following block identifies average values of each measurement, for each activity for each subject.

    mydtGrouped <- group_by(mydt, IDnum, cohort, activity) 
    # Note: including "cohort" in the command above avoids warnings in next step
    mydtGroupedMeans <- summarize_each(mydtGrouped, funs(mean))
    write.table(mydtGroupedMeans, "TidyDataSet2.txt")
    
    ##      Requirement 5 completed -- TidyDataSet2.txt is the desired data set of averages.
    