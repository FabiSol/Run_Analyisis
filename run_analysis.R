#1.	Merges the training and the test sets to create one data set.


setwd("C://Users//Fabiola Ramírez//Desktop//COURSERA//3 CLEANING DATA//data")

sub_tra<- read.table("train//subject_train.txt")
x_train <- read.table("train//X_train.txt")
y_train<-read.table("train//y_train.txt")

sub_test<- read.table("test//subject_test.txt")
x_test <- read.table("test//X_test.txt")
y_test<-read.table("test//y_test.txt")

features<-read.table("features.txt")

names(sub_tra)<-"id"
names(y_train)<-"id_act"
names(x_train)<-features$V2
  
names(sub_test)<-"id"
names(y_test)<-"id_act"
names(x_test)<-features$V2


train<-cbind(sub_tra,y_train,x_train)
test<-cbind(sub_test,y_test,x_test)


data<-rbind(train,test)


#2.	Extracts only the measurements on the mean and standard deviation for each measurement.


v1<-grep("mean",names(data))
v2<-grep("std",names(data))
vu<-c(1,2,v1,v2)

meanstd<-data[,vu]

#3. Uses descriptive activity names to name the activities in the data set

activity<- read.table("C://Users//Fabiola Ramírez//Desktop//COURSERA//3 CLEANING DATA//data//activity_labels.txt")
colnames(activity)<- c("id_act","activity")
data2 <- merge(x=meanstd, y=activity, by="id_act")

#4.Appropriately labels the data set with descriptive variable names.
names(data2)<-gsub("^t", "time", names(data2))
names(data2)<-gsub("^f", "frequency", names(data2))
names(data2)<-gsub("Acc", "Accelerometer", names(data2))
names(data2)<-gsub("Gyro", "Gyroscope", names(data2))
names(data2)<-gsub("Mag", "Magnitude", names(data2))
names(data2)<-gsub("BodyBody", "Body", names(data2))

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)
data2$id <- as.factor(data2$id)
data2 <- data.table(data2)

tidyData <- aggregate(. ~id + activity, data2, mean)
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
