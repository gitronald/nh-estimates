# Regressions requested by reviewers in Revision 1
# Load data
load('data/survey_data.Rda')

# Logistic Regression -----------------------------------------------------

# Combine low n factors
survey$ageFactors2 = survey$ageFactors
levels(survey$ageFactors2)[levels(survey$ageFactors2) == "65+"] = "45-64"
survey$sexorient2 = survey$sexorient
levels(survey$sexorient2)[levels(survey$sexorient2) == "Unsure"] = "Other"

print(dft(survey$ageFactors2))
print(dft(survey$sexorient2))

# Create prediction (binary) variables
survey$comfortNonAnon = ifelse(survey$NonAnon > 0, 1, 0)
survey$comfortAnon = ifelse(survey$Anon > 0, 1, 0)
survey$comfortSelf = ifelse(survey$Self > 0, 1, 0)
survey$comfortInterviewer = ifelse(survey$Interviewer > 0, 1, 0)

# Model: Non-anonymous comfort by age, gender, orient
fit1 = glm(comfortNonAnon ~ factor(ageFactors2) + factor(gender) + factor(sexorient2), 
           data = survey, family = "binomial")
#summary(fit1)

# Model: Anonymous comfort by age, gender, orient
fit2 = glm(comfortAnon ~ factor(ageFactors2) + factor(gender) + factor(sexorient2), 
           data = survey, family = "binomial")
#summary(fit2)

# Model: Self-admistered comfort by age, gender, orient
fit3 = glm(comfortSelf ~ factor(ageFactors2) + factor(gender) + factor(sexorient2), 
           data = survey, family = "binomial")
#summary(fit3)

# Model: Interviewer-admistered comfort by age, gender, orient
fit4 = glm(comfortInterviewer ~ factor(ageFactors2) + factor(gender) + factor(sexorient2), 
           data = survey, family = "binomial")
#summary(fit4)


# Model Diagnostics -------------------------------------------------------

library(ResourceSelection)
library(ggplot2)

deviance_residual_plot = function(fit){
  fig = ggplot(data.frame(fitted(fit), resid(fit)), aes(fitted(fit), resid(fit))) + 
    geom_point(shape=1) + geom_smooth(se = FALSE) + 
    xlab("Estimated Probability") + ylab("Devaince Residual")
  return(fig)
}

dispersion = function(fit){
  chisq = sum(residuals(fit, type = "pearson")^2)
  n = nrow(fit$data)
  p = ncol(fit$data[-1])
  d = chisq / (n - p)
  return(d)
}

## Deviance plots
deviance_residual_plot(fit1)
deviance_residual_plot(fit4)

## Hoslem-Lemeshow goodness of fit tests
y = as.numeric(as.character(survey$comfortNonAnon))
HL = hoslem.test(y, fitted(fit1), g=5)
HL

y = as.numeric(as.character(survey$comfortInterviewer))
HL = hoslem.test(y, fitted(fit4), g=5)
HL

# Dispersion correction and odds ratios
fit_modified = fit1
fit_modified$coefficients = fit_modified$coefficients * sqrt(dispersion(fit1))
odds = exp(cbind(OR = coef(fit_modified), confint(fit_modified, level = 0.95)))
odds

fit_modified = fit4
fit_modified$coefficients = fit_modified$coefficients * sqrt(dispersion(fit4))
odds = exp(cbind(OR = coef(fit_modified), confint(fit_modified, level = 0.95)))
odds
