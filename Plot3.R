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


#  Read data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#  QUESTION 3: Of four types of sources indicated by 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable
#     which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore
#     City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to
#     make a plot answer this question.

#  Subset NEI data to Baltimore City, Maryland (fips == "24510")
NEIsub <- subset(NEI, fips == "24510")

#  Calculate the mean Emissions by year
meanNEIyear <- aggregate(Emissions ~ year + type, data = NEIsub, FUN = function(x) mean=mean(x))


#  Plot option 1:  This creates a single graph with trend lines for each "type" using different color
qplot(year, Emissions, data = meanNEIyear, color = type, geom = c("point", "smooth"))

#  Plot option 2:  This creates 4 plots, one for each type
#  Because each "type" has very different ranges.  It may offer a "cleaner" look at trends for a type
# qplot(year, Emissions, data = meanNEIyear, facets = . ~ type, geom = c("point", "smooth"))

#  Copy line graph plot of three variables to PNG file
dev.copy(png, file = "Plot3.png")
dev.off()   ## Close device, png is this case, so file can be viewed



