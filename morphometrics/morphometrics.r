library(dplyr)

# Load dataset
combined <- read.csv("parviflora_ryancleaned_2022.csv", header = TRUE)

# Code factors
combined$Putative_species <- as.factor(combined$Putative_species)
combined$Viscid <- as.factor(combined$Viscid)
combined$Pendent_fls <- as.factor(combined$Pendent_fls)
combined$Calciphile <- as.factor(combined$Calciphile)
head(combined)

# Generate julian dates
library(lubridate)
combined$Bloom_date <- as.Date(combined$Bloom_date, "%m/%d/%y")
combined$Bloom_date <- yday(combined$Bloom_date)

# Plot bloom dates
library(ggplot2)
ggplot(combined, aes(y=Bloom_date, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Julian day") + theme(axis.text.x = element_text(angle = 45))
# Ask if significant with ANOVA (it wasn't)
summary(aov(Bloom_date ~ Putative_species, data = combined))


# Save old dataset
combined.nonnormalized <- combined

# Normalize data matrix
combined <- rapply(combined, scale, c("numeric","integer"), how = "replace")


combined$Notes <- NULL
combined$Axis_3 <- NULL
combined$Original_order <- NULL


# Build the discriminant
library(MASS)
discriminant <- lda(Putative_species ~ Style_length + Stamen_length + Flower_length + Flower_width + Pedicel_length + Tooth_length + Tooth_width + Sinus_depth + Leaf_width + Leaf_length + Free_stipule_length + Petiole_hair_length + Laminar_hairs, data = combined, na.action="na.omit")

# Classification success
discriminant.jackknife <- lda(Putative_species ~ Style_length + Stamen_length + Flower_length + Flower_width + Pedicel_length + Tooth_length + Tooth_width + Sinus_depth + Leaf_width + Leaf_length + Free_stipule_length + Petiole_hair_length + Laminar_hairs, data = combined, na.action="na.omit", CV = TRUE)
ct <- table(combined$Putative_species, discriminant.jackknife$class)
sum(diag(prop.table(ct)))

# Predict species by the discriminant function
discriminant.prediction <- predict(discriminant)

# Create dataframe for plotting
plotdata <- data.frame(type = combined$Putative_species, lda = discriminant.prediction$x)

library(ggplot2)
ggplot(plotdata) + geom_point(aes(lda.LD1, lda.LD2, colour = type), size = 2.5)



# Build the discriminant, panthertown, saurensis, and parviflora only
combined.reduced <- combined[combined$Putative_species == 'parviflora' | combined$Putative_species == 'panthertown' | combined$Putative_species == 'saurensis',]
combined.reduced$Putative_species <- droplevels(combined.reduced$Putative_species) # Drop empty levels
discriminant <- lda(Putative_species ~ Style_length + Stamen_length + Flower_length + Flower_width + Pedicel_length + Tooth_length + Tooth_width + Sinus_depth + Leaf_width + Leaf_length + Free_stipule_length + Petiole_hair_length + Laminar_hairs, data = combined.reduced, na.action="na.omit")
discriminant.prediction <- predict(discriminant)
plotdata <- data.frame(type = combined.reduced$Putative_species, lda = discriminant.prediction$x)
ggplot(plotdata) + geom_point(aes(lda.LD1, lda.LD2, colour = type), size = 2.5)
# boxplot version
#ggplot(plotdata, aes(y=lda.LD1, x=type)) + geom_boxplot() + xlab("") + ylab("LD1") + theme(axis.text.x = element_text(angle = 45))




# Multivariate MANOVA
res.man <- manova(cbind(Style_length, Stamen_length, Flower_length, Flower_width, Pedicel_length, Tooth_length, Tooth_width, Sinus_depth, Leaf_width, Leaf_length, Free_stipule_length, Petiole_hair_length, Laminar_hairs) ~ Putative_species, data = combined)
summary(res.man)

# Break down variable importance
summary.aov(res.man)

# Assess species pairwise significance
# You must drop perfectly correlated values or you will get a rank deficiency error
#library(devtools)
#install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
library(pairwiseAdonis)
pairwise.adonis(combined[,c("Style_length", "Stamen_length", "Flower_length", "Flower_width", "Pedicel_length", "Tooth_length", "Tooth_width", "Sinus_depth", "Leaf_width", "Leaf_length", "Free_stipule_length", "Petiole_hair_length", "Laminar_hairs")], combined$Putative_species, sim.method = "gower", p.adjust.m = "hochberg", perm = 10000)
# All comparisons significant


# Univariate boxplots

p1 <- ggplot(combined.nonnormalized, aes(y=Style_length, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Style length (mm)") + theme(axis.text.x = element_text(angle = 45))
p2 <- ggplot(combined.nonnormalized, aes(y=Stamen_length, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Stamen length (mm)") + theme(axis.text.x = element_text(angle = 45))
p3 <- ggplot(combined.nonnormalized, aes(y=Pedicel_length, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Pedicel length") + theme(axis.text.x = element_text(angle = 45))
p4 <- ggplot(combined.nonnormalized, aes(y=Tooth_length, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Tooth length (mm)") + theme(axis.text.x = element_text(angle = 45))
p5 <- ggplot(combined.nonnormalized, aes(y=Sinus_depth/Leaf_length, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Sinus depth per unit leaf length") + theme(axis.text.x = element_text(angle = 45))
p6 <- ggplot(combined.nonnormalized, aes(y=Leaf_length/Leaf_width, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Leaf area index") + theme(axis.text.x = element_text(angle = 45))
p7 <- ggplot(combined.nonnormalized, aes(y=Leaf_width, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Leaf width (mm)") + theme(axis.text.x = element_text(angle = 45))
p8 <- ggplot(combined.nonnormalized, aes(y=Petiole_hair_length, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Petiole hair length (mm)") + theme(axis.text.x = element_text(angle = 45))
p9 <- ggplot(combined.nonnormalized, aes(y=Laminar_hairs, x=Putative_species)) + geom_boxplot() + xlab("") + ylab("Laminar hair length (mm)") + theme(axis.text.x = element_text(angle = 45))


library(gridExtra)
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, nrow = 3)





