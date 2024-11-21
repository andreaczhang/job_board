library(tidyverse)
library(googlesheets4)

# The data is publicly available so we don't need to authenticate
# gs4_deauth()
# survey_data <- read_sheet("https://docs.google.com/spreadsheets/d/13kfPtyQP1xmL4Rn6rfJHgJcAblfH7pxS5RvdmGe6BHg/edit?usp=sharing")

# survey_data %>%
#   write_rds("survey_data.rds")

gs4_auth(path = Sys.getenv('GOOGLE_PAT')) # the name has to match
# then modify the workflow as well

# after auth, try to read
link <- "https://docs.google.com/spreadsheets/d/1pdykU23HqTm2qv0pLw6uFuO5jHkdlRv1zpkyvETrcno/edit?gid=785448353#gid=785448353"
sheet <- "Open Positions"
mydata <- read_sheet(ss = link, sheet = sheet)

mydata %>%
  write_rds("mydata.rds")
