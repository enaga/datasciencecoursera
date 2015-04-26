
#
# run_analysis.R 
#

# Step 1 - Read Activity Labels from activity_labels.txt file
# Step 2 - Read variable names from features.txt file and clean the variable names to make them descriptive/readable
# Step 3 - Combine data (SubjectID, X, Y) that belong to each set (train or test)
# Step 4 - Merge data from 2 sets
# Step 5 - Extract the data (mean, std) from the Step 4 data set 
# Step 6 - Create independent tidy set by each ActivityName and SubjectID - mean of each variable

run_analysis <- function(workingdir){

# Set Working Directory

#setwd("C://getdata_projectfiles_UCI HAR Dataset//UCI HAR Dataset//")

# 1. Merges the training and the test sets to create one data set.

# 1.1 - Load Activity Labels
actLblDT <- read.table("activity_labels.txt")

# 1.2 - Load features.txt 
ftrDT <- read.table("features.txt")
ftrLSTRaw <- unlist(ftrDT$V2,use.names=FALSE)

# 1.2.1 - Replace special characters with blank in column names - make the columns more readable
# Appropriately labels the data set with descriptive variable names
ftrLST <- gsub("(-|,|\\(|\\))","",ftrLSTRaw)

# 1.3 - Prepare individual data sets
trainDT <- mergeSetData("train",actLblDT,ftrLST)
testDT <- mergeSetData("test",actLblDT,ftrLST)

#metaDT <- data.frame(set=c("train","test"),rows=c(nrow(trainDT),nrow(testDT)),cols=c(ncol(trainDT),ncol(testDT)))
#metaDT

# 1.4 - Combine individual data sets
mrgDT <- rbind(trainDT,testDT)
#metaDT <- data.frame(set=c("mrgdt"),rows=nrow(mrgDT),cols=ncol(mrgDT))
#metaDT

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# 2.1 - Define the pattern to extract mean and standard deviation columns 
colNames <- names(mrgDT)
ftcolNames <- grep("(SubjectID|mean|std|ActivityName)",colNames,ignore.case=TRUE)

# 2.2 - Extract data only for the specified column names
subDT <- mrgDT[,ftcolNames]
metaDT <- data.frame(set=c("mrgDT","subDT"),rows=c(nrow(mrgDT),nrow(subDT)),cols=c(ncol(mrgDT),ncol(subDT)))
#metaDT

# 3. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 3.1 - By each ActivityName and SubjectID - mean of each variable
tidyDT <- ddply(subDT,.(ActivityName,SubjectID),numcolwise(mean))

# Return tidy data
tidyDT

}

mergeSetData <- function(setName,actLblDT,ftrLST) {
  # 1.3.1 - Load y Labels
  yLblDT <- read.table(paste0(".//",setName,"//y_",setName,".txt"))
  
  # 1.3.2 - Join y Labels with Activity Labels
  # Uses descriptive activity names to name the activities in the data set
  actyLblDT <- join(yLblDT,actLblDT)
  colnames(actyLblDT) <- c("ActivityCode","ActivityName")
  
  # 1.3.3 - Assign Labels to X data
  XDT <- read.table(paste0(".//",setName,"//X_",setName,".txt"))
  colnames(XDT) <- ftrLST
  
  # 1.3.4 - Load subject data 
  subjDT <- read.table(paste0(".//",setName,"//subject_",setName,".txt"))
  colnames(subjDT) <- c("SubjectID")
  
  # 1.3.5 - column bind subject + X (withLabels) + y (WithActivity)
  mrgDT <- cbind(subjDT,XDT,actyLblDT)
  
  # Return the data
  mrgDT
}
