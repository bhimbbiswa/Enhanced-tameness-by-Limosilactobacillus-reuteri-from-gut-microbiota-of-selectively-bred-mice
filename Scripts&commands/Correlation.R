####
# Bhim B Biswa
# Enhanced tameness by Limosilactobacillus reuteri from gut microbiota of selectively bred mice
# This script analyzes the relationship between oxytocin levels and tameness scores in selectively bred mice,
# and visualizes the correlations differentiated by group and sex.
####

library(corrplot)
library(ggplot2)
library(ggpubr)


input_data <- read.csv("H:/Projects/Book1.txt", sep="\t", row.names=1, header=TRUE)

tameness_data = input_data$Tameness
oxytocin_data = input_data$Oxytocin

# Create a scatter plot of oxytocin vs tameness data
# Points are colored and shaped by 'Group' and 'Sex'
plot <- ggplot(input_data, aes(y = tameness_data, x = oxytocin_data)) +
  geom_point(aes(color=input_data$Group, shape=input_data$Sex), size=4) +
  geom_smooth(method = "lm", se = FALSE, color="Red") +  # Adding a linear regression line without confidence interval
  stat_cor(method="pearson", label.x.npc = "left", label.y.npc = "top") +  #change correlation method as you want
  theme_bw() +
  labs(y = "Tameness", x = "Oxytocin") +  # Set axis labels
  theme(axis.text.y = element_text(size=18, colour = "black"), 
        axis.text.x = element_text(size = 18, colour = "black", vjust = 0.5),
        axis.title.x = element_text(size=18, colour = "black"), 
        axis.title.y = element_text(size = 15, colour = "black"))

plot
