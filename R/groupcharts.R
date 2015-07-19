library(data.table)
library(ggplot2)
library(plyr)

projects <- read.csv('key_analysis_data_1700.csv')
projects <- data.table(projects)

#A chart that shows a distribution of groups by the number of projects they do

chart1 <- projects[, .N, by=.(groupid,organisation_id_o)]

ggplot(chart1,aes(N))+
  geom_bar(binwidth=.5,fill="navy")+
  ggtitle("Distribution of Groups by Number of Projects")+
  xlab("Number of Projects Started by Group")+
  ylab("Number of Groups")+
  theme(panel.background = element_blank())+
  coord_cartesian(xlim = c(1, 5)) 


#Making a second chart
#Calculating the average projects per group of each organisation
average <- projects[, .(length(unique(groupid)),length(unique(groupprojectid))), by=organisation_id_o]
average <- average[,avg := V2/V1, ]
average <- average[order(-avg), ]
average <- average[,rank := as.numeric(row.names(average)), ]
toporgs <- average[rank <21, ]

ggplot(average,aes(rank,avg))+
  geom_point(colour="navy",size=3,alpha=1/10)+
  ggtitle("Organisations: Average Projects Per Group")+
  xlab("Organisation")+
  ylab("Average Projects per Group")+
  theme(panel.background = element_blank())

#breakdown of projects by status by registration year

projects[ ,regyear:= year(registered)]
projects$stage <- as.factor(projects$stage)
statusyear <- projects[ ,.N,by=.(stage,regyear)]
statusyear <- statusyear[regyear>2003, ]
statusyear <- statusyear[order(regyear,stage), ]
statusyear$stage <- revalue(statusyear$stage, c("0"="created","1"="submitted","2"="validated","3"="panel in progress","7"="query","6"="granted","8"="lapsed","9"="completed","10"="rejected"))


ggplot(statusyear,aes(x = regyear, y = N, fill = stage))+
  geom_bar(position="stack",stat="identity")+
  ggtitle("Projects by Registration Year and Current Stage")+
  xlab("Project Registration Year")+
  ylab("Number of Projects")+
  theme(panel.background = element_blank())
