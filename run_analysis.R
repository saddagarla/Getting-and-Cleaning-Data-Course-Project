## run_analysis.R

## The following code implements the code for 'Getting and Cleaning Data Course Project'

## this script requires two packages -  data.table and reshape2

if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}
require("data.table")
require("reshape2")

## Load column names(variables)
features <- read.table("./UCI HAR Dataset/features.txt", sep = " ")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
mean_std_features <- grepl("mean|std", features)

# Load activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

## read X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(X_test) = features

## Extract only the measurements on the mean and standard deviation for each measurement.
X_test <- X_test[,mean_std_features]

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(subject_test) = "Subject"

## use descriptive activity names to name the activities in the data set
y_test[,2] <- activity_labels[y_test[,1]]
alabels = c("Activity_ID", "Activity_Label")
names(y_test) <- alabels

## now bind the data
test_data <- cbind(subject_test, y_test, X_test)


## read  X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(X_train) <- features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,mean_std_features]

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subject_train) = "Subject"

# Load activity labels
y_train[,2] <- activity_labels[y_train[,1]]
names(y_train) <- alabels

## now bind the data
train_data <- cbind(subject_train, y_train, X_train)
data <- rbind(test_data, train_data)

###  Merge test and train data
id_labels <- c("Subject", "Activity_ID","Activity_Label")
col_names <- colnames(data)
measure_var_labels <- col_names[!(col_names %in% id_labels)]

## melta data using reshape2 package
melt_data <- melt(data, id=id_labels, measure.vars = measure_var_labels)

## apply mean function to data using dcast
tdata <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)
write.table(tdata, file = "./UCI HAR Dataset/tdata.txt", row.names = FALSE)
 