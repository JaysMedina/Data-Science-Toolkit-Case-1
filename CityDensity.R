#4
library(plyr)
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

write.csv(regCity %>%
            arrange(desc(density)) %>%
            group_by(Region) %>% slice(1:5),'citypopdensity.csv')

regCity %>%
  arrange(desc(density)) %>% #arranges values based on announced factor 'density'
  group_by(Region) %>% slice(1:5) #takes first 5 values