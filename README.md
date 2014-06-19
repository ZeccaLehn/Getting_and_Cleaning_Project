## **README.md -- describes how tidy data set is generated from the run_analysis.R script.**

### General instructions: Provided by Johns Hopkins (Data Science Track [June 2014])


1) Merge training and the test sets to create one data set

2) Extracts only the measurements on the mean and standard deviation for each measurement. 

3) Uses descriptive activity names to name the activities in the data set

4) Appropriately labels the data set with descriptive variable names. 

5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


### Specific Instructions: Matches sections in run_analysis.R script


-First, create a folder and set it equal to directory

-setwd('yourworkingdirectory')

-Checks your chosen Working Directory for the folder named "data", and creates it in the directory if it does not already exist.

-Downloads .zip from link and directly extracts to the "./data" folder 
  
-Names unzipped in ./data folder, based on existing file name

-Tables read in as new objects; used to combine sets

-Merge Data Sets (Chunks)

-Narrows 'dataset' and groups by activity and subject; filters columns by "mean" and "sd"

-Rowbinds tidy_data set and outputs both means of activity and subject to directory as "tidy_data.csv"


###References

-Data Source: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

-Descriptive Source:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones



[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

