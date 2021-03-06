# Getting_Cleaning_Data_Project
repo for project assignment for Coursera Getting and Cleaning Data course
This is the readme file in which I explain what I have done.

Note: In order to be able to run the script, the following packages have to be installed:
    - plyr
    - dplyr

The run_analysis.R script assumes that the working directory contains the script as well as the top level data folder called "UCI HAR Dataset". The data folder includes subfolders called "test" and "train" containing the actual source data files.

#1. The run_analysis.R script completes the following steps:
##1.1 Read all the data
    "./UCI HAR Dataset/test/X_test.txt"
    "./UCI HAR Dataset/test/y_test.txt"
    "./UCI HAR Dataset/train/X_train.txt"
    "./UCI HAR Dataset/train/Y_train.txt"
    "./UCI HAR Dataset/features.txt"
    "./UCI HAR Dataset/test/subject_test.txt"
    "./UCI HAR Dataset/train/subject_train.txt"
    "./UCI HAR Dataset/activity_labels.txt"
##1.2. cbind all the train data (subjectTrainData,YtrainData,XtrainData)
##1.3. cbind all the test data (subjectTestData,YtestData,XtestData)
##1.4. rbind testdata + traindata into 1 table
##1.5. Assign column headings

#2. Only keep std and mean columns along with subject, activity
    I included the subject and activity columns, 
    and only retained any column where the heading includes "mean" or "std"
    I chose to include those that do not have "()" after the "mean" or "std", 
    as the instructions did not say that they had to be removed 
    - rather have too many columns than too few 

#3. Replace activity codes with descriptive names
    I made use of the package "plyr"

#4. Tidy up variable names
    - remove all "-" in the names as this is iilegal in R naming conventions
    - remove all "()" in the names as this is iilegal in R naming conventions
    - remove redundant text where "Body" is duplicated in a name
    - change "std' to "Std" to adhere to camelCase naming convention
    - change "mean' to "Mean" to adhere to camelCase naming convention
    - Apart from that I did not change any names as I did not want to run the risk of changing meaning of names

#5. Create tidy summary table
    I made use of the package "dplyr"
    The tidy table provides a summarized mean for each measure per unique combination of subject and activity
    I checked some of the results manually in MS Excel to ensure that the calcualtions are correct
    

#6. write data table
    The tidy table is written out to the working directory as a text file

#7. Print("successful!")  
    Included so I can know the script finished successfully :-)
    
# This is the complete run_analysis.R script:
 #1. read all the data

XtestData <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

YtestData <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

XtrainData <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

YtrainData <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = FALSE)
 
 #View(XtrainData)

featuresData <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

 #View(featuresData)

subjectTestData <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

 #View(YtestData)

subjectTrainData <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

 #View(subjectTrainData)

activityData <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

 #cbind all the train data

trainData <- cbind(subjectTrainData,YtrainData,XtrainData)

 #cbind all the test data

testData <- cbind(subjectTestData,YtestData,XtestData)

 #rbind testdata + traindata

allData <- rbind(testData,trainData)

 #rename all column headings

ListOfNames <- as.character(featuresData[,2]) 

names(allData) <- c("subject","activity",ListOfNames)

 #2.only keep std and mean columns along with subject, activity

allDataMean <- allData[, grep("mean()", names(allData) )] 

allDataStd <- allData[, grep("std()", names(allData) )] 

trimmedData<-cbind(allData[1:2],allDataStd,allDataMean)

 #3.replace activity codes with descriptive names

library(plyr)

names(activityData)<-c("activity", "activityDesc")

trimmedData2<-arrange(join(activityData,trimmedData),activity)

trimmedData3<- trimmedData2[,2:82]

 #4.Tidy up variable names

names(trimmedData3) <- gsub("\\-", "", names(trimmedData3))

names(trimmedData3) <- gsub("\\()", "", names(trimmedData3))

names(trimmedData3) <- gsub("BodyBody", "Body", names(trimmedData3))

names(trimmedData3) <- gsub("std", "Std", names(trimmedData3))

names(trimmedData3) <- gsub("mean", "Mean", names(trimmedData3))

 #5.Create tidy summary table

library(dplyr)

tidyData<- trimmedData3 %>% group_by(activityDesc,subject) %>% summarise_each(funs(mean)) 

 #6. write data table

write.table(tidyData,file="tidyData.txt",row.names=FALSE)

print("successful!")  #included so I can know the script finished successfully :-)


# Based upon the following publication:
    License:
    ========
    Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

    [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
    Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. 
    International Workshop of Ambient Assisted Living     (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012




