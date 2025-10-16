# Merge training data with sex and the secondary outcome

library(foreign)
ckd_nl = read.csv('/Users/t.szili-torok/Library/CloudStorage/OneDrive-UMCG/data/CKD_NL/umcg/collected_data/validation_umcg_filled.csv',
                  row.names = 1)
ckd_nl$DAT_OVERLIJDEN = as.Date(ckd_nl$DAT_OVERLIJDEN)
ckd_nl$NIERVERV_THR_DAT = as.Date(ckd_nl$NIERVERV_THR_DAT)
ckd_nl$mortality = ifelse(!is.na(ckd_nl$DAT_OVERLIJDEN) & ((ckd_nl$DAT_OVERLIJDEN < ckd_nl$NIERVERV_THR_DAT) | is.na(ckd_nl$NIERVERV_THR_DAT)), 1, 0)
ckd_nl$time_to_mortality = ifelse((ckd_nl$NIERVERV_THR_DAT < ckd_nl$DAT_OVERLIJDEN) | is.na(ckd_nl$DAT_OVERLIJDEN), as.character(ckd_nl$NIERVERV_THR_DAT), as.character(ckd_nl$DAT_OVERLIJDEN))
ckd_nl$time_to_mortality = ifelse(!is.na(ckd_nl$DAT_OVERLIJDEN) & is.na(ckd_nl$NIERVERV_THR_DAT), as.character(ckd_nl$DAT_OVERLIJDEN), ckd_nl$time_to_mortality)
ckd_nl$time_to_mortality[which(is.na(ckd_nl$time_to_mortality))] = as.character(ckd_nl$DAT_CENS[which(is.na(ckd_nl$time_to_mortality))])

ckd_nl$time_to_mortality_data = ckd_nl$time_to_mortality
ckd_nl$time_to_mortality = round(as.numeric(((as.Date(ckd_nl$time_to_mortality) - as.Date(ckd_nl$INCL_DAT)) / 365.25) * 12), 1)

ckd_nl_raw = read.spss('/Users/t.szili-torok/Library/CloudStorage/OneDrive-UMCG/data/CKD_NL/umcg/baseline_UMCG.sav', to.data.frame = TRUE)
ckd_nl_raw = ckd_nl_raw[c('ID_UMCG', 'PRIM_DIAG_NF')]
# glomerular disease is 10 19 11 99 12 14 15 13 16 17 50 70 74 73 86 84 85 87 78
glomerular_disease = c(10, 19, 11, 99, 12, 14, 15, 13, 16, 17, 50, 70, 74, 73, 86, 84, 85, 87, 78)
ckd_nl_raw$GLOM_DISEASE = NA
ckd_nl_raw[which(ckd_nl_raw$PRIM_DIAG_NF %in% glomerular_disease), 'GLOM_DISEASE'] = 1
ckd_nl_raw[which(!(ckd_nl_raw$PRIM_DIAG_NF %in% glomerular_disease) & !is.na(ckd_nl_raw$PRIM_DIAG_NF)), 'GLOM_DISEASE'] = 0
ckd_nl = merge(ckd_nl, ckd_nl_raw, by = 'ID_UMCG')
# 1 is female, checked by EPIC
ckd_nl = ckd_nl[c('ID_UMCG', 'GESLACHT', 'GLOM_DISEASE', 'DAT_OVERLIJDEN', 'NIERVERV_THR_DAT', 'DAT_CENS', 'time_to_mortality_data', 'time_to_mortality', 'mortality')]
write.csv(ckd_nl, '/Users/t.szili-torok/Library/CloudStorage/OneDrive-UMCG/data/CKD_NL/umcg/studies/ESKD-Predict/data_incl_extra_information.csv', row.names = FALSE)
