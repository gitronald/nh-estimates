library(foreign)
library(IPtoCountry)
library(dtables)
library(stringr)

# Private to public data
# epstein = read.spss("../raw-data/ESOI SPSS ver n=17785 5-08_2.sav", to.data.frame=T)
# epstein = epstein[, c("age", "orientat", "country")]
# save(epstein, file='data/epstein2012.Rda')

# Load public data
load('data/epstein2012.Rda')
epstein = epstein[grepl("United States|Apple Computer", epstein$country),]
epstein = epstein[epstein["age"] > 17, ]

tab = dft(epstein$orientat); tab
write.table(tab, file='data/estimate_epstein.tsv', sep='\t', row.names=F)