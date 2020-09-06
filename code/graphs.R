
library(tidyverse)
library(ggpubr)
library(lubridate)
#library(DBI)
library(UpSetR)
library(viridis)
library(tidyquant)
library(ggforce)

col4<-viridis(4)

col4

#if (!requireNamespace("BiocManager", quietly=TRUE))
#install.packages("tibble")
#install.packages("tidyquant")
#BiocManager::install("ComplexHeatmap")
#library(ComplexHeatmap)




rm(list=ls()) 

cat("\014")

#con <- dbConnect(odbc::odbc(), "test1", timeout = 10)

#netlog_db <- tbl(con, "data1m") %>% collect()

netlog_db <- read.csv('data1m.csv')

head(netlog_db)

summary(netlog_db)

netlog_db$hit_severity <- as.factor(netlog_db$hit_severity)
netlog_db$cu_id <- as.factor(netlog_db$cu_id)
netlog_db$gateway <- as.factor(netlog_db$gateway)

summary(netlog_db)

# CUSTOMERS EVENTS

n1_db <- netlog_db %>% 
  count(cu_id) %>% 
  arrange(desc(n)) %>% 
  slice(1:10)



netlog_db %>%
  filter(cu_id == n1_db$cu_id) %>%
  ggplot(aes(hit_date, group = cu_id, colour = cu_id)) + 
  geom_freqpoly(binwidth = 86400) +
  ylab("Events") +
  scale_color_viridis(discrete=TRUE) +
  theme_minimal() +
  theme(axis.title.x=element_blank())
 

n1_db <- netlog_db %>% 
  count(cu_id) %>% 
  arrange(n) %>% 
  slice(1:10)
        
netlog_db %>%
  filter(cu_id == n1_db$cu_id) %>%
  ggplot(aes(hit_date, group = cu_id, colour = cu_id)) + 
  geom_freqpoly(binwidth = 86400) +
  scale_color_viridis(discrete=TRUE) +
  ylab("Events") +
  theme_minimal() +
  theme(axis.title.x=element_blank())




hit1 <- netlog_db %>%
  ggplot(aes(hit_date, group = gateway, colour = gateway)) + 
  geom_freqpoly(binwidth = 86400) +
  theme_minimal()

hit2 <- netlog_db %>%
  ggplot(aes(hit_date, group = hit_severity, color = hit_severity)) + 
  geom_freqpoly(binwidth = 86400) +
  scale_color_manual(values=c("#008744", "#0057e7", "#ffa700", "#d62d20")) +
  theme_minimal()

ggarrange(hit1, hit2)

n1_db <- netlog_db %>% 
  count(hit_module) %>% 
  arrange(desc(n)) %>% 
  slice(1:100)

netlog_db %>%
  filter(hit_module == n1_db$hit_module) %>%
  ggplot(aes(hit_date, group = hit_module, color = hit_module)) + 
  geom_freqpoly(binwidth = 86400,show.legend = FALSE) +
  ylab("Count") +
  scale_color_viridis(discrete=TRUE) +
  theme_minimal() +
  theme(axis.title.x=element_blank())

netlog_db %>% 
  filter(hit_module == n1_db$hit_module) %>%
  ggplot(aes(hit_module, fill = hit_module)) +
  geom_bar(stat = "count", width=0.8, show.legend = FALSE) +
  scale_fill_viridis_d() +
  ylab("Count") +
  theme_minimal() +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1),
        axis.title.x=element_blank())


 

#netlog_db %>%
#  ggplot(aes(hit_date)) + 
#  geom_freqpoly(binwidth = 86400) +
# facet_wrap(~cu_id) +
# scale_y_continuous(breaks=seq(0, 20000, 20000)) +
#  theme_minimal()

## DONT USE

netlog_db %>%
  ggplot(aes(cu_id)) +
  geom_bar(width = 0.5, fill="tomato2") +
  theme_minimal()

tbl(con, "data1m") %>%
  group_by(cu_id) %>%
  tally() %>%
  collect() %>%
  ggplot(aes(x = cu_id, y = as.integer(n))) + 
  geom_bar(stat = "identity") +
  theme_minimal() + ylab("count")

# CU 1

tbl(con, "data1m") %>%
  filter(hit_severity == 3) %>% 
  collect() %>% 
  ggplot(aes(hit_date)) + 
  geom_freqpoly(binwidth = 86400) +
  theme_minimal()

tbl(con, "data326m") %>%
  ggplot(aes(cu_id)) + 
  geom_freqpoly(binwidth = 86400) +
  geom_smooth() +
  theme_minimal()


df <- tbl(con, "data1m") %>% select(hit_date,cu_id) %>% collect()

df <- df %>% 
  group_by(x = floor_date(as.Date(hit_date), "month")) %>%
  summarise(y = n_distinct(cu_id))

ggplot(data=df, aes(x=x, y=y)) +
  geom_bar(stat="identity") +
  theme_minimal()
  

expand.grid(hit_date = seq(min(df1$hit_date), max(df1$hit_date), by = '1 day')) %>%
  left_join(., df1)

View(df)
  

netlog_db %>%
  filter(device_id == 1) %>% 
  collect() %>%
  filter(hit_date < ymd(20170102)) %>% 
  ggplot(aes(hit_date)) + 
  geom_freqpoly(binwidth = 600) +
  theme_minimal()


# CUSTOMERS TABLE

customers <- tbl(con, "customers") %>%
  collect()

View(customers)

customers$cu_id = as.factor(customers$cu_id)
  
plt1 <- customers %>%
  ggplot(aes(x = cu_id, y = as.integer(no_of_devices), 
             fill = cu_id)) + 
  geom_bar(stat = "identity",show.legend = FALSE) +
  theme_minimal() +
  ylab("Devices") + 
  scale_x_discrete(" ", breaks=c(1,15,30))

plt2 <- customers %>%
  ggplot(aes(x = cu_id, y = as.integer(alert_types),
             fill = cu_id)) + 
  geom_bar(stat = "identity", show.legend = FALSE) +
  theme_minimal() +
  ylab("Issue Types") + 
  scale_x_discrete(" ", breaks=c(1,15,30))

plt3 <- customers %>%
  ggplot(aes(x = cu_id, y = as.integer(alert_count),
             fill = cu_id)) + 
  geom_bar(stat = "identity", show.legend = FALSE) +
  theme_minimal() +
  ylab("Issues") + 
  scale_x_discrete("Customer ID", breaks=c(1,15,30))

#plt4 <- customers %>%
#  ggplot(aes(x = cu_id, y = as.integer(participation_length))) + 
#  geom_bar(stat = "identity") +
#  theme_minimal() +
#  ylab("particpation (days)") + 
#  xlab("customer ID")

ggarrange(plt1, plt3, plt2,
          nrow = 1, ncol = 3)


#### ISSUES

flap1 <- netlog_db %>%
    filter(hit_issue_id == 247) %>% 
    collect() %>% 
    ggplot() + 
    geom_step(aes(hit_date,hit_severity), color= col4[2], size = .1) +
    geom_point(aes(hit_date,hit_severity), colour = col4[3], size = 1) +
    xlab("A") +
    ylab("Severity") +
    ylim(0, 3) +
    theme_minimal()

flap2 <- netlog_db %>%
  filter(hit_issue_id == 127601) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(hit_date,hit_severity), color= col4[2]) +
  geom_point(aes(hit_date,hit_severity), colour = col4[3], size = 1) +
  xlab("B") + 
  ylim(0, 3) +
  theme_minimal() +
  theme(axis.title.y=element_blank())

flap3 <- netlog_db %>%
  filter(hit_issue_id == 7) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(hit_date,hit_severity), color= col4[2]) +
  geom_point(aes(hit_date,hit_severity), colour = col4[3], size = 1) +
  xlab("C") +
  ylab("Severity") +
  ylim(0, 3) +
  theme_minimal()

flap4 <- netlog_db %>%
  filter(hit_issue_id == 542) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(hit_date,hit_severity), color= col4[2], size = .1) +
  geom_point(aes(hit_date,hit_severity), colour = col4[3], size = 1) +
  xlab("D") + 
  ylim(0, 3) +
  theme_minimal() +
  theme(axis.title.y=element_blank())

flap5 <- netlog_db %>%
  filter(hit_issue_id == 39490) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(hit_date,hit_severity), color= col4[2]) +
  geom_point(aes(hit_date,hit_severity), colour = col4[3], size = 1) +
  xlab("E") +
  ylab("Severity") +
  ylim(0, 3) +
  theme_minimal()

flap6 <- netlog_db %>%
  filter(hit_issue_id == 898) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(hit_date,hit_severity), color= col4[2]) +
  geom_point(aes(hit_date,hit_severity), colour = col4[3], size = 1) +
  xlab("F") + 
  ylim(0, 3) +
  theme_minimal() +
  theme(axis.title.y=element_blank())

flap7 <- netlog_db %>%
  filter(hit_issue_id == 4) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(hit_date,hit_severity), color= col4[2], size = .1) +
  geom_point(aes(hit_date,hit_severity), colour = col4[3], size = 1) +
  xlab("G") +
  ylab("Severity") +
  ylim(0, 3) +
  theme_minimal()

flap8 <- netlog_db %>%
  filter(hit_issue_id == 212246) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(hit_date,hit_severity), color= col4[2], size = .1) +
  geom_point(aes(hit_date,hit_severity), colour = col4[3], size = 1) +
  xlab("H") + 
  ylim(0, 3) +
  theme_minimal() +
  theme(axis.title.y=element_blank())


ggarrange(flap1, flap2, flap3, flap4,
          flap5, flap6, flap7, flap8,
          nrow = 4, ncol = 2)


netlog_db %>%
  filter(hit_issue_id == 247) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(as.POSIXct(hit_date),hit_severity), color= col4[2]) +
  geom_point(aes(as.POSIXct(hit_date),hit_severity), colour = col4[3], size = 2) +
  xlab("A") +
  ylab("Severity") +
  ylim(0, 3) +
  coord_x_datetime(xlim = c("2017-02-01 12:00:00", "2017-02-03 00:00:00")) +
  theme_minimal()


netlog_db %>% 
  filter(hit_issue_id == 247) %>% 
  collect() %>% 
  ggplot() + 
  geom_step(aes(as.POSIXct(hit_date),hit_severity), 
            color= col4[2]) +
  geom_point(aes(as.POSIXct(hit_date),hit_severity), 
             colour = col4[3], size = 2) +
  facet_zoom(xy = hit_date > "2017-01-28 12:00:00" & 
                  hit_date < "2017-02-03 00:00:00", 
                  zoom.size = 3,
                  horizontal = F) +
  ylab("Severity") +
  ylim(0, 3) +
  theme_minimal() +
  theme(axis.title.x=element_blank(), 
        zoom = element_rect(fill = 'grey75', colour = NA), 
        validate = FALSE)


df <- tbl(con, "flap2") %>%
  filter(hit_module == "recent_crash_Prod126") %>% 
  collect() %>%
  group_by(x = floor_date(as.Date(hit_date), "month")) %>%
  summarise(y = n_distinct(hit_date))
  
ggplot(data=df, aes(x=x, y=y)) +
  geom_bar(stat="identity") +
  theme_minimal()

df

View(df)







sets <- read.csv(
  file = "D:/nils/IDrive-Sync/Big Data/IM906 Dissertation/flaps.csv",
  header = TRUE, sep = ",", stringsAsFactors = FALSE)

str(sets)

head(sets)

sets <- sets %>% rename(OK = ok,
                        Info = info, 
                        Warning = warning,
                        Danger = danger
                        )

sets <- sets %>% 
  add_column(ID=1) 


sets <- sets[, c(5, 1, 2, 3, 4)]

sets




upset(sets,
      sets = c("OK", "Info", "Warning", "Danger"), 
      number.angles = 45, 
      point.size = 5, 
      line.size = 3,
      mainbar.y.label = "Issue (Flap)", 
      sets.x.label = "Severity", 
      group.by = "sets", cutoff = 8, 
      sets.bar.color=col4,
      text.scale = c(1.3, 1.3, 1.3, 1.3, 2, 1.3))











# take a look at the data

summary(netlog)
head(netlog)
View(netlog)

###___ there is alot of data in this file and your laptop might struggle ...
###___ a random sample of the data can be used during design and development...
###___ with the full dataset used in your final version by commenting out the sample code

NumberOfSamples <- 1000
netlog1 <- netlog[ sample(1:dim(netlog)[1], NumberOfSamples, replace=F ),  ]



noquote(strsplit("A text I want to display with spaces", NULL)[[1]])

x <- c(as = "asfef", qu = "qwerty", "yuiop[", "b", "stuff.blah.yech")
x
# split x on the letter e
x <- strsplit(x, "e")

unlist(strsplit("a.b.c", "."))
## [1] "" "" "" "" ""
## Note that 'split' is a regexp!
## If you really want to split on '.', use
unlist(strsplit("a.b.c", "[.]"))
## [1] "a" "b" "c"
## or
unlist(strsplit("a.b.c", ".", fixed = TRUE))
