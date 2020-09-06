
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
``
setwd("D:/nils/projects/dissertation")

dependent_issue <- 'long_cpu_hog_prod126'

file_in <- paste('./', dependent_issue, '.csv', sep = '')


file_out <- './dataset_cpu_hog-exp2.csv'

df0 <- read_csv(file_in) 

#df0 <- read_csv('./data1k.csv') 

df <- head(df0, 10000000)

# keeps hits of the same issue where the severity changes (so removes duplicates)
#df <- df0 %>% arrange(hit_issue_id, hit_date) %>%
#              filter(hit_issue_id != lag(hit_issue_id, default = 0) | 
#              hit_severity != lag(hit_severity) &
#              hit_issue_id == lag(hit_issue_id))

df0

# add dependent variable y
df <- df %>% mutate(y = ifelse(hit_module == 'long_cpu_hog_Prod126' & 
                        hit_severity >= 2, 1, 0))

# Sort by device_id and hit_date - make y an integer
df <- arrange(df, device_id, hit_date)

df$y <- as.numeric(df$y)

summary(df$y)

sum(df$y)

glimpse(df)

head(df)

df <- df %>% 
  select(hit_date, device_id, hit_module, hit_severity, y)

df <- df %>%
  filter(str_detect(hit_module, 'memory|cpu'))

# Remove hit_severity=0
# df <- df  %>% filter(hit_severity!=0)

df %>%                    
  count(hit_module)  

glimpse(df)
View(df)
#df1 <- cbind(df, dummy(df$hit_module, sep = "_"))

#glimpse(df1)

#df1 <- aggregate(hit_module ~ ., df, toString)

df1 <- df %>% 
  group_by(hit_date,device_id,hit_severity,y) %>% 
  summarise(hit_module=paste(hit_module, collapse = ":"))

View(df1)

xy0 <- mtabulate(strsplit(df1$hit_module, ':'))

View(xy0)

xy0 <- xy0 %>% 
  mutate_if(~is.integer(.) && any(. > 0, na.rm = TRUE),
            ~ if_else(.x>0,1L,.x))



#Removing labels/features with less than 500 hits
xy0 <- xy0[, colSums(xy0) > 500]

xy <- xy0 %>% 
  #add_column(df$device_id, .before = 1) %>% 
  add_column(df1$hit_severity) %>% 
  add_column(df1$y)

xy <- xy %>% rename(
  #device_id = 'df$device_id', 
  hit_severity = 'df1$hit_severity',
  y = 'df1$y'
)


xy <- xy %>%
  select(y, everything()) # %>% # move the Y variable to the "front"
  #rename_at(vars(2:ncol(.)), ~ paste("X", 1:length(.), sep = ""))

#Removing 00000 rows

zero_rows <- xy %>% 
  select(-hit_severity) %>% 
  rowSums() > 0

xy <- xy %>% 
  filter(zero_rows)

# Remove hit_severity=0
#xy <- xy  %>% filter(hit_severity!=0)


names(xy)
colSums(xy)
summary(xy)
head(xy)

View(xy)

write_csv(xy, file_out) 

