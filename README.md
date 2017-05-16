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
* Question -- as written in assignment  
* Data Exploration, including assumptions used / considered  
* Answer to question based on data / plots  

##### **Question 1:**  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?  
#####      Using the base plotting system, make a plot showing the total PM2.5 emission from all sources  
#####      for each of the years 1999, 2002, 2005, and 2008.  
````
**Data Exploration**  
Assumptions:
* Total emissions implies that there is no split for SCC, Type, or fips  
* A 'mean' emission represents the best approach to measuring change in emissions over time



