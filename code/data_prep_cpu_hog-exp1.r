
library(qdapTools)
library(tidyverse)
library(dplyr)

#if (!requireNamespace("BiocManager", quietly=TRUE))
#  install.packages("BiocManager")
#BiocManager::install("ComplexHeatmap")
#library(ComplexHeatmap)
#install.packages("FactoMineR")

rm(list=ls()) 

cat("\014")


# Import all hits of all devices with dependent issue 

setwd("D:/nils/projects/dissertation")

dependent_issue <- 'long_cpu_hog_prod126'

file_in <- paste('./', dependent_issue, '.csv', sep = '')
file_out <- './dataset_cpu_hog-exp1.csv'

df0 <- read_csv(file_in) 

df <- head(df0, 10000000)

# keeps hits of the same issue where the severity changes (so removes duplicates)
#df <- df0 %>% arrange(hit_issue_id, hit_date) %>%
#              filter(hit_issue_id != lag(hit_issue_id, default = 0) | 
#              hit_severity != lag(hit_severity) &
#              hit_issue_id == lag(hit_issue_id))



# add dependent variable y
df <- df %>% mutate(y = ifelse(hit_module == 'long_cpu_hog_Prod126' & 
                        hit_severity >= 2, 1, 0))

# Sort by device_id and hit_date - make y an integer
df <- arrange(df, device_id, hit_date)

df$y <- as.numeric(df$y)

summary(df$y)

sum(df$y)

# remove leading colon from hit_labels (otherwise next command gets messed up)
df$hit_labels <- sub('.', '', df$hit_labels)

head(df)

# Create dummy variables from hit_labels with colon separator
xy0 <- mtabulate(strsplit(df$hit_labels, ':'))

head(xy0)

View(xy0)

#xy1 <- as.data.frame(colSums(xy0))
#View(xy1)
#names(xy1)
#colnames(xy1) <- c("x")
#xy1 <- tibble::rownames_to_column(xy1, "Label")
#xy1 <- xy1[order(-xy1$x),]
#write_csv(xy1, 'labels.csv') 


#Removing labels/features with less than 200 hits
#xy <- xy[, colSums(xy) > 200]

xy <- xy0 %>% select(Automation,
                    Access_List,
                    Bugs,
                    Configuration,
                    CPU_1,
                    Crash,
                    Device_Hardening,
                    Diagnostic_Signature,
                    Diagnosis,
                    Failover,
                    Hardware,
                    Hardware_Failure,
                    Hardware_Limitation,
                    Healthcheck,
                    Incident1,
                    Management_1,
                    Memory,
                    Memory_Depletion,
                    Memory_Leak,
                    Optimization_Opportunity,
                    Performance,
                    Prod6028,
                    Prod6044_Prod6027_Prod6009_Series_Adaptive_Security_Appliances,
                    Prod6052_FW_Appliance,
                    Software,
                    Software_Failure,
                    Software_Limitation,
                    System,
                    System_Resource,
                    Temperature,
                    Traffic,
                    troubleshooting
                    )



xy

xy <- xy %>% 
  #add_column(df$device_id, .before = 1) %>% 
  add_column(df$hit_severity) %>% 
  add_column(df$y)

xy <- xy %>% rename(
                    #device_id = 'df$device_id', 
                    hit_severity = 'df$hit_severity',
                    y = 'df$y'
                    )


#Removing 00000 rows

zero_rows <- xy %>% 
  select(-hit_severity) %>% 
  rowSums() > 0

xy <- xy %>% 
  filter(zero_rows)

# Remove hit_severity=0
xy <- xy  %>% filter(hit_severity!=0)

xy <- xy %>%
  select(y, everything()) # %>% # move the Y variable to the "front"
  #rename_at(vars(2:ncol(.)), ~ paste("X", 1:length(.), sep = ""))

names(xy)
colSums(xy)
summary(xy)
head(xy)

write_csv(xy, file_out) 

