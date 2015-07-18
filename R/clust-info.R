#
# clust-info.R, 17 Jul 15

library("plyr")

# The data after merging by the wonderful SQL scripts
proj_all=read.csv("the-key/proj-all-info.csv")

# The output from the awk script
# group_str,organisationc_id
# org_clust=read.csv("the-key/clust-org.csv")
org_clust=read.csv("the-key/bi-clust-org.csv")


# Return potfundamount totals and number of applications
# for all organisations sharing the same bi-grams in their name
get_mean=function(df)
{
# print(df$organisation_id)
t=subset(proj_all, organisation_id_o == df$organisation_id)
# print(t)
# print(t$potfundamount)
if (NROW(t) > 0)
   return(data.frame(total=sum(t$potfundamount), num=length(t$potfundamount)))
return(data.frame(m=NA, num=NA))
}


# For every organisation name bi-gram get total and number of applications
av_pot_fund=function(df)
{
# print(df)
av_per_proj=ddply(df, .(organisation_id), get_mean)
# print(av_per_proj)
return(data.frame(total=sum(av_per_proj$total, na.rm=TRUE), num=sum(av_per_proj$num, na.rm=TRUE)))
}


# table(proj_all$stage, useNA="always")

# Code for unigram organization names
# clust_pot_fund=ddply(org_clust, .(group_str), av_pot_fund)
clust_pot_fund=ddply(org_clust, .(bi_group_str), av_pot_fund)

# Display number of applications vs total received
plot(clust_pot_fund$num, clust_pot_fund$total)

# Totals of potfundamount at each stage
sapply(0:10, function(X) mean(subset(proj_all, stage==X)$potfundamount))
sapply(0:10, function(X) sum(subset(proj_all, stage==X)$potfundamount))



