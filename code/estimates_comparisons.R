# Calculate correlation between prevalence estimates and comfort level

library(dtables)
library(reshape2)
library(broom)

# Load data
load('data/comfort_by_mode.Rda')
estimates = read.table("data/prevalence_estimates.tsv", sep = "\t", header = T)

# Subset 'best' estimates from paper
subset = c("NESARC", "NHIS", "NISVS", "NHANES", "GSS", "NSSHB")
estimates_best = subset(estimates, survey %in% subset)

# Get mean comfort by mode
comfort_anon = subset(comfort_by_mode, type=='Anonymous')
comfort_nonanon = subset(comfort_by_mode, type=='Non-anonymous')
comfort_avg = dft(comfort_by_mode$mode, by=comfort_by_mode$mean)

estimates_best = merge(estimates_best, comfort_avg, by='mode')
estimates_best$mode = factor(estimates_best$mode, 
                             levels = estimates_best[order(estimates_best$estimate), "mode"],
                             ordered = T)

# Spearmans correlation between estimates and mean comfort
tidy(cor.test(estimates_best$estimate, estimates_best$mean, 
              method = "spearman", alternative = 'greater'))


# Fig 1 - Prevalence Estimate by Survey Mode ------------------------------

# Order survey mode by estimate size
estimates_best$mode = factor(estimates_best$mode, 
                             levels = estimates_best[order(estimates_best$estimate), "mode"],
                             ordered = T)

# Shape data by mode and explicit nh labels
melt = melt(estimates_best[, c("mode", "gay", "bisexual", "other")], 
            id.vars = "mode")

# Fig 1 - Prevalence Estimate by Survey Mode
p = ggplot(melt, aes(x = mode, y = value, group = variable, fill = variable)) +
  geom_bar(stat="identity") +
  scale_y_continuous(name = "Prevalence Estimate", labels = scales::percent, 
                     expand = c(0,0), limits=c(0, 0.075)) +
  scale_x_discrete(name = "Survey Mode") +
  theme_bw(base_size = 11) +
  scale_fill_grey(start = 0, end = .8,
                  name=NULL,
                  labels=c("Gay/Homosexual", "Bisexual", "Other/Something Else")) +
  theme_bw(base_size = 12) +
  theme(legend.title = element_blank(),
        legend.background = element_blank(),
        plot.title = element_text(hjust=0.5),
        axis.ticks.x = element_blank(),
        legend.position = c(0.20, 0.88),
        # axis.title.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.border = element_blank()) +
  geom_vline(xintercept = 0.5, color = 'black') + 
  geom_hline(yintercept = 0, color = 'black') + 
  ggtitle(label = "Prevalence Estimate by Survey Mode")

# Save plot
pdf('fig1-estimates.pdf', 5.8, 3.6)
p
dev.off()
