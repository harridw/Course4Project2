## Course4Project2  
#### Evaluating the change in fine particulate matter (PM2.5) between 1999 and 2008  
````r
The overall goal of this assignment is to explore the National Emissions Inventory  
database and see what it say about fine particulate matter pollution in the United  
states over the 10-year period 1999–2008. You may use any R package you want to  
support your analysis.
````

#### Questions (to be addressed by analysis)
````r
You must address the following questions and tasks in your exploratory analysis. For each question/task you  
will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.  

1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the  
   base plotting system, make a plot showing the total PM2.5 emission from all sources for each  
   of the years 1999, 2002, 2005, and 2008.
2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶")  
   from 1999 to 2008? Use the base plotting system to make a plot answering this question.
3. Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable,  
   which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?  
   Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a  
   plot answer this question.
4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources  
   in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which city has seen greater changes over time in motor  
   vehicle emissions?
````


#### Two data files have been provided for this review / analysis
````r
1. PM2.5 Emissions Data (𝚜𝚞𝚖𝚖𝚊𝚛𝚢𝚂𝙲𝙲_𝙿𝙼𝟸𝟻.𝚛𝚍𝚜): This file contains a data frame with all  
   of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains  
   number of tons of PM2.5 emitted from a specific type of source for the entire year.  
2. Source Classification Code Table (𝚂𝚘𝚞𝚛𝚌𝚎_𝙲𝚕𝚊𝚜𝚜𝚒𝚏𝚒𝚌𝚊𝚝𝚒𝚘𝚗_𝙲𝚘𝚍𝚎.𝚛𝚍𝚜): This table provides a mapping  
   from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources  
   are categorized in a few different ways from more general to more specific and you may choose to explore  
   whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric  
   Gen /Anthracite Coal /Pulverized Coal”.
````

#### summarySCC_PM25.rds contains the following data / variables:
````r
1. 𝚏𝚒𝚙𝚜: A five-digit number (represented as a string) indicating the U.S. county
2. 𝚂𝙲𝙲: The name of the source as indicated by a digit string (see source code classification table)
3. 𝙿𝚘𝚕𝚕𝚞𝚝𝚊𝚗𝚝: A string indicating the pollutant
4. 𝙴𝚖𝚒𝚜𝚜𝚒𝚘𝚗𝚜: Amount of PM2.5 emitted, in tons
5. 𝚝𝚢𝚙𝚎: The type of source (point, non-point, on-road, or non-road)
6. 𝚢𝚎𝚊𝚛: The year of emissions recorded
````

#### Each of the 6 questions is reviewed / answered separately.  Below are steps followed for each question.  
 * Define question -- as written in assignment  
 * Data Exploration, including assumptions used / considered  
 * Answer to question based on data / plots  

#### Question 1:  
````
Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?  Using the base  
plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years  
1999, 2002, 2005, and 2008.  
````

##### Data Exploration  
````
Assumptions:
* Total emissions implies that there is no split for SCC, Type, or fips  
* A 'mean' emission represents the best approach to measuring change in emissions over time
````

##### Review the data (same process applied for each question)
````  
There are two activities that are performed prior to evaluating the data.  The first activity is  
loading 'packages' to be used in the exploration of the data, including plots of the data.  The  
second activity is reading the files into R.  

NOTE:  It is assumed these files are loaded in working directory, not in zip folder.  
````

###### Install the packages  
````  
The ipak function below checks to see if packages are installed.  If not, those packages are  
installed first using install.packages() function. 

ipak <- function(pkg){
      new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
      if (length(new.pkg)) 
            install.packages(new.pkg, dependencies = TRUE)
      sapply(pkg, require, character.only = TRUE)
}

This represents list of the desired package, then calls the ipak function
   packages <- c("ggplot2", "plyr", "dplyr", "data.table", "dtplyr", "reshape2", "RColorBrewer",  
                                                                                 "scales", "grid")
   ipak(packages)
````

##### Read data files into R  
````  
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
````  

##### Evaluate the data  
````
For this question, we need to calculate the mean Emissions for each year.  As stated in assumptions,  
the calculation will not recognize splits for SCC, type, or fips.  The aggregate() function, outlined  
below, calculates the mean of Emissions by year (Emissions ~ year).  

meanNEIyear <- aggregate(Emissions ~ year, data = NEI, FUN = function(x) mean=mean(x))  
````

##### Plot data (using base plotting system)  
##### Before plotting data, a few values are defined to be used by plot() function -- value ranges for x and y
````
min.year <- round(min(meanNEIyear$year),0)-1
max.year <- round(max(meanNEIyear$year),0)+1

min.Emissions <- round(min(meanNEIyear$Emissions),0)-1
max.Emissions <- round(max(meanNEIyear$Emissions),0)

xrange <- range(seq(from = min.year, to = max.year, by = 1))
yrange <- range(seq(from = min.Emissions, to = max.Emissions, by = 1))


Use data in meanNEIyear and defined value ranges to plot to screen
   with(meanNEIyear, {
         plot(year, Emissions, pch = 19, xlim = xrange, ylim = yrange,
                          xlab = "Measurment Year", ylab = "Average Emissions")
         lines(year, Emissions, type = "l", lty = 1, lwd = 1, col = "black")
   })


Copy line graph plot of two variables, mean Emissions by Measurement Year, to PNG file
   dev.copy(png, file = "Plot1.png")
   dev.off()   ## Close device, png is this case, so file can be viewed
````

##### Question 1: Answer  
````
The mean Emission shows a considerable decrease from 1999 - 2008.  A decrease is observed for each  
of the reported years: 1999, 2002, 2005, 2008.  The greatest decrease occurs between 1999 and 2002.  
The small decrease occurs between 2002 and 2005.
````


#### Question 2:  
````
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶")  
from 1999 to 2008? Use the base plotting system to make a plot answering this question.  
````

##### Data Exploration  
````
Assumptions:
* Total emissions implies that there is no split for SCC, Type, or fips  
* Results are developed / reported for a single market, Baltimore City (fips == "24510")
* A 'mean' emission represents the best approach to measuring change in emissions over time
````

##### Review the data (same process applied for each question)
````  
There are two activities that are performed prior to evaluating the data.  The first activity is  
loading 'packages' to be used in the exploration of the data, including plots of the data.  The  
second activity is reading the files into R.  

NOTE:  It is assumed these files are loaded in working directory, not in zip folder.  
````

###### Install the packages  
````  
The ipak function below checks to see if packages are installed.  If not, those packages are  
installed first using install.packages() function. 

ipak <- function(pkg){
      new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
      if (length(new.pkg)) 
            install.packages(new.pkg, dependencies = TRUE)
      sapply(pkg, require, character.only = TRUE)
}

This represents list of the desired package, then calls the ipak function
   packages <- c("ggplot2", "plyr", "dplyr", "data.table", "dtplyr", "reshape2", "RColorBrewer",  
                                                                                 "scales", "grid")
   ipak(packages)
````

##### Read data files into R  
````  
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
````  

##### Evaluate the data  
````
For this question, we need to calculate the mean Emissions for each year.  As stated in assumptions,  
the calculation will not recognize splits for SCC, type, or fips.  However, we will first subset 
the NEI data for Baltimore City only, NEIsub.  Then, the aggregate() function is used, outlined below,   
to calculate the mean of Emissions by year (Emissions ~ year).  

NEIsub <- subset(NEI, fips == "24510")
meanNEIyear <- aggregate(Emissions ~ year, data = NEIsub, FUN = function(x) mean=mean(x))  
````

##### Plot data (using base plot function)  
##### Before plotting data, a few values are defined to be used by plot() function -- value ranges for x and y
````
min.year <- round(min(meanNEIyear$year),0)-1
max.year <- round(max(meanNEIyear$year),0)+1

min.Emissions <- round(min(meanNEIyear$Emissions),0)-1
max.Emissions <- round(max(meanNEIyear$Emissions),0)

xrange <- range(seq(from = min.year, to = max.year, by = 1))
yrange <- range(seq(from = min.Emissions, to = max.Emissions, by = 1))


Use data in meanNEIyear and defined value ranges to plot to screen
   with(meanNEIyear, {
         plot(year, Emissions, pch = 19, xlim = xrange, ylim = yrange,
                          xlab = "Measurment Year", ylab = "Average Emissions")
         lines(year, Emissions, type = "l", lty = 1, lwd = 1, col = "black")
   })

Copy line graph plot of two variables, mean Emissions by Measurement Year, to PNG file
   dev.copy(png, file = "Plot2.png")
   dev.off()   ## Close device, png is this case, so file can be viewed
````

##### Question 2: Answer  
````
The mean Emission shows a considerable decrease from 1999 - 2008.  A decrease is not observed between    
2002 and 2005, but is for other periods.  The greatest decrease occurs between 1999 and 2002.  
````


#### Question 3:  
````
Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable,  
which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?  
Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a  
plot answer this question.  
````

##### Data Exploration  
````
Assumptions:
* We are looking for change in Emissions by type of source in Baltimore City (fips == "24510") 
* Requires calculating mean for each year & type of source (point, nonpoint, onroad, nonroad)
* A 'mean' emission represents the best approach to measuring change in emissions over time
````

##### Review the data (same process applied for each question)
````  
There are two activities that are performed prior to evaluating the data.  The first activity is  
loading 'packages' to be used in the exploration of the data, including plots of the data.  The  
second activity is reading the files into R.  

NOTE:  It is assumed these files are loaded in working directory, not in zip folder.  
````

###### Install the packages  
````  
The ipak function below checks to see if packages are installed.  If not, those packages are  
installed first using install.packages() function. 

ipak <- function(pkg){
      new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
      if (length(new.pkg)) 
            install.packages(new.pkg, dependencies = TRUE)
      sapply(pkg, require, character.only = TRUE)
}

This represents list of the desired package, then calls the ipak function
   packages <- c("ggplot2", "plyr", "dplyr", "data.table", "dtplyr", "reshape2", "RColorBrewer",  
                                                                                 "scales", "grid")
   ipak(packages)
````

##### Read data files into R  
````  
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
````  

##### Evaluate the data  
````
For this question, we need to calculate the mean Emissions for each year.  In this evaluation step,    
we need to calculate the mean Emissions for each year and type of source.  The aggregate() function  
has been modifified, outlined below, to calculate the mean of Emissions by year and type of source  
as follows (Emissions ~ year + type).  

NEIsub <- subset(NEI, fips == "24510")
meanNEIyear <- aggregate(Emissions ~ year + type, data = NEIsub, FUN = function(x) mean=mean(x))  
````

##### Plot data (using ggplot2 plotting function)  
````
Use data in meanNEIyear and defined value ranges to plot to screen. This creates a single graph  
with trend lines for each "type" of source using different colors (defaults used).
   qplot(year, Emissions, data = meanNEIyear, color = type, geom = c("point", "smooth"))

Copy line graph plot of two variables, mean Emissions by Measurement Year, to PNG file
   dev.copy(png, file = "Plot3.png")
   dev.off()   ## Close device, png is this case, so file can be viewed
````

##### Question 3: Answer  
````
The 'nonpoint' type of source shows the greatest decrease in mean Emissions from 1999 - 2008.  
This is followed 'point', 'non-road', and 'on-road', respectively.
````



#### Question 4:  
````
Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
````

##### Data Exploration  
````
Assumptions:
* We are looking for change in Emissions by year for combustion-related sources using coal 
* This requires that we can identify these specific SCC as provided in SCC file.
* We will calculate mean Emission by year for subset of NEI data reflecting applicable SCC
* A 'mean' emission represents the best approach to measuring change in emissions over time
````

##### Review the data (same process applied for each question)
````  
There are two activities that are performed prior to evaluating the data.  The first activity is  
loading 'packages' to be used in the exploration of the data, including plots of the data.  The  
second activity is reading the files into R.  

NOTE:  It is assumed these files are loaded in working directory, not in zip folder.  
````

###### Install the packages  
````  
The ipak function below checks to see if packages are installed.  If not, those packages are  
installed first using install.packages() function. 

ipak <- function(pkg){
      new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
      if (length(new.pkg)) 
            install.packages(new.pkg, dependencies = TRUE)
      sapply(pkg, require, character.only = TRUE)
}

This represents list of the desired package, then calls the ipak function
   packages <- c("ggplot2", "plyr", "dplyr", "data.table", "dtplyr", "reshape2", "RColorBrewer",  
                                                                                 "scales", "grid")
   ipak(packages)
````

##### Read data files into R  
````  
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
````  

##### Evaluate the data  
````
For this question, we need to calculate the mean Emissions for each year.  In this evaluation step,    
we need to calculate the mean Emissions for each year where combustion-related sources use coal.  
The aggregate() function, outlined below, is used to calculate the mean of Emissions by year.  
as follows (Emissions ~ year + type).  A first step is to identify appropriate SCC in SCC file
to create a subset of NEI data connected to the 

Identify all combustion-related sources that use coal (applicable SCC).  We apply 2 criteria to  
identify SCC: 1) SCC.Level.One contains "Combustion" & 2) SCC.Level.Four contains "Coal"
   subSCC <- filter(SCC,grepl("Combustion", SCC$SCC.Level.One, ignore.case = TRUE, fixed = TRUE) &
                                 grepl("Coal", SCC$SCC.Level.Four, ignore.case = TRUE, fixed = TRUE))
   subSCC <- select(subSCC, SCC, EI.Sector, SCC.Level.One, SCC.Level.Three, SCC.Level.Four, Short.Name)

Subset NEI dataset for applicable SCC identified in subSCC
  NEIsub <- subset(NEI, SCC %in% unique(subSCC$SCC))
  NEIsub <- select(NEIsub, SCC, fips, year, type, Pollutant, Emissions)

Evaluate NEI subset for duplicate rows
   dupsNEIsub <- NEIsub[duplicated(NEIsub),]     ## 87 duplicate rows identified
   NEIsub <- unique(NEIsub)                      ## removes duplicate rows from NEI subset

Include SCC labels / description for NEI subset data  [left join to NEIsub dataset]
   mrgNEIsub <- merge(NEIsub[,1:6], subSCC[,1:6], by = 1, all.NEIsub = TRUE)

Calculate the mean Emissions by year for qualifying SCC codes(Combustion-related sources that use coal)
   meanNEIyear <- aggregate(Emissions ~ year, data = mrgNEIsub, FUN = function(x) mean=mean(x))  
````

##### Plot data (using ggplot2 plotting function)  
````
Use data in meanNEIyear
   qplot(year, Emissions, data = meanNEIyear, geom = c("point", "smooth"),
      main = "Average Emissions for Coal Combustion-related Sources", xlab = "Measurement Year",
      ylab = "Average Emissions")

Copy line graph plot of two variables, mean Emissions by Measurement Year, to PNG file
   dev.copy(png, file = "Plot4.png")
   dev.off()   ## Close device, png is this case, so file can be viewed
````

##### Question 4: Answer  
````
A decrease in mean Emissions from combustion-related sources using coal has been observed for period  
from 1999 - 2008.  A vast majority of this decrease occurs between Measurment Years 2005 - 2008.  
To provide a little more insight to the change in Emissions, we can plot the mean Emission for year  
and SCC.Level.Three combinations.  Below is code to produce plot:

meanNEIdtl1 <- aggregate(Emissions ~ year + SCC.Level.Three, data = mrgNEIsub, FUN = function(x) mean=mean(x))  

Add attribute color = SCC.Level.Three to identify data uniquely for each SCC.Level.Three
   qplot(year, Emissions, data = meanNEIdtl1, color = SCC.Level.Three, geom = c("point", "smooth"),
         main = "Average Emissions for Coal Combustion-related Sources", xlab = "Measurement Year",
         ylab = "Average Emissions")

Copy line graph plot of three variables to PNG file
   dev.copy(png, file = "Plot4b.png")
   dev.off()   ## Close device, png is this case, so file can be viewed
````














