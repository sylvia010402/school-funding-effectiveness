install.packages("sjPlot")
library(sjPlot)


seda_cleaned <- read.csv('/Users/le/Desktop/2025 Spring/052 final project/052_rproject/seda_cleaned.csv')

#Model 1: This model estimates the proportion of test score variance that lies between districts (for ICC).
mod1 <- lmer(weighted_score ~ sesall + (1 | sedalea), data = seda_cleaned, REML = FALSE)
summary(mod1)

#Model 2: Add main effect: This estimates separate relationships of SES (within and between) and spending.
mod2 <- lmer(weighted_score ~ sesall + ses_mean + log_spending + (1 | sedalea), data = seda_cleaned)
summary(mod2)

#Model 3: Test whether the relationship of SES depends on funding, i.e., does funding amplify or weaken the SES association on test score?
mod3 <- lmer(weighted_score ~ sesall + ses_mean + log_spending + ses_mean:log_spending + (1 | sedalea), data = seda_cleaned)
summary(mod3)


tab_model(mod1, mod2, mod3,
          show.ci = FALSE,         # Hides confidence intervals
          show.se = TRUE,          # Shows standard errors
          show.p = FALSE,          # Hides raw p-values
          show.stat = FALSE,        # Keeps test statistics (optional)
          show.icc = TRUE,         # Shows ICC
          show.re.var = TRUE,      # Shows random effects
          show.ngroups = TRUE,     # Shows number of districts
          dv.labels = c("Test Score(1)", "Test Score(2)", "Test Score(3)"),
          title = "Multilevel Model Results: SES and Achievement",
          p.style = "stars")       # Replaces p-values with asterisks
