# Consumer Decision Fatigue in Online Choice

## Overview
This project investigates how **choice overload** and **popularity cues** (e.g., a “Popular Choice” label) influence **consumer decision fatigue**, **decision time**, **decision satisfaction**, and **purchase intention** in an online shopping context.

The study is grounded in research on **choice overload** and **decision paralysis**, and examines how small elements of **choice architecture** can reduce mental effort during digital decision-making.

---

## Research Question
How do the **number of available options** and the presence of a **popularity cue** affect decision fatigue and related consumer outcomes during online purchase decisions?

---

## Method

### Design
- Between-subjects experimental online survey (Qualtrics)
- Random assignment to one of three conditions (headphone choice scenario):
  1. **High Choice** (many options)
  2. **High Choice + Popularity Cue** (many options + “Popular Choice” label)
  3. **Low Choice** (few options)

### Participants
- **N = 63** (online voluntary sample)
- Data cleaning included removal of incomplete responses and attention-check failures
- Final distribution was approximately balanced across conditions (≈20–22 per group)

### Measures
- **Decision Fatigue**, **Decision Satisfaction**, **Purchase Intention** (Likert-type scales; mean scores computed per scale)
- **Decision Time** (behavioral measure recorded by Qualtrics: seconds spent on the selection page)

---

## Analysis

### Software and Workflow
- **SPSS (primary analyses):** descriptive statistics and ANOVA-based group comparisons
- **R (visualization):** plotting and distribution checks; decision-time was log-transformed for clearer visualization due to positive skew
- **Python (exploratory extension):** multiclass logistic regression to examine whether fatigue/satisfaction/purchase intention/time patterns can differentiate conditions (exploratory predictive analysis)

> Note: The primary statistical conclusions are based on the SPSS analyses. The Python model is included as an exploratory extension.

---

## Data
The dataset consists of anonymized participant responses collected via an online survey platform.

Due to ethical considerations and participant privacy, the **raw dataset is not publicly shared**.  
However, **variable definitions** and **analysis scripts/syntax** are provided to support transparency and reproducibility.

---

## Repository Structure (Suggested)
- `analysis/spss_analysis.sps` — SPSS syntax (descriptives + ANOVA workflow)
- `analysis/consumer_project.R` — R visualizations (incl. log-time plots)
- `analysis/python_exploratory_model.py` — exploratory multiclass logistic regression (optional)
- `documentation/variable_dictionary.md` — variable definitions / coding notes

---

## Key Results (Summary)
- **Choice overload pattern:** participants in the **High Choice** condition showed the highest decision fatigue, while **Low Choice** showed the lowest.
- **Popularity cue effect:** adding a **“Popular Choice”** label in the high-choice set was associated with **lower fatigue** and **more efficient decision behavior** compared to High Choice alone.
- Overall, findings suggest that **more options are not always better**, and **simple cues** can help reduce cognitive burden in online shopping environments.

---
