####
# Bhim B Biswa
# Enhanced tameness by Limosilactobacillus reuteri from gut microbiota of selectively bred mice
# This script performs hierarchical clustering on different paremeters of tameness test
####

library(pvclust)

df<- read.delim("H:/Tame_test1.txt", , row.names=1)

result <- pvclust(df, method.dist="corr", method.hclust="ward.D", nboot=1000, parallel=TRUE)

plot(result)

pvrect(result, alpha=0.95)
