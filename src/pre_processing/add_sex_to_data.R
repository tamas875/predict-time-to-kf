# Merge training data with sex

library(foreign)
ckd_nl = read.csv('/Users/t.szili-torok/Library/CloudStorage/OneDrive-UMCG/data/CKD_NL/umcg/collected_data/validation_umcg_filled.csv',
                  row.names = 1)
# 1 is female, checked by EPIC
ckd_nl = ckd_nl[c('ID_UMCG', 'GESLACHT')]
write.csv(ckd_nl, '/Users/t.szili-torok/Library/CloudStorage/OneDrive-UMCG/data/CKD_NL/umcg/studies/ESKD-Predict/data_incl_sex.csv', row.names = FALSE)
