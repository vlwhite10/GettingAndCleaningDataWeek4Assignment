library(dplyr)

#1: MERGE DATA SETS
#read in features
Features<-read.table("features.txt", col.names=c("Index", "Function"))

###COMPILE TRAINING DATA SET###
#read in subject file for Train data
TrainSubjects<-read.table("train/subject_train.txt", col.names="Subject_ID")
# read in files to compile Training data set
GalaxyTrain<-read.table("train/X_train.txt", col.names= Features$Function)
#read in labels
GalaxyTrainLabels<-read.table("train/y_train.txt", col.names="Activity_ID")
#Combine row and column labels to data set
GalaxyTrain<-cbind(TrainSubjects, GalaxyTrainLabels, GalaxyTrain)

###COMPILE TEST DATA SET###
# read in subject file for Test data
TestSubjects<-read.table("test/subject_test.txt", col.names="Subject_ID")
# read in files to compile Test data set
GalaxyTest<-read.table("test/X_test.txt", col.names=Features$Function)
# read in label files to append Test set
GalaxyTestLabels<-read.table("test/y_test.txt", col.names="Activity_ID")
# combine row and column labes to test data set
GalaxyTest<-cbind(TestSubjects, GalaxyTestLabels, GalaxyTest)

### CREATE COMPLETE DATA SET###
GalaxyData<-rbind(GalaxyTest, GalaxyTrain)

#3: USE DESCRIPTIVE ACTIVITY NAMES 
#read in activities
Activities<-read.table("activity_labels.txt", col.names=c("Activity_ID","Activity_Name"))
GalaxyData <- merge(Activities, GalaxyData, by.x="Activity_ID", by.y="Activity_ID")

#2: EXTRACT MEAN AND ST DEV
GalaxyData <- GalaxyData[,(grepl("mean|std|Subject|Activity_Name", colnames(GalaxyData) ) == T)]


#4: DESCRIPTIVE VARIABLE NAMES
names(GalaxyData) <- gsub("\\()", "", names(GalaxyData))
names(GalaxyData) <- gsub("^t", "time", names(GalaxyData))
names(GalaxyData) <- gsub("^f", "frequence", names(GalaxyData))
names(GalaxyData) <- gsub("Acc", "Accelerometer", names(GalaxyData))
names(GalaxyData) <- gsub("Gyro", "Gyroscope", names(GalaxyData))
names(GalaxyData) <- gsub("BodyBody", "Body", names(GalaxyData))
names(GalaxyData) <- gsub("Mag", "Magnitude", names(GalaxyData))
names(GalaxyData) <- gsub("tBody", "TimeBody", names(GalaxyData))
names(GalaxyData) <- gsub("-mean", "Mean", names(GalaxyData))
names(GalaxyData) <- gsub("-std", "Std", names(GalaxyData))

#5: SECOND DATA SET WITH AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND SUBJECT

GalaxySummary <- GalaxyData %>%
  group_by(Subject_ID, Activity_Name) %>%
  summarise_all(funs(mean))
write.table(GalaxySummary, "GalaxySummary.txt", row.name=FALSE)

str(GalaxySummary)

