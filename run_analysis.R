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



