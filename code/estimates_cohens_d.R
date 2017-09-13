
# Cohen's D ---------------------------------------------------------------

estimates = read.csv('data/prevalence_estimates.tsv', sep='\t')

interviewer_means = estimates[estimates$survey %in% c('NESARC', 'NHIS', 'NISVS'), 'estimate']
self_means = estimates[estimates$survey %in% c('GSS', 'NHANES', 'NSSHB'), 'estimate']

# Unequal variance

cohenD_unequal_variance = function(x, y) {
  # Bonnet (2008) correction for unequal variances
  # https://www.ncbi.nlm.nih.gov/pubmed/18557680
  # https://stats.stackexchange.com/questions/210352/do-cohens-d-and-hedges-g-apply-to-the-welch-t-test
  #
  # if(mean(y) > mean(x)){
  #   z = x
  #   x = y
  #   y = x
  # }

  mean_diff = mean(x) - mean(y)

  x_sd = sd(x)
  y_sd = sd(y)
  
  x_df = length(x) - 1
  y_df = length(y) - 1
  
  avg_sd = sqrt(x_sd^2 + y_sd^2 / 2)
  
  d = mean_diff/avg_sd
  
  d_var = d^2 / 8*(avg_sd)^4 * ( (x_sd^4 / x_df) + (y_sd^4 / y_df) ) + ( (x_sd^2 / avg_sd^2) / x_df ) + ( (y_sd^2 / avg_sd^2) / y_df )
  
  d_ci = 1.96*sqrt(d_var)
  
  return(unlist(c('d' = d, 'var' = d_var, 'ci' = list(d + d_ci, d - d_ci))))
}

# Self-administered vs. interviewer administered estimates
print(cohenD_unequal_variance(self_means, interviewer_means))
print(t.test(self_means, interviewer_means))


