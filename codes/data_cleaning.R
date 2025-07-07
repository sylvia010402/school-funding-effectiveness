# install.packages("sas7bdat")
library(sas7bdat)
library(haven)
library(lme4)
library(dplyr)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(stargazer)

seda <- read.csv('/Users/le/Desktop/2025 Spring/052 final project/052_rproject/SEDA/seda_geodist_long_gcs_5.0.csv')
cov <- read.csv('/Users/le/Desktop/2025 Spring/052 final project/052_rproject/SEDA/seda_cov_geodist_long_5.0.csv')

seda <- seda %>% filter(year >= 2015)
cov <- cov %>% filter(year >= 2015)

#Extract useful columns
seda_cleaned <- seda %>% select(sedalea, stateabb, sedaleaname, year, grade, gcs_mn_all, tot_asmt_all)

#1. weighted average of test score across grades

cov %>% summarize(n = n_distinct(sedalea))
seda %>% summarise(n = n_distinct(sedalea))

 # Calculate weighted average for each district-year
seda_cleaned <- seda_cleaned %>% 
  group_by(sedalea, sedaleaname, year) %>%
  summarise(weighted_avg_testscore = sum(gcs_mn_all * tot_asmt_all) / sum(tot_asmt_all), .groups = "drop")

#  # Join the result back to the original seda dataframe
# seda <- seda %>%
#   left_join(district_year_avg, by = c("sedalea", "year"))



#2. expenditure per pupil 

#2019
exp_19 <- read_sas('/Users/le/Desktop/2025 Spring/052 final project/052_rproject/18-19/sdf19_2a_sas.sas7bdat')
summary(exp_19$V33)
summary(exp_19$TCURELSC)
exp_19 <- exp_19 %>% 
  select(LEAID, V33, TCURELSC) %>% 
  filter(V33 >= 0) %>% 
  filter(TCURELSC >= 0) %>% 
  mutate(exp_per_pupil = TCURELSC / V33 ) 

#2018
exp_18 <- read_sas('/Users/le/Desktop/2025 Spring/052 final project/052_rproject/17-18/sdf18_1a.sas7bdat')
summary(exp_18$V33)
summary(exp_18$TCURELSC)

exp_18 <- exp_18 %>% 
  select(LEAID, V33, TCURELSC) %>% 
  filter(V33 >= 0) %>% 
  filter(TCURELSC >= 0) %>% 
  mutate(exp_per_pupil = TCURELSC / V33 ) 

#2017
exp_17 <- read_sas('/Users/le/Desktop/2025 Spring/052 final project/052_rproject/16-17/sdf17_1a.sas7bdat')
summary(exp_17$V33)
summary(exp_17$TCURELSC)

exp_17 <- exp_17 %>% 
  select(LEAID, V33, TCURELSC) %>% 
  filter(V33 >= 0) %>% 
  filter(TCURELSC >= 0) %>% 
  mutate(exp_per_pupil = TCURELSC / V33 ) 

#2016
exp_16 <- read_sas('/Users/le/Desktop/2025 Spring/052 final project/052_rproject/15-16/sdf16_1a.sas7bdat')
summary(exp_16$V33)
summary(exp_16$TCURELSC)
exp_16 <- exp_16 %>% 
  select(LEAID, V33, TCURELSC) %>% 
  filter(V33 >= 0) %>% 
  filter(TCURELSC >= 0) %>% 
  mutate(exp_per_pupil = TCURELSC / V33 )

#2015
exp_15 <- read_sas('/Users/le/Desktop/2025 Spring/052 final project/052_rproject/14-15/sdf15_1a.sas7bdat')
summary(exp_15$V33)
summary(exp_15$TCURELSC)
exp_15 <- exp_15 %>% 
  select(LEAID, V33, TCURELSC) %>% 
  filter(V33 >= 0) %>% 
  filter(TCURELSC >= 0) %>% 
  mutate(exp_per_pupil = TCURELSC / V33 )

#merge them into seda by year
exp_15 <- exp_15 %>% mutate(year = 2015)
exp_16 <- exp_16 %>% mutate(year = 2016)
exp_17 <- exp_17 %>% mutate(year = 2017)
exp_18 <- exp_18 %>% mutate(year = 2018)
exp_19 <- exp_19 %>% mutate(year = 2019)

exp <- rbind(exp_15, exp_16, exp_17, exp_18, exp_19)

exp <- exp %>% 
  select(LEAID, year, exp_per_pupil) %>% 
  rename(sedalea = LEAID)

seda$sedalea <- factor(seda$sedalea)
exp$sedalea <- factor(exp$sedalea)
cov$sedalea <- factor(cov$sedalea)
seda_cleaned$sedalea <- factor(seda_cleaned$sedalea)

seda %>% distinct(sedalea) %>% count()
exp %>% distinct(sedalea) %>% count()     
cov %>% distinct(sedalea) %>% count()
seda_cleaned %>% distinct(sedalea) %>% count()

exp <- exp %>%
  mutate(sedalea = sub("^0+", "", sedalea))

seda_cleaned <- seda_cleaned %>% left_join(exp, by = c("sedalea", "year"))
            

#3. join covariates

#collapse the covariates to the same level as seda
cov <- cov %>% 
  select(sedalea, year, sesall) %>% filter(year >= 2015)
cov <- cov %>%
  group_by(sedalea, year) %>%
  summarise(sesall = first(sesall), .groups = "drop")

#join ses
seda_cleaned <- seda_cleaned %>% left_join(cov, by = c("sedalea", "year"), relationship = "many-to-many")

seda_cleaned <- seda_cleaned %>% rename(weighted_score = weighted_avg_testscore )


#taking a mundlak mean
# Decompose SES into between and within components
seda_cleaned <- seda_cleaned %>%
  group_by(sedalea) %>%
  mutate(
    ses_mean = mean(sesall),   # Between-district effect
    # Within-district (raw SES_it)
  ) %>%
  ungroup()

# 4. check the missing values
seda_cleaned %>% filter(is.na(weighted_score)) %>% count()
summary(seda_cleaned$exp_per_pupil)
summary(seda_cleaned$sesall)
summary(seda_cleaned$ses_mean)
summary(seda_cleaned$weighted_score)


seda_cleaned <- seda_cleaned %>%
  filter(!is.na(weighted_score), 
         !is.na(sesall), 
         !is.na(ses_mean), 
         !is.na(exp_per_pupil),
         exp_per_pupil > 0)

seda_cleaned <- seda_cleaned %>%
  mutate(log_spending = log(exp_per_pupil))


write.csv(seda_cleaned, '/Users/le/Desktop/2025 Spring/052 final project/052_rproject/seda_cleaned.csv', row.names = FALSE)


