packages(dplyr)
packages(tidyr)

defaultwd <- getwd()

setwd("C:/Users/wiazecp/Desktop/Coursera/Getting and Cleaning Data/project/UCI HAR Dataset")

activity.labels <- read.delim("activity_labels.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(activity.labels) <- "aux"
activity.labels <- activity.labels %>%
    separate( col = aux, into = c("label", "activity"), sep = " ")

features <- read.delim("features.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(features) <- "aux"
features <- features %>%
    separate( col = aux, into = c("label", "desc"), sep = " ")

## Load subjects

subject.test <- read.delim("test/subject_test.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(subject.test) <- "subject"

subject.train <- read.delim("train/subject_train.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(subject.train) <- "subject"

## Load test.set and clean.set

clean.set <- function(set){
    colnames(set) = "aux"
    set$aux <- sapply(set$aux, function(x){
        y <- gsub(pattern = "\\s+", replacement = " ", x)
        gsub(pattern = "^\\s", replacement = "", y)
    })
    
    ## check consistency
    if(max(sapply(strsplit(set$aux, " "), length)) != length(features$desc)){
        stop("Error with data occured!")
    }
    
    set <- separate(set, col = aux, into = features$desc, sep = " ")
    set <- as.data.frame(sapply(set, as.numeric))
    set
}

test.set <- clean.set(read.delim("test/X_test.txt", header = FALSE, stringsAsFactors = FALSE))
train.set <- clean.set(read.delim("train/X_train.txt", header = FALSE, stringsAsFactors = FALSE))

## Load labels

test.labels <- read.delim("test/y_test.txt", header = FALSE, stringsAsFactors = FALSE)
train.labels <- read.delim("train/y_train.txt", header = FALSE, stringsAsFactors = FALSE)

## Merge with labels and subject

test.set$label <- test.labels[[1]]
train.set$label <- train.labels[[1]]

test.set$subject <- subject.test[[1]]
train.set$subject <- subject.train[[1]]

## add key for differentiating the data from different datasets

test.set <- data.frame(id = paste("test.", rownames(test.set), sep=""), test.set)
test.set$id <- as.character(test.set$id)

train.set <- data.frame(id = paste("train.", rownames(train.set), sep=""), train.set)
train.set$id <- as.character(train.set$id)

##combine datasets together

data.total <- rbind(test.set, train.set)

## extract only the measurements on the mean and standard deviation

data.total <- data.total %>%
    select (id, label, subject, matches("\\.[Mm]ean\\.|\\.[Ss]td\\."))

data.total <- merge(
    x = data.total,
    y = activity.labels,
    by.x = "label",
    by.y = "label",
    all.x = TRUE
)

colnames(data.total) <- gsub("\\.+", "\\.", colnames(data.total)) ## removing unnecessary "."
colnames(data.total) <- gsub("\\.+$", "", colnames(data.total)) ## removing unnecessary "."

tidy.dataset <- data.total %>%
    group_by(subject, activity) %>%
    summarize_at(vars(tBodyAcc.mean.X:fBodyBodyGyroJerkMag.std), mean) %>%
    gather(type, average.value, tBodyAcc.mean.X:fBodyBodyGyroJerkMag.std) %>%
    mutate(
        variable = sapply(strsplit(type, "\\."), function(x){x[1]}),
        statistic = sapply(strsplit(type, "\\."), function(x){x[2]}),
        axis = sapply(strsplit(type, "\\."), function(x){x[3]})
        ) %>%
    select(subject, activity, variable, axis, statistic, average.value)

setwd(defaultwd)
