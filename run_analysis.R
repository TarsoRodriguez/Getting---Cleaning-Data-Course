run_analysis <- function(){
    library(plyr)
    
    CheckDirectory <- grep("UCI HAR Dataset", list.files())
    if (length(CheckDirectory) == 0){
        stop("Samsung Data Set directory is not in your working directory. Please copy Samsung data set (UCI HAR Dataset) to your working directory!")
    }
    
    ## Loading all data sets
    DF_Subject_Test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
    DF_X_Test <- read.table("./UCI HAR Dataset/test/X_test.txt")
    DF_Y_Test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
    DF_Subject_Train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
    DF_X_Train <- read.table("./UCI HAR Dataset/train/X_train.txt")
    DF_Y_Train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
        
    ## Loading and adjusting column names
    Column_Names <- read.table("./UCI HAR Dataset/features.txt")
    Column_Names <- tolower(Column_Names[,2])
    Column_Names <- gsub("bodybody", "body", Column_Names)
    
    ## Adding column names
    colnames(DF_X_Test) <- Column_Names
    colnames(DF_Subject_Test) <- "Subject"
    colnames(DF_Y_Test) <- "Activity"
    colnames(DF_X_Train) <- Column_Names
    colnames(DF_Subject_Train) <- "Subject"
    colnames(DF_Y_Train) <- "Activity"
    
    ##Loading activity labels
    Activity_Labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
    colnames(Activity_Labels) <- c("ID", "ActivityLabel")
    Activity_Labels <- arrange(Activity_Labels, ActivityLabel)
    
    ## Creating a merged Data Set (test set + training set)
    DF_Data_Set <- cbind(DF_Subject_Test, DF_Y_Test, DF_X_Test)
    DF_Data_Set <- rbind(DF_Data_Set, cbind(DF_Subject_Train, DF_Y_Train, DF_X_Train))
    
    ##Identify all means and standard deviation columns
    Mean_STD_Columns <- grep("mean|std", names(DF_Data_Set))
    ##Extracts only the measurements on the mean and standard deviation for each measurement.
    DF_Mean_STD_Data_Set <- DF_Data_Set[1]
    DF_Mean_STD_Data_Set <- cbind(DF_Mean_STD_Data_Set, DF_Data_Set[2])
    for (i in seq_along(Mean_STD_Columns)){
        DF_Mean_STD_Data_Set <- cbind(DF_Mean_STD_Data_Set, DF_Data_Set[Mean_STD_Columns[i]])
    }
    
    ##Uses descriptive activity names to name the activities in the data set
    DF_Mean_STD_Data_Set$Activity <- as.character(DF_Mean_STD_Data_Set$Activity)
    for (i in seq_len(nrow(DF_Mean_STD_Data_Set))){
        DF_Mean_STD_Data_Set$Activity[i] <- as.character(Activity_Labels$ActivityLabel[as.numeric(DF_Mean_STD_Data_Set$Activity[i])])
    }
    
    ##Initializing...
    Tidy_Data <- DF_Mean_STD_Data_Set[0,]
    Tidy_Data <- rbind(Tidy_Data, rep(0, length(names(Tidy_Data))))
    colnames(Tidy_Data) <- names(DF_Mean_STD_Data_Set)
    Tidy_Data$Activity <- as.character(Tidy_Data$Activity)
    ##Building Tidy Data...
    CountLines <- 0
    for (i in seq_along(unique(DF_Mean_STD_Data_Set$Subject))){
        Aux <- DF_Mean_STD_Data_Set[DF_Mean_STD_Data_Set$Subject == i, ]
        Tidy_Data <- rbind(Tidy_Data, rep(0, length(names(Tidy_Data))))
        Tidy_Data <- rbind(Tidy_Data, rep(0, length(names(Tidy_Data))))
        Tidy_Data <- rbind(Tidy_Data, rep(0, length(names(Tidy_Data))))
        Tidy_Data <- rbind(Tidy_Data, rep(0, length(names(Tidy_Data))))
        Tidy_Data <- rbind(Tidy_Data, rep(0, length(names(Tidy_Data))))
        if (i > 1) {
            Tidy_Data <- rbind(Tidy_Data, rep(0, length(names(Tidy_Data))))
        }
        for (j in 3:88){
            Aux_Summarize <- tapply(Aux[, j], Aux$Activity, mean, simplify=FALSE)
            Tidy_Data$Subject[1 + CountLines] <- i
            Tidy_Data$Activity[1 + CountLines] <- names(Aux_Summarize)[1]
            Tidy_Data[1 + CountLines, j] <- Aux_Summarize[1]
            Tidy_Data$Subject[2 + CountLines] <- i
            Tidy_Data$Activity[2 + CountLines] <- names(Aux_Summarize)[2]
            Tidy_Data[2 + CountLines, j] <- Aux_Summarize[2]
            Tidy_Data$Subject[3 + CountLines] <- i
            Tidy_Data$Activity[3 + CountLines] <- names(Aux_Summarize)[3]
            Tidy_Data[3 + CountLines, j] <- Aux_Summarize[3]
            Tidy_Data$Subject[4 + CountLines] <- i
            Tidy_Data$Activity[4 + CountLines] <- names(Aux_Summarize)[4]
            Tidy_Data[4 + CountLines, j] <- Aux_Summarize[4]
            Tidy_Data$Subject[5 + CountLines] <- i
            Tidy_Data$Activity[5 + CountLines] <- names(Aux_Summarize)[5]
            Tidy_Data[5 + CountLines, j] <- Aux_Summarize[5]
            Tidy_Data$Subject[6 + CountLines] <- i
            Tidy_Data$Activity[6 + CountLines] <- names(Aux_Summarize)[6]
            Tidy_Data[6 + CountLines, j] <- Aux_Summarize[6]
        }
        CountLines <-  CountLines + 6
    }
    write.table(Tidy_Data, file="./TidyData.txt", sep=",", row.names=FALSE, append=FALSE)
    
    print("The TidyData.txt file was created in your working directory!")
}