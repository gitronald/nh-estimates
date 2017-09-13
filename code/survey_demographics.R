# Extract demographics
load('data/survey_data.Rda')

library(psych)

dtable <- function (x, y, round = TRUE) {
  # Demographic Frequencies Table (Factors)
  #  Args: 
  #    x: Object
  #    y: Variable Name
  #
  #First column - Name the demographic from object name
  Demographic <- vector()
  DemoName    <- paste0(y)
  Demographic <- c(DemoName, rep("", (length(table(x[y]))-1)))
  # Second & Third columns - Demographic factors and frequency counts
  dgroup <- x[y]
  dgroup <- data.frame(table(dgroup))
  dgroup <- cbind(Demographic, dgroup)
  #Fourth column - Percent value of frequency count
  if (round) {
    dgroup <- transform(dgroup, Perc = round(prop.table(Freq)*100, digits=1))
  } else {
    dgroup <- transform(dgroup, Perc = prop.table(Freq)*100)
  }
  rownames(dgroup) <- NULL
  return(dgroup)
}

describeList <- function(x, y) {
  # Demographic Frequencies Table (Numerics)
  #  Args: 
  #    x: Object
  #    y: Variable Name
  #
  Data     <- paste0(deparse(substitute(x)))
  Variable <- paste0(y)
  Descript <- describe(x[[y]])
  results  <-cbind(Data, Variable, Descript)
  return(results)
}

# DEMOGRAPHICS ------------------------------------------------------------

DemogFactors <- c("ageFactors", "gender", "race", "degree", 
                  "income", "sexorient", "CountryofResidence")
DemogNumeric <- c("fluency")

Dtables  <- do.call(rbind.data.frame, lapply(DemogFactors, dtable, x = survey))
Dnumeric <- do.call(rbind.data.frame, lapply(DemogNumeric, describeList, x = survey))

write.table(Dtables, 'data/demographics.tsv', sep = '\t', row.names = F)
