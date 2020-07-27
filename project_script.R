#set working directory
setwd("C:/Users/94979/Desktop/")
#datasets have already been downloaded and unzipped.
#load and merge
train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
test.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
trainData <- cbind(train.subject, train.y, train.x)
testData <- cbind(test.subject, test.y, test.x)
fullData <- rbind(trainData, testData)

#Extract
featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
featureIndex <- grep(("mean|std"), featureName)
finalData <- fullData[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", featureName[featureIndex])

#name
activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activityName
finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])

#label
names(finalData)
names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))

#create dataset
library(dplyr)
groupData <- finalData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(groupData, "tidy_dataset.txt", row.names = FALSE)
