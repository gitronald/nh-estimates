# Anonymize raw data

# Load raw data
survey = read.table("data/raw_data.tsv", sep = "\t", header = T, stringsAsFactors = FALSE)
survey[is.na(survey)] = 'Unknown'

# Drop identifying information, time and date of submission, and group age to obfuscate subject identity

# Age - Split continuous variable into factor bins
survey$ageFactors <- cut(survey$age, c(18, 24, 44, 64, Inf), 
                         include.lowest = TRUE, 
                         labels = c("18-24", "25-44", "45-64", "65+"), 
                         ordered_result = TRUE)

# Record mean and sd
age_mean = list('mean'=round(mean(survey$age), 2), 'sd' = round(sd(survey$age), 2))
write.csv(age_mean, 'data/age_mean.csv', row.names = F)


drop_list = c('name', 'workerID', 'mturkRandomStr', 'OtherCountryofResidence', 
              'report', 'email', 'date', 'time', 'IP', 'age')
survey[, drop_list] = NULL

save(survey, file = "data/raw_data_anon.Rda")
