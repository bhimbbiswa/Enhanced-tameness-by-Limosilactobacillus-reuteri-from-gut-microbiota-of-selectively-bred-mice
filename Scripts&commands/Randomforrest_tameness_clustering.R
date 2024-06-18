####
# Bhim B Biswa
# Enhanced tameness by Limosilactobacillus reuteri from gut microbiota of selectively bred mice
# This script is used to run random forest analysis on bacterial abundance data to identify taxa
# that significantly correlate with tameness scores in selectively bred mice. 
# Following the identification of important features, the script performs correlation clustering 
# to examine the relationships between bacterial taxa and tameness scores, aiming to reveal 
# potential mechanistic insights into how microbial communities may influence host behavior.
####

library(microeco)
library(magrittr)
library(ggplot2)

#import OTU table
OTU_data = read.table(file = "H:/Taxonomic_diversity/All_samples_new.txt", header = TRUE, sep = "\t",
                      row.names = 1,
                      stringsAsFactors = FALSE)
OTU_data[1:5, 1:5]

class(OTU_data)
#Import taxonomy table
Taxonomy_data = read.table(file = "H:/Taxonomic_diversity/All_phylum_new.txt", header = TRUE, sep = "\t",
                           row.names = 1,
                           stringsAsFactors = FALSE)
Taxonomy_data[1:5, 1:5]

Taxonomy_data %<>% tidy_taxonomy

Taxonomy_data[1:5, 1:5]

class(Taxonomy_data)
#Import metadata
OTU_meta = read.table(file = "H:/New_trial/Trial/MetaData.txt", header = TRUE, sep = "\t",
                      row.names = 1,
                      stringsAsFactors = FALSE)
OTU_data[1:3, 1:3]

class(OTU_meta)



#Import tameness data
Tameness_data = read.table(file = "H:Normalized_tameness_test.txt", header = TRUE, sep = "\t",
                           row.names = 1,
                           stringsAsFactors = FALSE)
Tameness_data[1:5, 1:5]

# set.seed is used to fix the random number generation to make the results repeatable
set.seed(123)

#create an object of microtable class R6
dataset <- microtable$new(otu_table = OTU_data, sample_table = OTU_meta, tax_table = Taxonomy_data)
dataset

#Then we use sample_sums() to check the sequence numbers in each sample.
dataset$sample_sums() %>% range

dataset$rarefy_samples(sample.size = 6421338)

dataset$sample_sums() %>% range

# first create trans_diff object as a demonstration
t2 <- trans_diff$new(dataset = dataset, method = "rf", group = "Group", taxa_level = "Species")
# then create trans_env object
t1 <- trans_env$new(dataset = dataset, add_data = Tameness_data)
# use other_taxa to select taxa you need
t1$cal_cor(use_data = "other", p_adjust_method = "fdr", other_taxa = t2$res_diff$Taxa[1:40])
t1$plot_cor()
t1$plot_cor(pheatmap = TRUE, color_palette = rev(RColorBrewer::brewer.pal(n = 9, name = "RdYlBu")))