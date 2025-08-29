################################################################################
##                                 Clean Data                                 ##
################################################################################

# The following has my clean data used to calculate a 9 week moving-average to  recreate a time-series plot of stream water concentrations before and after hurricane disturbance in the Bisley, Puerto Rico streams.

# Packages used to run this analysis 
library(here)
library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)
library(dplyr)


# The following imports the `.csv` files with the data of each Watershed that will be used for this analysis.

# Quebrada one-Bisley (Q1) Chemistry Data
Q1 <- read_csv(here("data", "QuebradaCuenca1-Bisley.csv" ))

# Quebrada two-Bisley (Q2) Chemistry Data  
Q2 <- read_csv(here("data", "QuebradaCuenca2-Bisley.csv" ))


# Quebrada three-Bisley (Q3) Chemistry Data  
Q3 <- read_csv(here("data", "QuebradaCuenca3-Bisley.csv"))


# Puente Roto Mameyes (MPR) Chemistry Data
MPRM <- read_csv(here("data", "RioMameyesPuenteRoto.csv"))

# Wrangling data-frames
#combining each `.csv` into one data-frame
combo_chemi_data <- rbind(Q1, Q2, Q3, MPRM) %>% 
  mutate(Sample_Date = ymd(Sample_Date)) %>% 
  clean_names()  # to lower case

# More data cleaning using pivot_long to create a column with all ions and a column with their water concentration

stream_water_chemi <- combo_chemi_data %>% 
  pivot_longer(cols = c(k, no3_n, mg, ca, nh4_n), 
               names_to = "ions",
               values_to = "water_conc") %>% 
  rename(basins = sample_id) # changed to basins to clarify their location

# Analysis: calculating the 9-week moving average

stream_anly <- stream_water_chemi %>% 
  select(basins, sample_date, ions, water_conc) %>% 
  filter(sample_date >= "1988-01-10", sample_date < "1994-07-31") %>% # I only want data from this time frame
  arrange(sample_date,ions) %>%
  group_by(ions, basins) %>% 
  mutate(conc_aver = sapply(
    sample_date,
    moving_average,
    dates = sample_date,
    conc = water_conc,
    win_size_wks = 9 
  ))

saveRDS(stream_anly, here("outputs", "stream_anly.rds" ))