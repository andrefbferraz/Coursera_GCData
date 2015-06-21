library(plyr)
library(reshape2)

#Downloading data
if (!file.exists(DS03W03CP)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, DS03W03CP)
}  
if (!file.exists("DS03W03CP")) { 
  unzip(DS03W03CP) 
}

#Getting data from folder

TrainX <- read.table("./train/X_train.txt")
TestX <- read.table("./test/X_test.txt")

TrainY <- read.table("./train/y_train.txt")
TestY <- read.table("./test/y_test.txt")

TrainSub <- read.table("./train/subject_train.txt")
TestSub <- read.table("./test/subject_test.txt")

#Building up names
#Filtering mean and std deviation
activity <- read.table("activity_labels.txt")
features <- read.table("features.txt")

activity[,2] <- as.character(activity[,2])
features[,2] <- as.character(features[,2])

NewFeat <- grep(".*mean.*|.*std.*", features[,2])
NewFeat.names <- features[NewFeat,2]
NewFeat.names = gsub('-mean', 'Mean', NewFeat.names)
NewFeat.names = gsub('-std', 'Std', NewFeat.names)
NewFeat.names <- gsub('[-()]', '', NewFeat.names)


#Bidding data
#Firstly function will merge Train and Test X, Y and Subjects in cols
#Finally function will merge Train and Test in rows

TrainBind <- cbind(TrainSub, TrainY, TrainX)
TestBind <- cbind(TestSub, TestY, TestX)

DB_Bind <- rbind(TrainBind, TestBind)
colnames(DB_Bind) <- c("Sbj", "Act", NewFeat.names)

DB_Bind$Act <- factor (DB_Bind$Act, levels = activity[,1], levels = activity[,2])
DB_Bind$Sbj <- as.factor(DB_Bind$Sbj)

#Melt data to buil tidy file

TidyDBtemp <- melt(DB_Bind, id = c("Sbj", "Act"))
TidyDB <- dcast(TidyDBtemp, Sbj + Act ~ variable, mean)

write.table(TidyDB, "tidy.txt", row.names = FALSE, quote = FALSE)



