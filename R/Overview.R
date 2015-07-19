#R script for overview

#Load packages
  library(dplyr)    # summarize data
  library(reshape2) # data manipulation
  library(sqldf)   # write sql queries in R
  library(stringr) # string operations (str_match)
  library(ggplot2) # Graphs
  library(scales)  # Format numbers in axes
  library(RColorBrewer)  # package containing color palettes
  myPalette <- brewer.pal(7,"Set2")

#Set working directories
  wd <- paste0(getwd(),"/")
  input <- paste0(wd, "Data/")
  output <- paste0(wd, "R Output/")
  
#Custom functions
  renameColumn <- function(df, oldName, newName){
    varnames <- names(df)
    varnames[varnames == oldName] <- newName
    names(df) <- varnames
    return(df)
  }

#Load data
  merged <- read.csv(paste0(input, "key_analysis_data_1700.csv"), stringsAsFactors=FALSE)
  merged$year <- as.numeric(substr(merged$registered,1,4))
  merged$month <- as.numeric(substr(merged$registered,6,7))
  merged$graphMonth <- as.Date(ISOdate(merged$year, merged$month, 1))
  head(merged$registered)
  nrow(merged)
  merged <- merged[which(merged$year >= 2004),]
  nrow(merged)

  #To search for fields by name use syntax below
  names(merged)[grep("org", names(merged))]
  
#Overview graphs  
#check group project years
  summaryProjectYear <- merged %>%
    group_by(year) %>%
    summarise(projects=n())
  summaryProjectYear$charity <- "key"
  sum(summaryProjectYear$projects)
  
  graphData <- summaryProjectYear
  ggplot(graphData, aes(x=factor(year), y=projects, color=charity, group=charity)) +
    geom_point() +
    geom_line(size=2) +
    scale_color_manual(values=myPalette) +
    scale_y_continuous(labels=comma_format()) +
    expand_limits(y = 0) +
    scale_x_discrete(name="") +
    theme(legend.position="none") +
    theme(text = element_text(size=15))

#trend in active organisations over time  
  prepOrgCount <- merged %>%
    group_by(year, organisation_id_o, organisation_name) %>%
    summarise(projects=n())    
  head(prepOrgCount)
  sum(prepOrgCount$projects)
  
  orgsYear <- prepOrgCount %>%
    group_by(year) %>%
    summarise(orgCount=length(unique(organisation_id_o)))
  orgsYear$charity <- "key"
  tail(orgsYear)
  
  graphData <- orgsYear
  ggplot(graphData, aes(x=factor(year), y=orgCount, color=charity, group=charity)) +
    geom_point() +
    geom_line(size=2) +
    scale_color_manual(values=myPalette[2]) +
    scale_y_continuous(name="organisations with active projects", labels=comma_format()) +
    expand_limits(y = 0) +
    scale_x_discrete(name="") +
    theme(legend.position="none") +
    theme(text = element_text(size=15)) 
  
  #Organisations and projects over time
  #head(summaryProjectYear)
  #head(orgsYear)
  summaryOrgsProjectYear <- sqldf("SELECT A.year, A.projects, B.orgCount as activeOrganisations
                                  FROM summaryProjectYear A
                                    INNER JOIN orgsYear B ON A.year = B.year")
  summaryOrgsProjectYear

  graphData <- melt(summaryOrgsProjectYear, c("year"))
  ggplot(graphData, aes(x=factor(year), y=value, group=variable, color=variable)) +
    geom_point() +
    geom_line(size=1) +
    scale_y_continuous(name="", labels=comma_format()) +
    scale_x_discrete(name="") +
    expand_limits(y = 0) +
    scale_color_manual(values=myPalette) +
    theme(text = element_text(size=15)) +
    theme(legend.title=element_blank()) +
    facet_wrap(~variable, scales="free", ncol=1)
  
  
  #seasonality - monthly projects
  #monthly projects registered
  monthProject <- merged %>% 
    group_by(year, month) %>%
    summarise(projects=n())
  
  graphData <- monthProject
  ggplot(graphData, aes(x=factor(month), y=projects, group=factor(year), color=factor(year))) +
    geom_point() +
    geom_line(size=1) +
    scale_x_discrete(name="month") +
    theme(legend.title=element_blank()) +
    theme(text = element_text(size=15))
  
#Focus on recent data to understand top projects and facilitators
  mergedRecent <- merged[which(merged$year >= 2014),]
  
  #Total number of organisations - 274
  length(unique(mergedRecent$OrganisationID))
  
  #Organisations - Rank by activity
  summaryOrgProject <- mergedRecent %>%
    group_by(organisation_id_o, organisation_name) %>%
    summarise(projects=n()) %>%
    arrange(-projects) 
  
  summaryOrgProject$rankProjects <- as.numeric(row.names(summaryOrgProject))
  summaryOrgProject$pctProjects <- summaryOrgProject$projects / sum(summaryOrgProject$projects) 
  summaryOrgProject$cumPctProjects <- cumsum(summaryOrgProject$pctProjects)
  summaryOrgProject$pctRank <- summaryOrgProject$rankProjects / max(summaryOrgProject$rankProjects)
  summaryOrgProject$charity <- "key"
  str(summaryOrgProject)
  
  head(summaryOrgProject)
  
  #Concentration - What % of projects do the top % of organisations account for?
  graphData <- summaryOrgProject
  ggplot(graphData, aes(x=pctRank, y=cumPctProjects, group=charity)) +
    geom_point() +
    scale_x_continuous(name="% organisations", labels=percent) +
    scale_y_continuous(name="% projects", labels=percent) +
    theme(text = element_text(size=15))
  
  
  #top 15 organisations
  graphData <- summaryOrgProject[which(summaryOrgProject$rankProjects <= 15),]
  graphData <- transform(graphData, label=reorder(organisation_name, -rankProjects))
  ggplot(graphData, aes(x=label, y=projects, fill=charity)) +
    geom_bar(stat="identity") +
    scale_fill_manual(values=myPalette[3]) +
    scale_x_discrete(name="") +
    theme(legend.position="none") +
    theme(text = element_text(size=15)) +
    coord_flip()
  
#Facilitators
  #projects per facilitator
  summaryFacilitator <- mergedRecent %>%
    group_by(contactid) %>%
    summarise(projects=n()) %>%
    arrange(-projects)
  head(summaryFacilitator)
  
  summaryFacilitator$rankProjects <- as.numeric(row.names(summaryFacilitator))
  summaryFacilitator$pctProjects <- summaryFacilitator$projects / sum(summaryFacilitator$projects)
  summaryFacilitator$cumPctProjects <- cumsum(summaryFacilitator$pctProjects)
  summaryFacilitator$pctFacilitator <- summaryFacilitator$rankProjects / nrow(summaryFacilitator)
  head(summaryFacilitator)
  
  graphData <- summaryFacilitator
  ggplot(graphData, aes(x=pctFacilitator, y=cumPctProjects)) +
    geom_point() +
    scale_x_continuous(name="% facilitators", labels=percent) +
    scale_y_continuous(name="% projects", labels=percent) +
    theme(text = element_text(size=15))
  
  ggplot(graphData, aes(x=summaryFacilitator$projects, y=..density..)) +
    geom_histogram(binwidth=1, color=grey) +
    scale_y_continuous(name="% facilitators", labels=percent) +
    scale_x_continuous(name="projects") +
    theme(text = element_text(size=15))
  
  #top facilitators vs top organisations
  
  # - What organisations do top facilitators work for?
  summaryFacilitatorProject <- mergedRecent %>%
      group_by(contactid, organisation_id_o, organisation_name) %>%
      summarise(projects=n())
  
  head(summaryFacilitatorProject)
  
  #merge with organisation rank
  head(summaryFacilitatorProject)
  head(summaryOrgProject)
  head(summaryFacilitator)
  quantile(summaryFacilitator$projects)
  quantile(summaryOrgProject$projects)
  
  facilitatorOrgRank <- sqldf("SELECT A.contactid, A.organisation_id_o, A.organisation_name, 
                                  A.projects,  B.rankProjects as rankProjectsOrg, 
                                  C.rankProjects as rankProjectsFacilitator
                              FROM summaryFacilitatorProject A
                                INNER JOIN summaryOrgProject B ON A.organisation_id_o = B.organisation_id_o 
                                INNER JOIN summaryFacilitator C ON A.contactid = C.contactid")

  head(facilitatorOrgRank)
  
  facilitatorOrgRank$pctFacilitator <- 1 - facilitatorOrgRank$rankProjectsFacilitator / max(facilitatorOrgRank$rankProjectsFacilitator)
  facilitatorOrgRank$pctOrg <- 1 - facilitatorOrgRank$rankProjectsOrg / max(facilitatorOrgRank$rankProjectsOrg)
  
  nrow(summaryFacilitatorProject)
  nrow(facilitatorOrgRank)
  sum(facilitatorOrgRank$projects)

  head(facilitatorOrgRank)
  graphData <- facilitatorOrgRank
  ggplot(graphData, aes(x=pctFacilitator, y=pctOrg, color=projects)) +
    geom_point() +
    scale_x_continuous(name="Facilitator Rank", labels=percent)  +
    scale_y_continuous(name="Organisation Rank", labels=percent) +
    theme(text = element_text(size=15)) +
    geom_abline(intercept = 0, slope = 1)

  
  head(facilitatorOrgRank)
  facilitatorOrgRank$absPerformanceDiff <- abs(facilitatorOrgRank$pctFacilitator - facilitatorOrgRank$pctOrg)
  facilitatorOrgRank$overPerform <- ifelse(facilitatorOrgRank$pctFacilitator > facilitatorOrgRank$pctOrg, "facilitator", "organisation")
  
  facilitatorOrgRank$overPerform <-""
  for(i in 1:nrow(facilitatorOrgRank)){
    if(facilitatorOrgRank$pctFacilitator[i] >= 0.75 & facilitatorOrgRank$pctOrg[i] >= 0.75){
      facilitatorOrgRank$overPerform[i] = "top facilitators and organisations"
    }else{
      if(facilitatorOrgRank$pctOrg[i] >= 0.75){
        facilitatorOrgRank$overPerform[i] = "above average organisations"
      } else if(facilitatorOrgRank$pctFacilitator[i] >= 0.75){
        facilitatorOrgRank$overPerform[i] = "above average facilitators"
      } else{
        facilitatorOrgRank$overPerform[i] = "other"
      }
    }
  }
  
  graphData <- facilitatorOrgRank
  ggplot(graphData, aes(x=pctFacilitator, y=pctOrg, color=overPerform)) +
    geom_point() +
    scale_x_continuous(name="Facilitator Rank", labels=percent)  +
    scale_y_continuous(name="Organisation Rank", labels=percent) +
    scale_color_manual(values=myPalette) +
    theme(text = element_text(size=15)) +
    theme(legend.title=element_blank()) +
    geom_abline(intercept = 0, slope = 1)
  
  
  #Distribution of projects per performance group
  sum(facilitatorOrgRank$projects)
  facilitatorOrgPerformance <- facilitatorOrgRank %>%
    group_by(overPerform) %>%
    summarise(projects=sum(projects),
              organisations=length(unique(organisation_id_o)),
              facilitators=length(unique(contactid))) %>%
    arrange(-projects)

  graphData <- facilitatorOrgPerformance[-which(facilitatorOrgPerformance$overPerform == "other"),]
  graphData <- transform(graphData, label=reorder(overPerform, projects))
  ggplot(graphData, aes(x=label, y=projects, fill=overPerform)) +
    geom_bar(stat="identity") +
    scale_fill_manual(values=myPalette) +
    scale_x_discrete(name="") +
    theme(text = element_text(size=15)) +
    theme(legend.position="none") +
    coord_flip()
  
  #Focus above average organisations
  
  topOrgs <- filter(facilitatorOrgRank, facilitatorOrgRank$overPerform %in% c("above average organisations", "top facilitators and organisations") ) %>%
      group_by(overPerform, organisation_id_o, organisation_name) %>%
      summarise(projects=sum(projects),
                facilitators=length(unique(contactid))) %>%
      arrange(-projects)
  topOrgs$avgProjectsPerFacilitator <- topOrgs$projects / topOrgs$facilitators
  topOrgs$rankProjects <- as.numeric(row.names(topOrgs))
  head(topOrgs)
  
  prep <- orgsOverPerform[which(orgsOverPerform$rankProjects <= 15),]
  prepLong <- melt(prep, c("rankProjects", "overPerform", "organisation_id_o", "organisation_name"))
  graphData <- prepLong
  graphData <- transform(graphData, label=reorder(organisation_name, -rankProjects))
  ggplot(graphData, aes(x=label, y=value, fill=variable)) +
    geom_bar(stat="identity") +
    coord_flip() +
    scale_x_discrete(name="") +
    scale_fill_manual(values=myPalette) +
    theme(text = element_text(size=15)) +
    theme(legend.position="none") +
    facet_wrap(~variable, ncol=1)

  
  