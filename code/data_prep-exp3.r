
library(qdapTools)
library(tidyverse)
library(dplyr)





###############################################
#### D A T A    P R E P    F U N C T I O N ####
###############################################

# Function to generate data files for for analysis 
data_prep <- function(df) {
  
  # create dependent variable y
  df <- df %>% mutate(y = ifelse(hit_module == 'long_cpu_hog_Prod126' & 
                                   hit_severity >= 2, 1, 0))
  
  # Sort by device_id and hit_date - make y an integer
  df <- arrange(df, device_id, hit_date)
  df$y <- as.numeric(df$y)

  
  # Reduce table to salient features  
  df <- df %>% 
    select(hit_date, device_id, hit_module, hit_severity, y)
  
  # Filter on Issue with memory or cpu
  df <- df %>%
    filter(str_detect(hit_module, 'memory|cpu'))
  
  # Merge all hits with same timestamp into one event
  df1 <- df #%>% 
    #group_by(hit_date,device_id,hit_severity,y) %>% 
    #summarise(hit_module=paste(hit_module, collapse = ":")) 
  
  glimpse(df1)
  
  xy <- mtabulate(strsplit(df1$hit_module, ':'))
  
  glimpse(xy)
  
  #Make sure all Integers are 1
  xy <- xy %>% 
    mutate_if(~is.integer(.) && any(. > 0, na.rm = TRUE),
              ~ if_else(.x>0,1L,.x))
  
  #Removing labels/features with less than 500 hits
  xy <- xy[, colSums(xy) > 500]
  
  glimpse(xy)
  
  # Adding back in severity and dependent variable
  xy <- xy %>% add_column(df1$hit_severity) %>% 
    add_column(df1$y)
  
  # renaming column names
  xy <- xy %>% rename(hit_severity = 'df1$hit_severity',
                      y = 'df1$y')
  
  #Removing 00000 rows
  zero_rows <- xy %>% select(-hit_severity) %>% 
    rowSums() > 0
  xy <- xy %>% 
    filter(zero_rows)
  
  # Remove hit_severity=0
  #xy <- xy  %>% filter(hit_severity!=0)
  
  xy <- xy %>%
    select(y, everything()) # %>% # move the Y variable to the "front"
  #rename_at(vars(2:ncol(.)), ~ paste("X", 1:length(.), sep = ""))
  
  glimpse(xy)
  
  return(xy)
}

###################################
####  M A I N   P R O G R A M  ####
###################################

# Import all hits of all devices with dependent issue 

rm(list=ls()) 

setwd("D:/nils/projects/dissertation")
dependent_issue <- 'long_cpu_hog_prod126'

file_in <- paste('./', dependent_issue, '.csv', sep = '')
file_out_train <- './dataset_exp3_train.csv'
file_out_test <- './dataset_exp3_test.csv'

# Reading CSV file in 
df0 <- read_csv(file_in) 


cu_count <- df0 %>% count(cu_id, sort = TRUE)
cu_count

# Select train cu events #s
df_train <- df0 %>% filter(cu_id == 11 | 
                             cu_id == 4 | 
                             cu_id == 15 | 
                             cu_id == 10 | 
                             cu_id == 14)


# Select test cu events #s
df_test <- df0 %>% filter(cu_id == 17 |
                          cu_id == 1 | 
                            cu_id == 7 | 
                            cu_id == 21 |
                            cu_id == 12)


df_test <- data_prep(df_test)
df_train <- data_prep(df_train)


in_both = intersect(colnames(df_train), colnames(df_test))
df_train <- df_train[,in_both]
df_test <- df_test[,in_both]
all_equal(df_train, df_test, ignore_row_order = TRUE)

write_csv(df_train, file_out_train)
write_csv(df_test, file_out_test)
df_train
df_test
