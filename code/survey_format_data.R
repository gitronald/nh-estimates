# Format data

# Load data
load("data/raw_data_anon.Rda")

# Manual rearrange variables for demographics table
# Gender
GenderLevels <- c("Male", "Female") # Manual rearrange
survey[["gender"]] <- factor(survey[["gender"]], levels = GenderLevels)

# Race / Ethnicity
EthnicityLevels <- c("White", "Black", "Hispanic", "Asian", "American Indian", "Other", "Unknown") # Manual rearrange
survey[["race"]] <- factor(survey[["race"]], levels = EthnicityLevels)

# Education
dput(levels(survey[["degree"]])) # Obtain factor levels
EducationLevels <- c("None", "High School", "Associates", "College", "Masters", "Doctorate", "Unknown") # Manual rearrange
survey[["degree"]] <- factor(survey[["degree"]], levels = EducationLevels, ordered = TRUE)

# Income
IncomeLevels <- c("Under $10,000", "$10,000 to $14,999", "$15,000 to $19,999", "$20,000 to $29,999", 
                  "$30,000 to $39,999", "$40,000 to $49,999", "$50,000 to $74,999", "$75,000 to $99,999", 
                  "$100,000 to $149,999", "$150,000 and over","I prefer not to say", "Unknown")
survey[["income"]] <- factor(survey[["income"]], levels = IncomeLevels, ordered = TRUE)

# Sexual Orientation
SexOrientLevels <- c("Straight", "Bisexual", "Gay", "Other", "Unsure") # Manual rearrange
survey[["sexorient"]] <- factor(survey[["sexorient"]], levels = SexOrientLevels)

# Remove factor name vectors
rm(GenderLevels, EducationLevels, EthnicityLevels, IncomeLevels, SexOrientLevels)

# Combine vars by survey mode characteristics
anon_vars = c("Online", "CASI", "ACASI", "SAQ", "CATI", "CAPI", "CAPIvideoRec", "FaceToFace")
nonanon_vars = c("OnlineNameReq", "CASInameReq", "ACASInameReq", 
                 "SAQnameReq", "CATInameReq", "CAPInameReq", 
                 "CAPIvideoRecNameReq", "FaceToFaceNameReq")
self_vars = c("Online", "CASI", "ACASI", "SAQ", "OnlineNameReq", 
              "CASInameReq", "ACASInameReq", "SAQnameReq")
interviewer_vars = c("CAPI", "CATI", "CAPIvideoRec", "FaceToFace", "CAPInameReq", 
                     "CATInameReq", "CAPIvideoRecNameReq", "FaceToFaceNameReq")

# Create averages for each survey mode characteristic
survey[["Anon"]] <- rowSums(survey[, anon_vars]) / 8
survey[["NonAnon"]] <- rowSums(survey[, nonanon_vars]) / 8
survey[["Self"]] <- rowSums(survey[, self_vars]) / 8
survey[["Interviewer"]] <- rowSums(survey[, interviewer_vars]) / 8

# Save data
save(survey, file = 'data/survey_data.Rda')

