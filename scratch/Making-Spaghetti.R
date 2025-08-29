##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            ~~
##                              PLAN AN ANALYSIS                            ----
##                                                                            ~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# In the following I will be tidying, transforming, visualizing and modeling my data. To calculate a 9 week rolling average and turn into a function to use in my clean data and recreate a time-series plot of stream water concentrations before and after hurricane disturbance. 

# Loading needed packages
library(here)
library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)
library(patchwork)
library(dplyr)
library(ARTofR)

# Reading in the data needed for analysis 
# Quebrada one-Bisley (Q1) Chemistry Data
Q1 <- read_csv(here("data", "QuebradaCuenca1-Bisley.csv" ))
names(Q1) # checking column names
class(Q1$Sample_Date) # checking if Sample_Date is in Date format
# Quebrada two-Bisley (Q2) Chemistry Data
Q2 <- read_csv(here("data", "QuebradaCuenca2-Bisley.csv" ))
names(Q2)
# Quebrada three-Bisley (Q3) Chemistry Data 
Q3 <- read_csv(here("data", "QuebradaCuenca3-Bisley.csv"))
names(Q3)
# Puente Roto Mameyes (MPR) Chemistry Data
MPRM <- read_csv(here("data", "RioMameyesPuenteRoto.csv"))
names(MPRM)

# used full_join to have all data in one data-frame
#All_df <- PRM %>% 
  #mutate(Sample_Date = ymd(Sample_Date)) %>% 
  #full_join(Q1) %>% 
  #full_join(Q2) %>% 
  #full_join(Q3) %>% 
  #clean_names()

# found a shorter method, rbind() 

all_df <- rbind(Q1, Q2, Q3, MPRM) %>% 
  mutate(Sample_Date = ymd(Sample_Date)) %>% 
  clean_names()

names(all_df) # checking that names where lowered cased

# Pivot long ions and named column ions and concentrations to water_conc. Renamed sample_id to basins

df_long <- all_df %>% 
  pivot_longer(cols = c(k, no3_n, mg, ca, nh4_n), 
               names_to = "ions",
               values_to = "water_conc") %>% 
  rename(basins = sample_id,
         year = sample_date)

# A small clean data-frame to use to calculate moving average.

source("R/moving_average_FUN.R") # calling my function from my R. file

small_df <- df_long %>% # checking data using skim(small_df)
  filter(!is.na("no3_n")) %>% 
  select(basins, year, ions, water_conc) %>% 
  filter(year >= "1988-01-10", year < "1994-07-31") %>%
  arrange(year,ions) %>% 
 # Calculate 9- week rolling average 
  group_by(ions, basins) %>% 
  mutate(conc_aver = sapply(
    year,
    moving_average,
    dates = year,
    conc = water_conc,
    win_size_wks = 9 
  ))
 
view(small_df) # checking my data to see if it made my rolling average column 

# used a 3 variable plot to see relationships in the data
ggplot(data = small_df, aes(x = year, y = water_concen)) +
  geom_line(aes(color = basins)) +
  facet_wrap(~ions)

# plotting my data with my moving average
water_plot <- ggplot(data = small_df, aes(x = year, 
                            y = conc_aver)) +

  labs(y = "Average Concentration of Nutrient",
       title = "Title here",
       x = "Year",
       color = "Basins")+
  geom_line(aes(color = basins)) +
  geom_vline(xintercept = as.Date("1989-09-18"),
             linetype = "dotdash") +
  facet_wrap(ions~ .,
             ncol = 1,
             scales = "free_y") +
  theme_bw()
water_plot
