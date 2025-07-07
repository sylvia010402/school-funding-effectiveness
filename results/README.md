# Model Outputs

This directory contains the visualizations and model outputs. Detailed analysis see in [final report](../docs/final_report.pdf)

# Multilevel Model Results

## Effects of SES and Spending on Student Achievement

| Variable | Model 1 | Model 2 | Model 3 |
|----------|---------|---------|---------|
| **sesall** (Within-District SES) | 0.683*** | -0.0004 | 0.020 |
| | (0.008) | (0.015) | (0.015) |
| **ses_mean** (Between-District SES) | | 0.999*** | -2.041*** |
| | | (0.017) | (0.197) |
| **log_spending** (Per-Pupil Expenditure) | | 0.085*** | -0.016 |
| | | (0.022) | (0.023) |
| **ses_mean:log_spending** (Interaction) | | | 0.320*** |
| | | | (0.021) |
| **Constant** | 5.273*** | 4.409*** | 5.339*** |
| | (0.009) | (0.205) | (0.212) |
| | | | |
| **Observations** | 51,152 | 51,152 | 51,152 |
| **Log Likelihood** | -53,497.020 | -51,824.000 | -51,708.550 |
| **AIC** | 107,002.000 | 103,660.000 | 103,431.100 |
| **BIC** | 107,037.400 | 103,713.100 | 103,493.000 |

*Note: Standard errors in parentheses. \*p<0.1; \*\*p<0.05; \*\*\*p<0.01*

---

## Model Interpretation

### Model 1: Baseline SES Effects
- **Within-district SES changes** have a strong positive effect (β = 0.683)
- High ICC suggests most variation occurs **between districts** rather than over time

### Model 2: Adding Between-District Effects and Spending
- **Between-district SES** (ses_mean) is the dominant predictor (β = 0.999)
- **Within-district SES** effect disappears when controlling for long-term district characteristics
- **Spending** has a modest positive effect (β = 0.085)

### Model 3: The Critical Interaction
- **Main effects become negative** when interaction is included
- **Positive interaction** (β = 0.320) indicates spending is more effective in high-SES districts
- This is the key policy finding: **spending effectiveness depends on community context**

---

## Key Policy Insights

 **The Interaction Effect Reveals Everything**
- **High-SES districts**: Additional spending yields substantial achievement gains
- **Low-SES districts**: Additional spending has minimal or no effect
- **Implication**: Traditional funding approaches may inadvertently increase inequality

**Model Fit Improvements**
- Model 3 has the best fit (lowest AIC/BIC)
- The interaction term significantly improves explanatory power
- Results are robust across 51,152 district-year observations

**Policy Warning**
The negative main effects in Model 3 don't mean spending hurts achievement—they represent the effect for districts with SES = 0 (average). The interaction shows spending becomes increasingly beneficial as SES rises.

---

*Dependent variable: weighted_score (SEDA Grade Cohort Standardized achievement measure)*
