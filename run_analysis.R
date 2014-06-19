###**run_analysis.R**

#First, create a folder and set it equal to directory
#setwd('yourworkingdirectory')

library(reshape2)

#Checks your chosen Working Directory for the folder named "data", and creates it in the directory
#if it does not already exist.
        
        if(!file.exists("./data")){dir.create("./data")}

#Downloads .zip from link and directly extracts to the "./data" folder 
        
        temp <- tempfile()   #Creates a temporary linked file within the temp directory.
        download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
        unzip(temp, exdir = "./data")   #Extracts zip file to ./data folder 
        unlink(temp)  #Unlinks temp file from 'tmp' folder

#Names unzipped in ./data folder, based on existing file name

        nameDownload <- list.files("./data")
        #Sets folder variable as subdirectory in Samsung data set        
        folder <- paste("./data/", nameDownload, sep = "")

#Tables read in as new objects; used to combine sets

        path <- paste(folder, "/train/X_train.txt", sep="")
        trainX <- read.table(path)
        #print(head(trainX, n = 5))
        #str(trainX)

        path <- paste(folder, "/test/X_test.txt", sep="")
        testX <- read.table(path)
        #print(head(testX, n = 5))
        #str(testX)

        path <- paste(folder, "/train/y_train.txt", sep="")
        trainY <- read.table(path)
        #print(head(trainY, n = 5))
        #tail(trainY)
        #str(trainY)
        
        path <- paste(folder, "/test/y_test.txt", sep="")
        testY <- read.table(path)
        #print(head(testY, n = 5))
        #str(testY)
        
        path <- paste(folder, "/train/subject_train.txt", sep="")
        trainSubj <- read.table(path)
        #print(head(trainSubj, n = 5))
        #str(trainSubj)
                
        path <- paste(folder, "/test/subject_test.txt", sep="")
        testSubj <- read.table(path)
        #print(head(testSubj, n = 5))
        #str(testSubj)
        
        path <- paste(folder, "/activity_labels.txt", sep="")
        actLabels <- read.table(path)
        #print(head(actLabels, n = 5))
        #str(actLabels)
        
        path <- paste(folder, "/features.txt", sep="")
        features <- read.table(path)
        #print(head(features, n = 5))
        #str(features)

#Merge Data Sets
           
                #Row binds training and test set
                rowBoundX <- rbind(trainX, testX)
                #Attach feature names to header of rowBoundX
                featureVec <- features$V2                
                        #str(featureVec)
                        #tail(rowBoundX)
                        #str(rowBoundX)
                        #names(rowBoundX)
                        #head(rowBoundX)

                #Row binds training and test set
                rowBoundY <- rbind(trainY, testY)
                        #head(rowBoundY)
                        #str(rowBoundY) 
                        #names(rowBoundY)
         
                #Row binds training and test set
                subject <- rbind(trainSubj, testSubj)
                        #tail(subject)              
                        #str(subject) 
                
                                
                #Matches activity IDs to appropriate label number (i.e., 1 = "WALKING", 2 = "WALKING_UPSTAIRS",
                #3 = "WALKING_DOWNSTAIRS", 4 = "SITTING", 5 = "STANDING", 6 = "LAYING")...and a partridge in...               
                index <- merge(rowBoundY, actLabels, by = "V1")
                        #head(index)
                        #head(subject)
                        #head(rowBoundX, n = 3)
                
                #Assigns names to column headers for extracting mean() and sd()             
                names(subject) <- "subject"                
                names(index) <- c("id", "activity")
                names(rowBoundX) <- featureVec
                
                #Initial wide data set from binding and merging
                dataset <- cbind(index, subject, rowBoundX)
                        #head(dataset, n = 2)
                        #names(dataset)
                        #write.csv(dataset, 'testset.csv', row.names = FALSE) 

#Narrows 'dataset' and groups by activity and subject; filters columns by "mean" and "sd"

                #Grep extracts column counts from dataset header containing "-mean" or "-std"
                colIndex <- grep("-mean|-std", names(dataset)) #Note: No spaces after/before "|"
                
                #Wide dataset renamed with activity, subject, and mean/sd columns only
                data <- dataset[, c(2, 3, colIndex)]
                
                #Data melt by activity / subject -- Narrow dataset filtered by "mean" and "sd"
                dataMelt = melt(data, id.var = c("activity", "subject"))
                #head(dataMelt, n= 50)
                
                #Averages from narrowed variables by activity and subject; splits data for rowbinding activity with subject.
                #Uses reshape2 package to cast dataMelt into a data frame       
                activityMeans = dcast(dataMelt, activity ~ variable, mean)
                subjectMeans = dcast(dataMelt, subject ~ variable, mean)


                        #Renames first column to match below by "acivitySubject -- includes both activity and subject factors.
                        activityLabels <- names(activityMeans) 
                        activityLabels[1] <-"activtySubject"
                        names(activityMeans) <- activityLabels
                        activityMeans #Means of 6 activities by measurement variables with mean or stdev
                                #class(activityMeans[1])
                                #ncol(activityMeans)
                        

                        #Averages from narrowed variables by activity; splits data for rowbinding subject with activity.
                        #Renames first column to match below by "acivitySubject -- includes both activity and subject factors.
                        subjectLabels <- names(subjectMeans) 
                        subjectLabels[1] <-"activtySubject"
                        names(subjectMeans) <- subjectLabels
                        #Assigns "-SUBJECT" sequentially to each subject 1 to 30 for rbinding as tidyData frame                        
                        subjectMeans[1] <- paste(seq(1, 30, by = 1), subjName <- "- SUBJECT") 
                                #head(subjectMeans)
                                #names(subjectMeans)
                                #class(subjectMeans[1])
                                #ncol(subjectMeans)                       
                                #names(activityMeans) == names(subjectMeans) #Must all be TRUE to rbind

#Rowbinds tidy_data set and outputs both means of activity and subject to directory as "tidy_data.csv"
                
                #"activitySubject" column averages both activity(by 1:30) and subject (by e.g., "WALKING","STANDING")
                tidyData <- rbind(activityMeans, subjectMeans)
                write.table(tidyData, file="tidy_data.txt", row.names = FALSE)






