#install.packages("ggplot2")
#install.packages("factoextra")
#install.packages("dplyr")

rm(list=ls())

library(ggplot2)
library(factoextra)
library(dplyr)

setwd("C:/MSc_Internship_Final/R_Scripts")

SG_CRC_BA <- read.csv("SG_CRC_BA.csv")
stage_mapping <- c(
  'I' = 'Early Stage',
  'II' = 'Early Stage',
  'III' = 'Late Stage',
  'IV' = 'Late Stage',
  'IIA' = 'Early Stage',
  'IIB' = 'Early Stage',
  'IIC' = 'Early Stage',
  'IIIA' = 'Late Stage',
  'IIIB' = 'Late Stage',
  'IIIC' = 'Late Stage',
  'IVA' = 'Late Stage',
  'IVB' = 'Late Stage'
)

# Replacing the values in the 'Stage' column using the mapping
SG_CRC_BA <- SG_CRC_BA %>%
  mutate(Stage = recode(Stage, !!!stage_mapping))

X <- SG_CRC_BA[, !names(SG_CRC_BA) %in% c('patient_id', 'TMB', 'KRAS', 'BRAF', 'NRAS', 'TP53', 'APC', 'PIK3CA',
                                          'PIK3R1', 'SMAD4', 'ERBB4', 'RNF43', 'ZNRF3', 'KIT', 'TGFBR2',
                                          'Vital.status', 'MSI.Status', 'CRIS', 'Gender', 'Age.at.Diagnosis',
                                          'Site.of.Primary.Colorectal.tumour', 'Side', 'Grade', 'TNM', 'Stage',
                                          'iCMS', 'CMS', 'group3', 'group5')]

X <- X[, sapply(X, function(col) sd(col) != 0)]
X_scaled <- scale(X)

pca_result <- prcomp(X_scaled, center = TRUE, scale. = TRUE)

explained_var <- pca_result$sdev^2 / sum(pca_result$sdev^2) * 100

# Visualize PCA for tumor stage
fviz_pca_ind(pca_result,
             geom.ind = "point",  
             col.ind = SG_CRC_BA$Stage,  # Color by groups
             palette = c("#00AFBB", "#FC4E07"),
             addEllipses = TRUE,
             legend.title = "Group" 
) +
  labs(x = paste0("PC1 (", round(explained_var[1], 2), "%)"),
       y = paste0("PC2 (", round(explained_var[2], 2), "%)")) +
  ggtitle("SG_Tumor_Stage") +  
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) 

# Visualize PCA for BRAF
fviz_pca_ind(pca_result,
             geom.ind = "point",  
             col.ind = SG_CRC_BA$BRAF, 
             palette = c("#00AFBB", "#FC4E07"),
             addEllipses = TRUE,  
             legend.title = "Group" 
) +
  labs(x = paste0("PC1 (", round(explained_var[1], 2), "%)"),
       y = paste0("PC2 (", round(explained_var[2], 2), "%)")) +
  ggtitle("SG_BRAF") + 
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  

# Visualize PCA for TP53
fviz_pca_ind(pca_result,
             geom.ind = "point",  
             col.ind = SG_CRC_BA$TP53,
             palette = c("#00AFBB", "#FC4E07"),
             addEllipses = TRUE,  
             legend.title = "Group"  
) +
  labs(x = paste0("PC1 (", round(explained_var[1], 2), "%)"),
       y = paste0("PC2 (", round(explained_var[2], 2), "%)")) +
  ggtitle("SG_TP53") + 
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) 


# for MSI status
color_palette_MSI <- c("#00AFBB", "#FC4E07")

fviz_pca_ind(pca_result,
             geom.ind = "point", 
             col.ind = SG_CRC_BA$MSI.Status,  
             palette = color_palette_MSI,
             addEllipses = TRUE,  
             legend.title = "Group"  
) +
  labs(x = paste0("PC1 (", round(explained_var[1], 2), "%)"),
       y = paste0("PC2 (", round(explained_var[2], 2), "%)")) +
  ggtitle("SG_MSI_Status") + 
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) 


# Visualize PCA for TumorSites
color_palette_TS <- c("#00AFBB", "#FC4E07", "#E7B800", "#00BA38", 
                   "#6A3D9A", "#FF7F00", "#B15928", "#1F78B4", "#D81B60")

fviz_pca_ind(pca_result,
             geom.ind = "point",  
             col.ind = SG_CRC_BA$Site.of.Primary.Colorectal.tumour,  
             palette = color_palette_TS,
             addEllipses = TRUE,  
             legend.title = "Group" 
) +
  labs(x = paste0("PC1 (", round(explained_var[1], 2), "%)"),
       y = paste0("PC2 (", round(explained_var[2], 2), "%)")) +
  ggtitle("SG_Tumor_Location") + 
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) 

