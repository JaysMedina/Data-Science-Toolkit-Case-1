#BarangayDensity.R

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
