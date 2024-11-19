# explore the data

library(readxl)
library(data.table)
library(ggplot2)
library(lubridate)


# load data
job_statistics <- read_excel("data/job_statistics.xlsx")

js <- data.table(job_statistics)


colnames(js)
js

# can filter out the ones with outcome already 
js[, final_outcome]
js[!is.na(final_outcome)]




n_apply <- nrow(js)
n_apply

# interested in the following:

# any response (incl. auto)
n_any_response <- js[response == 'yes'] |> nrow()
round(n_any_response / n_apply, 3)





# OVERALL SUMMARY ----
# success rate of having any interview ----

js[, interview_any]
n_any_interview <- js[interview_any == 'yes'] |> nrow()
round(n_any_interview / n_apply, 3)





# final round interview ----

# success rate of having any final rounds
# this is the interview that's right before offer

# over all, and over those with any interview 

n_finalround_interview <- js[interview_finalround == 'yes'] |> nrow()


round(n_finalround_interview / n_any_interview, 3)





# __________ ----
# Time series ----
# install.packages('tidyverse')
# need to convert to weekly

# create a master table, ordered by time 



n_weeks <- function(year){
  # year <- 2024
  n <- lubridate::isoweek(as.Date(paste0(year, '-12-31')))
  if(n == 1){
    n <- lubridate::isoweek(as.Date(paste0(year, '-12-28')))
  }
  return(n)
}

# sapply(2019:2026, function(x){n_weeks(x)})

lubridate::today()
lubridate::isoweek()

date_start <- min(js$application_date)
date_end <- today()

# weekdays(lubridate::today())
# floor_date(lubridate::today(), 'week', week_start = 1)
# as.Date(paste('2024', '02', 1, sep = '-'), '%Y-%W-%w')



# get the monday of the starting date
monday_date_start <- floor_date(date_start, 'week', week_start = 1)


week_sequence <- data.table(
  monday_date = seq(from = ymd(monday_date_start), 
                    to = ymd(date_end+7), 
                    by = '1 week'), 
  key = 'monday_date')


# need to attach the monday dates on the orignal data too 

lubridate::isoweek(js$application_date)
lubridate::isoyear(js$application_date)

jsc <- copy(js)
jsc <- jsc[, .(sector, application_date)]
# jsc[, application_date_week := isoweek(application_date)]
# jsc[, application_date_year := isoyear(application_date)]


jsc[, monday_date := floor_date(application_date, 'week', week_start = 1)]
jsc[, monday_date := as.Date(monday_date)]

# weekly applications 

n_weekly_app <- jsc[, .N, by = .(monday_date)]
setkey(n_weekly_app, 'monday_date')

class(n_weekly_app$monday_date) # need to match!
class(week_sequence$monday_date)


n_weekly_app <- merge(week_sequence, n_weekly_app, all = T) 

# library(dplyr)
# left_join(week_sequence, n_weekly_app)





?merge.data.table
# line plot ----#

# p <- ggplot(n_weekly_app, 
#        aes(x = as.Date(paste(application_date_year, 
#                              application_date_week, 1, sep = '-'), 
#                        "%Y-%W-%w"), 
#            y = N) 
# )
# p <- p + geom_point()
# p <- p + geom_line()
# p <- p + scale_x_date(date_breaks = 'week',
#                       date_labels = '%Y-%W', 
#                       name = 'year-week')
# p

# bar plot ----# 
p <- ggplot(n_weekly_app, 
            aes(x = monday_date, y = N))
p <- p + geom_bar(stat = 'identity')
p <- p + scale_x_date(date_breaks = 'week',
                      date_labels = '%Y-%W', 
                      name = 'year-week')


p





# application by sector ----
# stratified bar plot


n_weekly_bysec <- jsc[, .N, by = .(monday_date, sector)]

p <- ggplot(n_weekly_bysec, 
            aes(x = monday_date, y = N, fill = sector))
p <- p + geom_bar(stat = 'identity')
p <- p + scale_x_date(date_breaks = 'week',
                      date_labels = '%Y-%W', 
                      name = 'year-week')
p <- p + scale_y_continuous(expand = c(0, 0), limits = c(0, 12))
p <- p + scale_fill_brewer(palette = 'Set1')
p <- p + theme_classic()
p <- p + theme(
  axis.text = element_text(size = 12),
  axis.title = element_text(size = 12), 
  plot.title = element_text(size = 15), 
  axis.text.x = element_text(angle = 45, vjust = 0.4, hjust = 0.4), 
  axis.title.x = element_blank()
)
p <- p + labs(
  x = 'Year - Week', 
  y = 'Number of applications', 
  title = 'Weekly application by sector'
)
p






