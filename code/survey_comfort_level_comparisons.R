# Paired comfort level comparisons

load('data/survey_data.Rda')

# Comfort by anon and demographics
# Shape data
library(dtables)
library(dplyr)

describe_demographics = function(mean_var, dem_vars){
  # Create a demographics by mean comfort table with addtl cols for anon/nonanon
  data_list = lapply(dem_vars, function(x) dft(survey[, x], by = mean_var))
  return(do.call(rbind, data_list))
}

non_parametric_tests = function(data1, num_var, group_vars){
  sig_tests = list()
  for(var in group_vars){
    if(length(levels(mydata[[var]])) > 2){
      sig_tests[[var]] = kruskal.test(mydata[[var]], mydata[[num_var]])
    } else{
      levels = levels(mydata[[var]])
      sig_tests[[var]] = wilcox.test(mydata[mydata[[var]] == levels[1], num_var], 
                                     mydata[mydata[[var]] == levels[2], num_var])
      print(names(sig_tests[[var]]))
    }
  }
  # Combine list of stats tests into a dataframe
  df = bind_rows(lapply(sig_tests, tidy))
  
  # Calculate Bonferroni adjustment by number of group tests
  df$p.adj = p.adjust(df$p.value, method = 'bonferroni', n = length(group_vars))
  
  return(df)
}

# Define Demographics
dems <- c("ageFactors", "gender", "race", "degree", "income", "sexorient")

# Calculate comfort by demographics for each mode grouping
all_modes = describe_demographics(survey$Mean_Comfort, dems)
anon_modes = describe_demographics(survey$Mean_Comfort_NoName, dems)
nonanon_modes = describe_demographics(survey$Mean_Comfort_NameReq, dems)

# Table 4
table4 = cbind(all_modes, anon_modes[, 4:6], nonanon_modes[, 4:6])
print(table4)

# Table 4 significance statistics
non_parametric_tests(survey, 'Mean_Comfort', vars)
non_parametric_tests(survey, 'Mean_Comfort_NoName', vars)
non_parametric_tests(survey, 'Mean_Comfort_NameReq', vars)

tidy_wilcox = function(data, var1, var2, alt='greater'){
  # Generate Wilcox test output as dataframe row
  return(tidy(wilcox.test(data[, var1], data[, var2], alternative = alt, paired=T)))
}

library(broom)
comparisons = rbind(
  cbind('compare'='anonymity', tidy_wilcox(survey, 'Anon', 'NonAnon')),
  cbind('compare'='privacy', tidy_wilcox(survey, 'Self', 'Interviewer')),
  cbind('compare'='computer_written', tidy_wilcox(survey, 'CASI', 'SAQ')),
  cbind('compare'='computer_audio', tidy_wilcox(survey, 'ACASI', 'CASI')),
  cbind('compare'='computer_online', tidy_wilcox(survey, 'Online', 'CASI'))
)

print(comparisons)
