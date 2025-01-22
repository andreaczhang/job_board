# use data from google sheet
library(googlesheets4)

# gs4 authentication
# only need to do it once i think
# gs4_auth()

# local: to avoid the config evey time i use it
gs4_auth(path = '~/Documents/api/google_sheet.json')

# on GHA: 
# gs4_auth(path = Sys.getenv('NAME_OF_MY_SECRET'))


# after auth, try to read
link <- "https://docs.google.com/spreadsheets/d/1pdykU23HqTm2qv0pLw6uFuO5jHkdlRv1zpkyvETrcno/edit?gid=785448353#gid=785448353"
sheet <- "Open Positions"
mydata <- read_sheet(ss = link, sheet = sheet)


