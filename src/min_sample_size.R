library(pmsampsize)

# Base on Riley et al.https://onlinelibrary.wiley.com/doi/10.1002/sim.9025
cstat_sample_size = function(cstat, prevalence, ci_width=0.10, max_n=100000) {
  target_se = ci_width / (2 * 1.96)
  for (n in 10:max_n) {
    se = sqrt(cstat * (1-cstat) * (1 + (n/2 - 1) * ((1-cstat)/(2-cstat)) + (n/2 - 1) * cstat/(1+cstat)) / (n^2 * prevalence * (1-prevalence)))
    if (se <= target_se) {
      return(data.frame(sample_size=n, expected_events=n*prevalence, cstatistic=cstat, prevalence=prevalence, SE=se, CI_width=2*1.96*se))
    }
  }
}

# Training data
pmsampsize(type = "s", parameters = 15, rate = 0.0569, timepoint = 6, meanfup = 3.1, nagrsquared = 0.15)

# National validation
cstat_sample_size(cstat=0.85, prevalence=0.395)

# International validation
cstat_sample_size(cstat=0.878, prevalence=0.27)
