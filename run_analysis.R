#read and name data
test <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_label <- read.table('./UCI HAR Dataset/test/y_test.txt')
test_subject <- read.table('./UCI HAR Dataset/test/subject_test.txt')
training <- read.table('./UCI HAR Dataset/train/X_train.txt')
training_label <- read.table('./UCI HAR Dataset/train/y_train.txt')
training_subject <- read.table('./UCI HAR Dataset/train/subject_train.txt')
variables <- read.table('./UCI HAR Dataset/features.txt')

#rename the columns and merge tables
cbind(test_subject, test_label,test) -> test
cbind(training_subject,training_label,training) -> training
rbind(test, training) -> merged
colnames(merged) <- c('subject', 'label', as.character(variables$V2))

#extract measurements on mean and standard deviation
extracted <- merged[, c(1,2,grep(pattern = 'mean[^F]|std', x= colnames(merged)))]

#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
as.factor(extracted$label) -> extracted$label
levels(extracted$label) <- c('walking', 'walking_upstairs', 'walking_downstairs', 'sitting', 'standing', 'laying')

#creates a second, independent tidy data set with the average of each variable for each activity and each subject

as.factor(extracted$subject) -> extracted$subject
group_by(extracted, subject, label) -> grouped
summarise_all(grouped, mean) -> tidydata
write.table(final, './TidyData.txt', row.names = FALSE)
