# nh-estimates

A project examining the relationship between anonymity, privacy, and prevalence estimates of sensitive identities. Specifically, we examined non-heterosexual (nh) estimates of sexual orientation in large US surveys.

## Instructions

All data and code are available in the public folder. To use them, pull or download this repo, enter the public folder, and open the Rproj. This should open RStudio with the right filepaths and all you'd need to do from there on out is run the scripts or tinker with them as you see fit. Below are descriptions of the scripts and what they do.

## Estimates Data

- `prevalence_estimates.tsv` 
    + Estimates by survey and response label in tab-separated format, basis for table 1 in paper.
- `estimates_cohens_d.R` 
    + Cohen's D test comparing interviewer- vs self-administered survey mode estimates.
- `estimates_comparisons.R`
    + Calculate correlation between prevalence estimates and comfort level
    + Generate Figure 1 - Prevalence Estimate by Survey Mode
- `estimates_gss.R`
    + Calculate weighted difference in prevalence esimtates by survey mode within the GSS 2014
- `estimates_epstein.R`
    + Subset original Epstein 2012 dataset to calculate prevalence estimate breakdowns. Saves to 

---

## Survey Data

Our survey data are available in this repository with minor changes to protect subjects privacy.

### Clean and format data

- `survey_anonymize_data.R` 
    + Remove personally identifiable information, report age only in ranges, and removed the time and date the survey was taken to make it harder for identifications to be made while retaining enough information to replicate our results. To protect the privacy of subjects, the raw data input for this script are not publicly available. However, the output data file, `anon_raw_data.Rda`, is.
- `survey_format_data.R`
    + Format variable names and level orderings
    + Outputs `survey_data.Rda` which is used in all analysis scripts below.

### Analyze data

- `survey_demographics.R`
    + Generate demographics table
- `survey_comfort_level_by_data.R` 
    + Generate comfort level mean and se by anonymity and survey mode.
    + Generate Fig 2 - "Mean Comfort Level by Anonymity and Survey Mode"
- `survey_comfort_level_comparisons.R` 
    + Generate comfort level descriptives by demographic groups
    + Conduct paired comfort level wilcox comparisons: interviewer-self, anon-nonanon, computer-saq, computer-acasi, computer-online.
- `survey_regression.R`
    + The logistic regressions and diagnostics conducted for mode types by comfort level.
 