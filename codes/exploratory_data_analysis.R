library(ggplot2)
#Figure 1: the distribution of spending
ggplot(seda_avg, aes(x = exp_per_pupil)) +
  geom_histogram(binwidth = 100, fill = "purple", color = "midnightblue", alpha = 0.7) +
  labs(title = "Distribution of Per Pupil Expenditure", x = "Per Pupil Expenditure", y = "Frequency") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5,  size = 14),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12))

#the distribution of log spending
ggplot(seda_avg, aes(x = log_spending)) +
  geom_histogram(binwidth = 0.1, fill = "midnightblue", color = "grey") +
  labs(title = "Distribution of Log Per Pupil Expenditure", x = "Log Per Pupil Expenditure", y = "Frequency") +
  theme_minimal()  +
  theme(plot.title = element_text(hjust = 0.5, size = 14),
                         axis.title.x = element_text(size = 12),
                         axis.title.y = element_text(size = 12))

#Figure 2:  relationship between test score and SES
ggplot(seda_avg, aes(x = sesall, y = weighted_score, group = sedalea)) +
  geom_line(alpha = 0.2) +  # Line for each district
  geom_smooth(se = FALSE, method = "lm", aes(group = 1)) +  # Overall trend line
  labs(title = "Correlation Between Test Score and SES",
       x = "Socioeconomic Status (SES)",
       y = "Weighted Test Score") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    legend.position = "none"  # Hide legend if there are many districts
  )

#Figure 3. ahievement by ses level 

# Left Plot
# Group SES into low, medium, high (already done)
seda_cleaned <- seda_cleaned %>%
  mutate(ses_group = case_when(
    sesall <= -0.3 ~ "low",
    sesall > -0.3 & sesall <= 0.82 ~ "medium",
    sesall > 0.82 ~ "high"
  ))
# Summarize average scores by year and SES group
summary_data <- seda_cleaned %>%
  group_by(year, ses_group) %>%
  summarize(avg_score = mean(weighted_score, na.rm = TRUE), .groups = "drop")

ggplot(summary_data, aes(x = year, y = avg_score, color = ses_group, group = ses_group)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  labs(title = "Average Test Score Over Time by SES Level",
       x = "Year",
       y = "Average Weighted Test Score",
       color = "SES Group") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14))

#Right Plot. test score vs log spending by SES

# Create SES group using defined cutoffs
seda_cleaned <- seda_cleaned %>%
  mutate(ses_group = case_when(
    sesall <= -0.3 ~ "low",
    sesall > -0.3 & sesall <= 0.82 ~ "medium",
    sesall > 0.82 ~ "high"
  ))
# Scatterplot with linear trend lines by SES group
ggplot(seda_cleaned, aes(x = log_spending, y = weighted_score, color = ses_group)) +
  geom_point(alpha = 0.4, size = 1) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  labs(title = "Test Score vs. Log Spending by SES Group",
       x = "Log Expenditure Per-Pupil",
       y = "Weighted Test Score",
       color = "SES Group") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14))
