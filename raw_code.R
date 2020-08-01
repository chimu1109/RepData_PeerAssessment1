## Loading libraries
library(readr)
library(plyr)
library(dplyr)
library(Hmisc)

## Reading the data
activity <- read_csv("activity.zip")

## Sorting the dataset
a1 <- tapply(activity$steps, activity$date, sum, na.rm = TRUE)
a2 <- tapply(activity$steps, activity$interval, mean, na.rm = TRUE)

## Part 1
hist(a1)
mean(a1)
median(a1)

## Part 2
plot(a2, type = "l", lwd = 2)
which.max(a2)

## Part 3
sum(is.na(activity$steps))
activity2 <- activity %>%
group_by(interval) %>%
mutate_each(funs(replace(., which(is.na(.)), mean(., na.rm=TRUE))),
+                   starts_with('steps'))

a3 <- tapply(activity2$steps, activity2$date, sum, na.rm = TRUE)
hist(a3)
mean(a3)
median(a3)

## Part 4
weekday1 <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
activity2 <- mutate(activity2, holiday = factor((weekdays(date) %in% weekday1), 
                                                levels=c(FALSE, TRUE), labels=c('weekend', 'weekday') ))

act2 <- group_by(activity2, holiday, interval) %>% summarise(steps = mean(steps))
ggplot(na.omit(act2), aes(x = interval, y = steps)) + geom_line(lwd=1.2) + facet_wrap(.~holiday, nrow = 2)



