library(tidyverse)

d1 <- read_csv('intermediate/ort_bundesland.csv')

d1 <- d1 %>%
  mutate(Land=if_else(is.na(Bundesland), NA_character_, 'Deutschland'))
  
d2 <- d1 %>% filter(is.na(Land))

# write_csv(d2, path='intermediate/ort_bundesland_manual.csv') # after saving, clean manually
write_csv(d1, path='intermediate/ort_bundesland_land.csv') # add land column
