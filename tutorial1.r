# # Section 1 - Setting up
# setwd('~/Documents/mpini/github/graphicalweb2014_data')
# #load XLConnect
# library(XLConnect)
# # load sqldf library
# library(sqldf)
# 
# # INSTALLING PACKAGES
# # install.packages('XLConnect')
# # install.packages('sqldf')
# 
# # Section 2 - getting the data
# # A&E weekly activity statisticsThis is a dataset used to rate the performance of A&E departments
# 
# # first off with a CSV on local drive, we have seen this already
# ae_data1 <- read.csv('ane_weekly_sitrep_1.csv')
# 
# # Section 3:: Data understanding 
# sqldf('select * from ae_data1 limit 5')
# # r alternative
# # head(ae_data1, 5)
# 
# # lets remove none major A&E departments. 
# ae_data1 <- sqldf('select * from ae_data1 where admissions > 0')
# # r alternative
# ae_data1 <- ae_data1[ae_data1$admissions > 0,]
# 
# # loading dataset from a local excel file
# workbook <- loadWorkbook('ane_weekly_sitrep_2.xlsx')
# 
# # understanding loadWorkbook
# ?loadWorkbook
# 
# # examine sheets in the workbook
# getSheets(workbook)
# 
# # get data from worksheet
# ae_data2 <- readWorksheet(workbook, sheet='part 2')
# 
# # let us examine the contents of the object ae_data2 from the environment window
# View(ae_data2)
# 
# # let us remove none major A&E departments
# ae_data2 <- sqldf('select * from ae_data2 where admissions > 0')
# # r alternative
# # ae_data2 <- ae_data2[ae_data2$admissions > 0,]
# 
# # Section 5: Vertical joins
# # the columns should also have the same data type
# ae_complete <- sqldf('select * from ae_data1 
#                             union all 
#                        select * from ae_data2')
# # we now have a total of 144 major A&E departments which sounds about right
# # r alternative
# # ae_complete <- rbind(ae_data1, ae_data2)
# 
# # formatting is to aid readability
# ae_complete <- sqldf('select * from ae_data1 union all select * from ae_data2')
# 
# # to check the number of observation in our dataset is we could use 
# sqldf('select count(*) from ae_complete')
# # r equivalent
# # nrow(ae_complete)
# 
# # Horizontal joins
# # create a temporary file placeholder using R's tempfile() built-in function
# downloaded_file <- tempfile()
# 
# # download data using the download.file function specifying the curl method 
# # to understand the download.file() function just type ?download.file into your console
# ?download.file
# download.file("http://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2013/11/DailySR-Web-file-WE-26.03.14.xlsx",destfile=downloaded_file, method="curl")
# 
# # Let's load the contents of the file we downloaded and load it as a workbook 
# workbook <- loadWorkbook(downloaded_file)
# # again let's check what worksheets we have
# getSheets(workbook)
# # there is a load of worksheets in this particular file but we are interested in the one showing ambulances queuing
# ambulances_data <- readWorksheet(workbook, sheet='Ambulances queuing')
# 
# # let us examine the contents of the object february_data from the environment window
# # column headings are in row 14, data starts at row 17 all the way to row 173
# # let us only keep data in rows 17 to 173 and columns 1,3,4,5,6,7,8,9
# ambulances_data <- ambulances_data[17:173, c(1,3,5,6,7,8,9)]
# 
# # for now let us give our dataset meaningful column names
# colnames(ambulances_data) <- c('Area Team', 'Code', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday_Sunday')
# 
# # let us examine our dataset again
# sqldf('select * from ambulances_data limit 7')
# # r alternative
# head(ambulances_data, 7)
# 
# # we need to sum up the week's totals that's what we care.
# ambulance_queuing <- sqldf('SELECT Area_Team, Code, 
#                             (monday + tuesday + wednesday + thursday + friday_sunday) ambulances_queuing
#                            FROM ambulances_data')
# 
# # r equivalent
# ambulance_queuing$ambulances_queuing <- rowSums(ambulances_data[,3:7])
# 
# head(ambulances_data)
# 
# # sometimes you may not be able to do the computation you require due to how R would be storing your values
# # in order to use rowSums all columns need to be numeric
# class(ambulances_data$Monday)
# class(ambulances_data$Tuesday) # offending row
# class(ambulances_data$Wednesday)
# class(ambulances_data$Thursday)
# class(ambulances_data$Friday_Sunday)
# # 
# ambulances_data$Tuesday <- as.numeric(ambulances_data$Tuesday)
# ambulance_queuing$ambulances_queuing <- rowSums(ambulances_data[,3:7])
# 
# combined <- sqldf('SELECT area_team, name, a.code, attendance, seen_in_4hrs, admissions, ambulances_queuing 
#                   FROM ambulance_queuing a, ae_complete b 
#                   WHERE a.code = b.code')
# head(ambulance_queuing)
# # r equivalent
# combined <- merge(ambulance_queuing, ae_complete, by.x='Code', by.y='Code')
# 
# 
# # now lets see how many high frequency A&E's we have
# high_frequency <- sqldf('select * from ae_complete where attendance > 4000')
# # r equivalent
# high_frequency <- ae_complete[ae_complete$Attendance > 4000,]
# 
# # selecting certain columns
# high_frequency <- sqldf('select name, attendance from ae_complete where attendance > 4000')
# # r equivalent
# high_frequency <- ae_complete[ae_complete$Attendance > 4000, c('name', 'attendance')]
# 
# # sql query is case insensitive but dataframe name should match case
# high_frequency <- sqldf('select name, AttendaNce from ae_complete where attendance > 4000')
# 
# # to use r equivalence
# # rm(high_frequency)
# high_frequency <- ae_complete[ae_complete$Attendance > 4000, c('Name', 'Attendance')]
# 
# # Ordering results
# # using ambulances dataset
# head(ambulances_data)
# 
# # order by one variable
# sqldf('select code, monday, wednesday from ambulances_data order by monday')
# ambulances_data[order(ambulances_data$Monday), c('Code', 'Monday', 'Wednesday')]
# # this can also be written using the with() function
# # to tell R what dataset to use
# ambulances_data[with(ambulances_data, order(Monday)), c('Code', 'Monday', 'Wednesday')]
# 
# # order by multiple variables 
# sqldf('select code, monday, wednesday from ambulances_data order by monday, wednesday')
# # r alternative
# ambulances_data[with(ambulances_data, order(Monday, Wednesday)), c('Code', 'Monday', 'Wednesday')]
# 
# 
# write.csv(ae_complete, paste('datafordownload', 21, '.csv', sep=''))
# 
# head(ae_complete)
# summary(ae_complete)
# 
# # if we have time
# 
# # does the amount of people seen in 4hrs correlate with the total attendance?
# # plot seen in 4hrs vs attendance
# with(ae_complete, plot(Seen_in_4hrs, Attendance))
# # we got too many errors
# with(ae_complete, class(Attendance))
# # remember this is similar to
# class(ae_complete$Attendance)
# 
# with(ae_complete, class(Seen_in_4hrs))
# 
# # lets remove % symbols
# ae_complete$Seen_in_4hrs <- gsub('%', '', ae_complete$Seen_in_4hrs)
# # lets check out data
# head(ae_complete)
# # lets check the variable's class again
# with(ae_complete, class(Seen_in_4hrs))
# # lets turn it into a number
# ae_complete$Seen_in_4hrs <- as.numeric(ae_complete$Seen_in_4hrs)
# # lets check the variable's class again
# with(ae_complete, class(Seen_in_4hrs))
# 
# # variable is now numeric which means we can run our plot function now
# with(ae_complete, plot(Seen_in_4hrs, Attendance))
# with(ae_complete, cor.test(Seen_in_4hrs, Attendance))
# 
# #clean up environment
# rm(list=ls())
