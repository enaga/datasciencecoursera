# Instructions

Please follow these steps to generate the tidy data from Samsung data

1. Place the Samsung data in C:/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/
2. Set working directory to C:/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/
3. run_analysis.R will read the Samsung Data located in the above folders performs these steps
	- Step 1 - Read Activity Labels from activity_labels.txt file
	- Step 2 - Read variable names from features.txt file and clean the variable names to make them descriptive/readable
	- Step 3 - Combine data (SubjectID, X, Y) that belong to each set (train or test)
	- Step 4 - Merge data from 2 sets
	- Step 5 - Extract the data (mean, std) from the Step 4 data set 
	- Step 6 - Create independent tidy set by each ActivityName and SubjectID - mean of each variable
	
4. Run this command in R command line to assign the output to a data frame

   tidyDT <- run_analysis()
   
   tidyDT is the aggregated data set by ActivityName, SubjectID with mean of each variable

5. Output the tidy data set to a txt file using this

    write.table(tidyDT,file="tidyData_Average.txt",row.names=FALSE)   

