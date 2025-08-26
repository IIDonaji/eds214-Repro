library(here)
library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)

Q1 <- read_csv(here("data", "QuebradaCuenca1-Bisley.csv" ))
names(Q1)
class(Q1$Sample_Date)

Q2 <- read_csv(here("data", "QuebradaCuenca2-Bisley.csv" ))
names(Q2)

Q3 <- read_csv(here("data", "QuebradaCuenca3-Bisley.csv"))
names(Q3)

PRM <- read_csv(here("data", "RioMameyesPuenteRoto.csv"))
names(PRM)

All_df <- PRM %>% 
  mutate(Sample_Date = ymd(Sample_Date)) %>% 
  full_join(Q1) %>% 
  full_join(Q2) %>% 
  full_join(Q3) %>% 
  clean_names()
names(All_df)

skim(All_df)

df_long <- All_df %>% 
  pivot_longer(cols = c(k, no3_n, mg, ca, nh4_n),
               names_to = "ions",
               values_to = "water_concen") 
  
small_df <- df_long %>% 
  select(sample_id, sample_date, ions, water_concen) %>% 
  rename(site = sample_id ,
         date = sample_date)

ggplot(data = small_df, aes(x = date, y = water_concen)) +
  geom_line(aes(color = site)) +
  facet_wrap(~ions)

  
  
  