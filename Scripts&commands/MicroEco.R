####
# Bhim B Biswa
# Enhanced tameness by Limosilactobacillus reuteri from gut microbiota of selectively bred mice
# This script is used to rarify, calculate aplha and beta diversity, and generate associated graphs  
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

# set.seed is used to fix the random number generation to make the results repeatable
set.seed(123)

#create an object of microtable class R6
dataset <- microtable$new(otu_table = OTU_data, sample_table = OTU_meta, tax_table = Taxonomy_data)
dataset

#Then we use sample_sums() to check the sequence numbers in each sample.
dataset$sample_sums() %>% range

dataset$rarefy_samples(sample.size = 6421338)

dataset$sample_sums() %>% range

#Abundance calculation
dataset$cal_abund()

class(dataset$taxa_abund)

dataset$taxa_abund$Phylum[1:5, 1:5]
#save abundance file
dataset$save_abund(dirpath = "taxa_abund")


#Calculate alpha diversity
dataset$cal_alphadiv(PD = FALSE)

# return dataset$alpha_diversity
class(dataset$alpha_diversity)

# save dataset$alpha_diversity to a directory
dataset$save_alphadiv(dirpath = "alpha_diversity")

# unifrac = FALSE means do not calculate unifrac metric
# require GUniFrac package installed
dataset$cal_betadiv(unifrac = FALSE)
# return dataset$beta_diversity
class(dataset$beta_diversity)
# save dataset$beta_diversity to a directory
dataset$save_betadiv(dirpath = "beta_diversity")

# create trans_abund object
# use 10 Phyla with the highest abundance in the dataset.
t1 <- trans_abund$new(dataset = dataset, taxrank = "Phylum", ntaxa = 10)

t1$plot_bar(others_color = "grey70", facet = "Group", xtext_keep = FALSE, legend_text_italic = FALSE)
# return a ggplot2 object


dataset1 <- dataset$merge_samples(use_group = "Group")
t2 <- trans_venn$new(dataset1, ratio = "seqratio")
t2$plot_venn()



dataset$cal_alphadiv(PD = FALSE)
t1 <- trans_alpha$new(dataset = dataset, group = "Group")
t1$data_stat[1:5, ]

t1$cal_diff(method = "KW")
# return t1$res_diff
t1$res_diff[1:5, ]

t1$cal_diff(method = "KW_dunn", measure = "Chao1" )
# return t1$res_diff
t1$res_diff[1:5, ]

t1$cal_diff(method = "wilcox")
t1$cal_diff(method = "t.test")

t1$cal_diff(method = "anova")
# return t1$res_diff
t1$res_diff



t1$cal_diff(method = "anova")
t1$plot_alpha(measure = "Shannon")
plot <- t1$plot_alpha(measure = "shannon", boxplot_add="None", xtext_size= 24, ytitle_size= 20)
plot
plot <- plot + geom_dotplot(aes(colour = Group), binaxis='y', stroke = 2, fill = "white", stackdir='center', binwidth = 6)
plot <- plot + scale_colour_manual(values = c("blue", "deepskyblue", "sienna1", "orange")) #change border color 
plot <- plot + scale_fill_manual(values = c("blue", "deepskyblue", "sienna1", "orange")) #change inside color
plot


t6 <- trans_beta$new(dataset = dataset, group = "Group", measure = "bray")

t6$cal_ordination(ordination = "PCoA")
t6$plot_ordination(plot_color = "Group", plot_shape = "Sex", plot_type = c("point", "ellipse"))


class(t6$res_ordination(plot_color = "Group", plot_shape = "Sex", plot_type = c("point", "ellipse"))
      
      t6$plot_ordination(plot_color = "WHS", plot_shape = "Sex", plot_type = c("point", "ellipse"))
      t6$plot_ordination(plot_color = "WHS", point_size = 5, point_alpha = .2, plot_type = c("point", "ellipse"), ellipse_chull_fill = FALSE)
      t6$plot_clustering(group = "WHS")
      t6$cal_group_distance()
      t6$plot_group_distance(distance_pair_stat = TRUE)
      
      t6$cal_group_distance(within_group = FALSE)
      t6$plot_group_distance(distance_pair_stat = TRUE)
      
      
      t6$cal_manova(manova_all = TRUE)
      t6$res_manova
      
      t6$cal_betadisper()
      t6$res_betadisper