
# Generate bi-cluster-org.csv that  clust-info.R reads

awk -f getwords.awk < organisation.csv > bi-clust-org.csv
