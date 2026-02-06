# =========================================================
# CONSUMER PROJECT
# =========================================================
# Inputs needed:
# 1) Clean CSV exported from SPSS (your filtered/clean dataset)
# Required columns in CSV:
#   condition (1/2/3),
#   Fatigue_score, Satisfaction_score, Intention_score,
#   Decision_Time
# =========================================================

# 0) Packages 
library(dplyr)
library(tidyr)
library(ggplot2)



#  2) Read data
# CHANGE ONLY THIS PATH:
df <- read.csv("/Users/elifparildar/Desktop/project_final_clean.csv")

# Quick check
cat("Rows:", nrow(df), "| Cols:", ncol(df), "\n")

#  3) Keep only what we need (clean dataset for analysis/figures) 
needed_cols <- c("condition", "Fatigue_score", "Satisfaction_score", "Intention_score", "Decision_Time")
missing_cols <- setdiff(needed_cols, names(df))
if (length(missing_cols) > 0) {
  stop(paste("These required columns are missing in your CSV:", paste(missing_cols, collapse = ", ")))
}

df_clean <- df %>%
  select(all_of(needed_cols)) %>%
  mutate(
    # ensure numeric
    Fatigue_score = as.numeric(Fatigue_score),
    Satisfaction_score = as.numeric(Satisfaction_score),
    Intention_score = as.numeric(Intention_score),
    Decision_Time = as.numeric(Decision_Time)
  )

#  4) Condition labels (1=A, 2=B, 3=C) 
#  1=A (High Choice), 2=B (High Choice + Popular), 3=C (Low Choice)
df_clean <- df_clean %>%
  mutate(
    condition = factor(
      condition,
      levels = c(1, 2, 3),
      labels = c("High Choice", "High Choice + Popular", "Low Choice")
    )
  )

# Check group sizes
cat("\nGroup counts:\n")
print(table(df_clean$condition))

#  5) Create log-transformed decision time 
# +1 prevents log(0) problems 
df_clean <- df_clean %>%
  mutate(
    log_decision_time = log(Decision_Time + 1)
  )

# 6) Long format for 3 outcomes (for the main figure) 
df_long <- df_clean %>%
  pivot_longer(
    cols = c(Fatigue_score, Satisfaction_score, Intention_score),
    names_to = "Outcome",
    values_to = "Score"
  ) %>%
  mutate(
    Outcome = recode(
      Outcome,
      "Fatigue_score" = "Decision Fatigue",
      "Satisfaction_score" = "Decision Satisfaction",
      "Intention_score" = "Purchase Intention"
    )
  )

#  7) FIGURE 1: Main outcomes (Mean ± SE) 
p_main <- ggplot(df_long, aes(x = condition, y = Score, fill = condition)) +
  stat_summary(fun = mean, geom = "bar", alpha = 0.85) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.18) +
  facet_wrap(~ Outcome, scales = "free_y") +
  labs(
    title = "Effects of Choice Condition on Decision Outcomes",
    x = "Condition",
    y = "Mean (± SE)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold")
  )

print(p_main)

ggsave("Figure1_Main_Outcomes.png", p_main, width = 11, height = 5.5, dpi = 300)
ggsave("Figure1_Main_Outcomes.pdf", p_main, width = 11, height = 5.5)

#  8) FIGURE 2: Decision time (log-transformed)
p_time <- ggplot(df_clean, aes(x = condition, y = log_decision_time, fill = condition)) +
  geom_boxplot(alpha = 0.75, outlier.alpha = 0.6) +
  labs(
    title = "Log-Transformed Decision Time Across Conditions",
    x = "Condition",
    y = "Log(Decision Time + 1)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold")
  )

print(p_time)

ggsave("Figure2_DecisionTime_Log.png", p_time, width = 7.5, height = 5, dpi = 300)
ggsave("Figure2_DecisionTime_Log.pdf", p_time, width = 7.5, height = 5)

#9) TABLE 1: Descriptives by condition (Mean & SD)
table_desc <- df_clean %>%
  group_by(condition) %>%
  summarise(
    n = n(),
    Fatigue_M = mean(Fatigue_score, na.rm = TRUE),
    Fatigue_SD = sd(Fatigue_score, na.rm = TRUE),
    Satisfaction_M = mean(Satisfaction_score, na.rm = TRUE),
    Satisfaction_SD = sd(Satisfaction_score, na.rm = TRUE),
    Intention_M = mean(Intention_score, na.rm = TRUE),
    Intention_SD = sd(Intention_score, na.rm = TRUE),
    DecisionTime_M = mean(Decision_Time, na.rm = TRUE),
    DecisionTime_SD = sd(Decision_Time, na.rm = TRUE),
    .groups = "drop"
  )

cat("\nTable 1 — Descriptives by condition:\n")
print(table_desc)

write.csv(table_desc, "Table1_Descriptives_ByCondition.csv", row.names = FALSE)

# ---------- 10) Save cleaned analysis dataset too (nice for reproducibility) ----------
write.csv(df_clean, "AnalysisDataset_df_clean.csv", row.names = FALSE)

cat("\n✅ DONE. Files created in:\n", getwd(), "\n")
cat(" - Figure1_Main_Outcomes.(png/pdf)\n")
cat(" - Figure2_DecisionTime_Log.(png/pdf)\n")
cat(" - Table1_Descriptives_ByCondition.csv\n")
cat(" - AnalysisDataset_df_clean.csv\n")



