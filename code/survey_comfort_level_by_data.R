# Create comfort by mode and anonymity descriptive stats for Fig 2

# Load data
load('data/survey_data.Rda')

library(dplyr)
library(reshape2)

# Aggregate variable names
anon_vars = c("Online", "CASI", "ACASI", 
              "SAQ", "CATI", "CAPI", 
              "CAPIvideoRec", "FaceToFace")
nonanon_vars = c("OnlineNameReq", "CASInameReq", "ACASInameReq", 
                 "SAQnameReq", "CATInameReq", "CAPInameReq", 
                 "CAPIvideoRecNameReq", "FaceToFaceNameReq")

# Shape data
comfort_by_mode = survey %>%
  select(anon_vars, nonanon_vars) %>%
  summarise_all(funs(mean=mean, se=sd(.)/sqrt(n())))

comfort_by_mode = data.frame(t(comfort_by_mode))
comfort_by_mode$mode = gsub("_.*", '', row.names(comfort_by_mode))
comfort_by_mode$anon = ifelse(grepl('NameReq', comfort_by_mode$mode, ignore.case = T), 
                              "Non-anonymous", "Anonymous")
comfort_by_mode$mode = gsub("namereq", '', comfort_by_mode$mode, ignore.case = T)
comfort_by_mode$type = unlist(lapply(row.names(comfort_by_mode), function(x) strsplit(x, '_')[[1]][2]))
names(comfort_by_mode) = c('value', 'mode', 'type', 'anon')

comfort_by_mode$mode = gsub("namereq", '', comfort_by_mode$mode, ignore.case = T)
comfort_by_mode = dcast(data=comfort_by_mode, formula = mode + type ~ anon, value.var = 'value')
comfort_by_mode$mode = factor(comfort_by_mode$mode,
                              levels = c('CAPIvideoRec','CATI','FaceToFace','CAPI',
                                         'SAQ','ACASI','CASI','Online'),
                              labels = c('CAPI-VR','CATI','FTF','CAPI',
                                         'SAQ','ACASI','CASI','Online'),
                              ordered=T)

# Save data for use in `estimates`
save(comfort_by_mode, file='comfort_by_mode.Rda')

# Generate Fig 2 - Mean Comfort Level by Anonymity and Survey Mode --------

# Plot data
library(ggplot2)
p = ggplot(comfort_by_mode, 
           aes(x=mode, y=mean, group=type, fill=type,
               ymin=mean-se*1.96, ymax=mean+se*1.96)) +
  geom_bar(stat='identity', width=0.8, position='dodge') +
  geom_errorbar(width = 0.28, position=position_dodge(0.8)) +
  scale_y_continuous(name = 'Mean Comfort Level', breaks = seq(-3, 5, 1)) + 
  scale_x_discrete(name = "Survey Mode") + 
  scale_fill_grey() + 
  ggtitle('Mean Comfort Level by Anonymity and Survey Mode') +
  geom_hline(yintercept = 0, color = 'black') + 
  geom_vline(xintercept = 0.5, color = 'black') + 
  theme_bw(base_size = 12) +
  theme(legend.title = element_blank(),
        legend.background = element_blank(),
        plot.title = element_text(hjust=0.5),
        axis.ticks.x = element_blank(),
        legend.position = c(0.15, 0.88),
        panel.grid.major.x = element_blank(),
        panel.border = element_blank())


# Save plot
pdf('fig2-comfortlevels.pdf', 7, 4)
p
dev.off()

