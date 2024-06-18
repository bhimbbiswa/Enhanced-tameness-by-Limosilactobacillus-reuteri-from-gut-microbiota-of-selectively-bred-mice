####Bhim B Biswa
# Enhanced tameness by Limosilactobacillus reuteri from gut microbiota of selectively bred mice
# This script performs multivariable association analysis using MaAsLin2 to identify associations
# between microbial taxa abundances and different groups of selectively bred WHS mice.
# The data consists of microbiota abundance profiles and metadata on mouse groups.
####

library(Maaslin2)


df_input_data <- read.csv("H:/Manuscripts/Taxonomy/All_samples.txt", sep="\t", row.names=1, header=TRUE)


df_input_metadata <- read.table("H:/New_trial/New_humann3/Metadata.txt", sep="\t", row.names=1, header=TRUE)

fit_data = Maaslin2(
  input_data = df_input_data, 
  input_metadata = df_input_metadata,
  normalization = "TSS",
  transform = "LOG",
  min_prevalence = 0.5,
  min_abundance = 100,
  analysis_method = "LM",
  max_significance= 0.2,
  output = "C_vsS_TSS_LOG_LM_abund_trial_sign")