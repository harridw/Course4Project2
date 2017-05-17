#  Coursera: Data Science Specialization: Course 4 - Exploratory Data Analysis
#  Peer-graded Assignment:  Course 4 Project 2  [Course4Project2]
#  
#  Assignment Requirements / Guidelines:
#  Source data is text file 'household_power_consumption.txt' in working directory
#
#  NOTE: (per instructions in section 'Loading the data')
#  We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to read
#  the data from just those dates rather than reading in the entire dataset and subsetting to those
#  dates.
#
#  Review Criteria
#    For each question
#    1. Does the plot appear to address the question being asked?
#    2. Is the submitted R code appropriate for construction of the submitted plot?
#
#  Assignment
#  The overall goal of this assignment is to explore the National Emissions Inventory database and
#  see what it say about fine particulate matter pollution in the United states over the 10-year 
#  period 1999–2008. You may use any R package you want to support your analysis.
#
#  Questions
#  You must address the following questions and tasks in your exploratory analysis. For each 
#  question/task you will need to make a single plot. Unless specified, you can use any plotting 
#  system in R to make your plot.
#
#  1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the 
#     base plotting system, make a plot showing the total PM2.5 emission from all sources for each 
#     of the years 1999, 2002, 2005, and 2008.
#  2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
#     from 1999 to 2008? Use the base plotting system to make a plot answering this question.
#  3. Of four types of sources indicated by 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable
#     which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore
#     City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to
#     make a plot answer this question.
#  4. Across the United States, how have emissions from coal combustion-related sources changed
#     from 1999–2008?
#  5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
#  6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor
#     vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which city
#     has seen greater changes over time in motor vehicle emissions?
#
#  setwd("/Users/harridw/Development/Coursera/Course4/Course4Project2")  ## Defines my working directory

#  Install packages anticipated to support Course 4 Programming Assignment
#     ipak function: install and load multiple R packages.
#     check to see if packages are installed. Install them if they are not, then load them into the R session.
ipak <- function(pkg){
      new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
      if (length(new.pkg)) 
            install.packages(new.pkg, dependencies = TRUE)
      sapply(pkg, require, character.only = TRUE)
}

# usage
packages <- c("ggplot2", "plyr", "dplyr", "data.table", "dtplyr", "reshape2", "RColorBrewer", "scales", "grid")
ipak(packages)

#  Read data into R  [assumes files are in working directory]
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#  To gather perspective of file size for both NEI & SCC
#  dim(NEI)
#  [1] 6497651       6

# dim(SCC)
#  [1] 11717    15


#  QUESTION 5: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City (fips == "24510")?

#  Identify all SCC for motor vehicle sources --> using SCC.Level.One == "Mobile Sources" to define category
subSCC <- filter(SCC,grepl("Mobile Sources", SCC$SCC.Level.One, ignore.case = TRUE, fixed = TRUE))
subSCC <- select(subSCC, SCC, EI.Sector, SCC.Level.One, SCC.Level.Three, SCC.Level.Four, Short.Name)

#  Provide relative size of SCC where "Coal" is used in combustion-related source
#  dim(subSCC)
#  [1] 1787  6

#  Confirm number of unique SCC values in subSCC --> each row contains unique SCC value
#  length(unique(subSCC$SCC))
#  [1] 1787


#  Create subset of NEI data for motor vehicle sources defined in subSCC & Baltimore City (fips == "24510")
NEIsub <- subset(NEI, SCC %in% unique(subSCC$SCC) & fips == "24510")
NEIsub <- select(NEIsub, SCC, fips, year, type, Pollutant, Emissions)
#  dim(NEIsub)
#  [1] 1569    6      ## 1,569 rows of total 6,497,651 include one of defined SCC in Baltimore City (fips == "24510")


#  Check for unique records reflected in NEIsub dataset
dupsNEIsub <- NEIsub[duplicated(NEIsub),]
#  dim(dupsNEIsub)
#  [1] 18  6         # 18 rows are duplicate to other rows in NEIsub dataset


NEIsub <- unique(NEIsub)        ## include unique rows  [1,569 - 18 = 1,551 rows]
#  dim(NEIsub)
#  [1] 1551    6                ## validates that 18 duplicate rows have been removed


#  Include SCC labels / description for NEI subset data  [left join to NEIsub dataset]
mrgNEIsub <- merge(NEIsub[,1:6], subSCC[,1:6], by = 1, all.NEIsub = TRUE)


#  Calculate the mean Emissions by year for qualifying SCC codes (Coal combustion-related sources)
meanNEIyear <- aggregate(Emissions ~ year, data = mrgNEIsub, FUN = function(x) mean=mean(x))

#  Plot to screen -- answers question, but affords limited detail to understand / explain change
qplot(year, Emissions, data = meanNEIyear, geom = c("point", "smooth"),
      main = "Avg Emissions in Baltimore City from Motor Vehicle Sources", xlab = "Measurement Year",
      ylab = "Average Emissions")

#  Copy line graph plot of three variables to PNG file
dev.copy(png, file = "Plot5.png")
dev.off()   ## Close device, png is this case, so file can be viewed


#  If we wish to better understand emission levels for coal, combustion-related sources, data should be evaluated
#  at a more granular level --> possibly:  1) SCC.Level.Three, 2) SCC.Level.Three + fips.  Caution should be used
#  in determing the level of granularity to ensure it is meaningful and helpful to guiding further analysis & findings
#  Below, plots for the two alternative levels of granularity are provided.

#  Calculate the mean Emissions by year for qualifying SCC codes for varying levels of detail
meanNEIdtl1 <- aggregate(Emissions ~ year + SCC.Level.Three, data = mrgNEIsub, FUN = function(x) mean=mean(x))


#  Plot to screen -- includes added granularity for SCC.Level.Three
#  Due to number of difference SCC.Level.Three an alternative plot may be more helpful
#  However, it can be observed that SCC.Level.Three = "All Paved Roads is primary driver of change
qplot(year, Emissions, data = meanNEIdtl1, color = SCC.Level.Three, geom = c("point", "smooth"),
      main = "Avg Emissions in Baltimore City from Motor Vehicle Sources", xlab = "Measurement Year",
      ylab = "Average Emissions")

#  Copy line graph plot of three variables to PNG file
dev.copy(png, file = "Plot5b.png")
dev.off()   ## Close device, png is this case, so file can be viewed



