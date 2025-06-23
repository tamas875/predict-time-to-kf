# Clean and prepare the validation data from Groningen
library(foreign)
val_data_umcg = read.csv("/Users/t.szili-torok/Library/CloudStorage/OneDrive-UMCG/data/CKD_NL/umcg/collected_data/validation_umcg_filled.csv")
hb_data = read.spss('/Users/t.szili-torok/Library/CloudStorage/OneDrive-UMCG/data/CKD_NL/umcg/baseline_UMCG.sav', to.data.frame = TRUE)[c('ID_UMCG', 'Hbmmolperliter')]
val_data_umcg = merge(val_data_umcg, hb_data, by = 'ID_UMCG')
val_data_umcg$lower = as.numeric((as.Date(val_data_umcg$NIERVERV_THR_DAT) - as.Date(val_data_umcg$INCL_DAT)) / 30.4167)
val_data_umcg$censored = as.character(as.numeric((as.Date(val_data_umcg$DAT_CENS) - as.Date(val_data_umcg$INCL_DAT)) / 30.4167))
val_data_umcg$time_to_mort = as.character(as.numeric((as.Date(val_data_umcg$DAT_OVERLIJDEN) - as.Date(val_data_umcg$INCL_DAT)) / 30.4167))
val_data_umcg$censored = ifelse(val_data_umcg$NIERVERV_THR_DAT == "" & is.na(val_data_umcg$censored), val_data_umcg$time_to_mort, val_data_umcg$censored)
val_data_umcg$upper = val_data_umcg$lower
val_data_umcg$upper[which(is.na(val_data_umcg$upper))] = Inf
val_data_umcg$lower[which(is.na(val_data_umcg$lower))] = val_data_umcg$censored[which(is.na(val_data_umcg$lower))]

val_data_umcg$age = as.numeric(floor((as.Date(val_data_umcg$INCL_DAT) - as.Date(val_data_umcg$gebdat)) / 365.25))
val_data_umcg$bmi = round(val_data_umcg$GEWICHT / (val_data_umcg$LENGTE / 100)^2, 2)
val_data_umcg$female = ifelse(val_data_umcg$GESLACHT == 1, 1, 0)
val_data_umcg$Epi1 = EGFR(creat = val_data_umcg$creatininebloed, 
                          female = val_data_umcg$female, 
                          age = val_data_umcg$age, 
                          creat.unit = "umol/l", 
                          equation = "ckd_epi_2009_raceless")

val_data_umcg$esrd_lower = val_data_umcg$lower
val_data_umcg$esrd_upper = val_data_umcg$upper

val_data_umcg = val_data_umcg[which(val_data_umcg$lower > 0),]


write.csv(val_data_umcg[c('ID_UMCG','Epi1', 'Proteinurieurine', 'Fosfaat', 'bmi', 'Hbmmolperliter', 'Calciumbloed', 'totaalcholesterol', 'age', 'esrd_lower', 'esrd_upper')], 
          "/Users/t.szili-torok/Library/CloudStorage/OneDrive-UMCG/data/CKD_NL/umcg/studies/ESKD-Predict/international_validation_umcg.csv", 
          row.names = FALSE)





