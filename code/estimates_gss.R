
# GSS data and calculations
library(foreign)
library(weights)

# # Download data
# fp = "http://publicdata.norc.org:41000/gss/documents//OTHR/2014_spss.zip"
# download.file(fp, "2014_spss.zip", mode = "wb")
# gss2014 <- read.spss(unzip("2014_spss.zip", "GSS2014.sav"))
# 
# # Load raw data
# fp = "raw-data/GSS2014.sav"
# gss2014 = read.spss(fp, to.data.frame = T)
# 
# # Remove NA
# gss2014 = gss2014[-c(which(is.na(gss2014$mode))), ]
# 
# # Save
# save(gss2014, file='data/gss2014.Rda')

# Load data
load('data/gss2014.Rda')

weighted_sexorient = function(gss2014=gss2014, mode){
  
  # Remove survey admin errors
  gss2014 = subset(gss2014, SEXORNT != "IAP") 
  
  # Filter by mode
  sexor = gss2014$SEXORNT[(gss2014$mode %in% mode)]
  weight = gss2014$wtssnr[(gss2014$mode %in% mode)]
  
  # Construct table
  wt_table = data.frame('estimate' = wpct(sexor, weight, na.rm=T), 
                        'cumsum' = cumsum(wpct(sexor, weight, na.rm=T)),
                        'n' = wtd.table(sexor, weight, na.rm=T)$sum.of.weights)
  return(wt_table)
}

# CASI AND CATI data
casi = weighted_sexorient(gss2014, mode='IN-PERSON')
cati = weighted_sexorient(gss2014, mode='OVER THE PHONE')
all = weighted_sexorient(gss2014, mode=c('IN-PERSON','OVER THE PHONE'))

# Prop test - non-heteros = success, total = trials
success = c(sum(casi$n[1:2]), sum(cati$n[1:2]))
trials = c(sum(casi), sum(cati))

prop.test(success, trials)

