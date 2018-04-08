library(tidyverse)

d1 <- read_csv('raw/original_data.csv', locale=locale('de'))
d3 <- read_csv('raw/states_statistics.csv', locale=locale('de'))

d2 <- read_csv('intermediate/ort_bundesland_land.csv', locale=locale('de'))
d4 <- read_csv('intermediate/ort_bundesland_manual.csv', locale=locale('de'))

merged <- d2 %>%
  left_join(d4, by = "Ort") %>% 
  mutate(Land=ifelse(is.na(Land.x), Land.y, Land.x)) %>%
  mutate(Bundesland=ifelse(is.na(Bundesland.x), Bundesland.y, Bundesland.x)) %>%
  mutate(Bundesland.x = NULL, Bundesland.y = NULL, Land.x = NULL, Land.y = NULL)

merged %>% filter(Land != "Deutschland")

d1 <- d1 %>% mutate(Betrag = parse_number(Betrag, locale=locale('de')) / 100)

d2 <- d2 %>% filter(!is.na(Bundesland))

res_natural <- d1 %>%
  filter(Kategorie != "juristische Person") %>%
  select(-one_of("Bundesland")) %>%
  left_join(merged) %>%
  group_by(Bundesland) %>% 
  summarise(Betrag = sum(Betrag)) %>%
  inner_join(d3) %>%
  mutate(pro_einwohner = Betrag / Einwohnerzahlen) %>%
  mutate(bip_pro_einwohner = (BIP * 1000000) / Einwohnerzahlen)

write_csv(res_natural, path = "results/natural.csv")

res_juristic <- d1 %>%
  filter(Kategorie == "juristische Person") %>%
  select(-one_of("Bundesland")) %>%
  left_join(merged) %>%
  group_by(Bundesland) %>% 
  summarise(Betrag = sum(Betrag)) %>%
  inner_join(d3) %>%
  mutate(pro_einwohner = Betrag / Einwohnerzahlen) %>%
  mutate(bip_pro_einwohner = (BIP * 1000000) / Einwohnerzahlen)

write_csv(res_juristic, path = "results/juristic.csv")


d1 %>% select(-one_of("Bundesland")) %>%
  left_join(merged) %>%
  group_by(Land) %>% summarise(Sum = sum(Betrag))
