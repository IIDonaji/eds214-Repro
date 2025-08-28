##~~~~~~~~~~~~~~~~~~~~~~~~~~
##  ~ Plan An Analysis  ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~

# Loading needed packages
library(here)
library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)
library(patchwork)
library(dplyr)

source("R/rolling_aver_FUN.R")

# reading in the data needed for analyzation 
Q1 <- read_csv(here("data", "QuebradaCuenca1-Bisley.csv" ))
names(Q1)
class(Q1$Sample_Date)

Q2 <- read_csv(here("data", "QuebradaCuenca2-Bisley.csv" ))
names(Q2)

Q3 <- read_csv(here("data", "QuebradaCuenca3-Bisley.csv"))
names(Q3)

PRM <- read_csv(here("data", "RioMameyesPuenteRoto.csv"))
names(PRM)

# used full_join to have all data in one dataframe
#All_df <- PRM %>% 
  #mutate(Sample_Date = ymd(Sample_Date)) %>% 
  #full_join(Q1) %>% 
  #full_join(Q2) %>% 
  #full_join(Q3) %>% 
  #clean_names()

# found a shorter method, rbind() for vertical

all_df <- rbind(Q1, Q2, Q3, PRM) %>% 
  mutate(Sample_Date = ymd(Sample_Date)) %>% 
  clean_names()

names(all_df) # checking that names where lowered cased

# more data cleaning

df_long <- all_df %>% 
  pivot_longer(cols = c(k, no3_n, mg, ca, nh4_n), 
               names_to = "ions",
               values_to = "water_concen") %>% 
  rename(basin = sample_id,
         year = sample_date)

# creating a new clean dataframe to use to calculate average
small_df <- df_long %>% 
  filter(!is.na("water_concen")) %>% 
  select(basin, year, ions, water_concen) %>% 
  filter(year >= "1988-01-10", year < "1994-07-31") %>% 
  arrange(year,ions) %>% 
  group_by(ions, basin) %>% 
  mutate(conc_aver = sapply(
    year,
    moving_average,
    dates = year,
    conc = water_concen,
    win_size_wks = 9 
  ))
 

skim(small_df)

# used a 3 variable plot to see relationships in the data
ggplot(data = small_df, aes(x = year, y = water_concen)) +
  geom_line(aes(color = basin)) +
  facet_wrap(~ions)

# Calculate 9- week rolling average

  


#ggplot(data = small_df, aes(x = year, y = #rolling average)) +
# geom_line(aes(color =)) +
# geom_vline(xintercept = as.Date("hurricane date"), libetype = "dash) 

