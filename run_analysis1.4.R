#Daniel Piper's R script for Getting and Cleaning data
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names.
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



library(dplyr)

filename <- "Coursera_DS3_Final.zip"

# Checking if data and file already is downloaded
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if file exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
signal_x_test <- read.table("UCI HAR Dataset/test/signal_x_test.txt", col.names = features$functions)
signal_y_test <- read.table("UCI HAR Dataset/test/signal_y_test.txt", col.names = "code")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
signal_x_train <- read.table("UCI HAR Dataset/train/signal_x_train.txt", col.names = features$functions)
signal_y_train <- read.table("UCI HAR Dataset/train/signal_y_train.txt", col.names = "code")

#1.Merges the training and the test sets to create one data set.

X <- rbind(signal_x_train, signal_x_test)
Y <- rbind(signal_y_train, signal_y_test)
Subject <- rbind(subj_train, subj_test)
Data_Merge <- cbind(Subject, Y, X)

#2.Extracts only the measurements on the mean and standard deviation for each measurement.

TidyData <- Data_Merge %>% select(subject, code, contains("mean"), contains("std"))

#3.Uses descriptive activity names to name the activities in the data set

TidyData$code <- activities[TidyData$code, 2]

#4.Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

#5.From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity 
#and each subject.

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)



str(FinalData)

