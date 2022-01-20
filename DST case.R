#1 Data Scientist Toolbox case

#3

pop = read.csv("population.csv", stringsAsFactors = TRUE)
reg = read.csv("regionarea.csv", stringsAsFactors = TRUE)

library(plyr)
#counts frequency of regions in population.csv
freq = count(pop,Region)

#attaches average land area per barangay to regional data
reg$average = reg$Area/freq$n

#outerjoin region and pop data
pop = merge(x=pop,y=reg,by=c("Region"), all= TRUE)

#computes for per brgy density
pop$density = pop$Population/pop$average

write.csv(top_n(pop,5,density),'brgypopdensity.csv')

#4
library(dplyr)

#sums up each city's population
citySum = aggregate(pop$Population,by=list(pop$CityProvince,pop$Region),FUN=sum)

#summarizes and merges duplicate pairs
regCity = pop %>% 
  filter(complete.cases(.) & !duplicated(.)) %>% 
  group_by(Region, CityProvince) %>% 
  summarize(count = n())

#counts cities per region
cityCount = count(regCity,Region)

#computes for average city land per region
reg$cityLand = reg$Area/cityCount$n

#pass city population info
regCity$cityPop = citySum$x

#outer join for city land
regCity = merge(x=regCity,y=reg,by=c("Region"), all= TRUE)
regCity$density = regCity$cityPop/regCity$cityLand

write.csv(top_n(regCity,5,density),'citypopdensity.csv')


