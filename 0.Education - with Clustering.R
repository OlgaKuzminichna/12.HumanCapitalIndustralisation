#Install and load all required libraries
  install.packages("htmlreg")
  install.packages("textreg")
  install.packages("AER")
  install.packages("ivreg")
  install.packages("foreign")
  install.packages("haven")
  install.packages("magrittr")
  install.packages("htmltools")
  library(AER)
  library(sandwich)
  library(lmtest)
  library(AER)
  library(foreign)
  library(haven)
  library(ivreg)
  library(multiwayvcov)
  library(magrittr)
  library(htmltools)
  library(texreg)
#Open the data source
  bhw_data_fixed <- read_dta("C:\\Users\\Olga\\Desktop\\Обучение\\1. Seminar Econometrics\\0. Data for replication\\AEJMacro-2010-0021_data\\bhw_data_fixed.dta")
  bhw_data_main <- read_dta("C:\\Users\\Olga\\Desktop\\Обучение\\1. Seminar Econometrics\\0. Data for replication\\AEJMacro-2010-0021_data\\bhw_data_main.dta")
  master_county1849 <- read_dta("C:\\Users\\Olga\\Desktop\\Обучение\\1. Seminar Econometrics\\0. Data for replication\\AEJMacro-2010-0021_data\\master_county1849.dta")
#Table 1 from Appendix A: Education and Industrialization in the First Phase of the Industrial Revolution
  # Ordinary Least Squares (OLS) regression models for different categories of factories
  # OLS for all factories
  Model1 <- lm(fac1849_total_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm, data = bhw_data_main)
  # OLS excluding metal and textile factories
  Model2 <- lm(fac1849_other_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm, data = bhw_data_main)
  # OLS for metal factories only
  Model3 <- lm(fac1849_metal_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm, data = bhw_data_main)
  # OLS for textile factories only
  Model4 <- lm(fac1849_texti_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm, data = bhw_data_main)
  
  # Cluster robust standard errors at the level of the 280 units of observation in the 1816-original counties
  cluster_var <- (bhw_data_main$max_kreiskey1800)  
  # Adjusting models for clustered standard errors 
  Model1_robust <- coeftest(Model1, vcov = vcovCL(Model1, cluster = cluster_var))
  Model2_robust <- coeftest(Model2, vcov = vcovCL(Model2, cluster = cluster_var))
  Model3_robust <- coeftest(Model3, vcov = vcovCL(Model3, cluster = cluster_var))
  Model4_robust <- coeftest(Model4, vcov = vcovCL(Model4, cluster = cluster_var))
  
  # Compiling the models for easier comparison and output presentation
  model_list <- list(Model1_robust, Model2_robust, Model3_robust, Model4_robust)
  # Setting custom names for the model coefficients for clearer interpretation in the output
  custom_names <- c("(Intercept)"="Intercept",
                    "edu1849_adult_yos" = "Years of schooling 1849",
                    "pop1849_young" = "Share of population < 15 years",
                    "pop1849_old" = "Share of population > 60 years",
                    "area1816_qkm"="County area (in 1,000 km²)"  )
  
  # Display regression results in HTML format, setting custom notes
  htmlreg(l = model_list, digits = 3, custom.coef.names = custom_names,
          custom.note = "Model 1 - All factories, <br>
                          Model 2 - All except metal and textile, <br>
                          Model 3 - Metal factories,<br>
                          Model 4 - Textile factories") %>% 
    HTML() %>% 
    browsable()
  
  # Display regression results in plain text format
  textreg(l = model_list)
  
#Table 2 from Appendix A:Education and Industrialization in the First Phase of the Industrial Revolution
  #Further is IV model with the primary school enrollment in 1816 as instrument
  # IV for all factories
  iv_model1 <- ivreg(fac1849_total_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm, data = bhw_data_main)
  # IV excluding metal and textile factories
  iv_model2 <- ivreg(fac1849_other_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm, data = bhw_data_main)
  # IV for metal factories only
  iv_model3 <- ivreg(fac1849_metal_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm, data = bhw_data_main)
  # IV for textile factories only
  iv_model4 <- ivreg(fac1849_texti_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm, data = bhw_data_main)

  # Recalculate robust standard errors for the IV models
  cluster_var <- (bhw_data_main$max_kreiskey1800)  # Adjust the variable name if necessary
  # Adjusting models for clustered standard errors 
  iv_Model1_robust <- coeftest(iv_model1, vcov = vcovCL(iv_model1, cluster = cluster_var))
  iv_Model2_robust <- coeftest(iv_model2, vcov = vcovCL(iv_model2, cluster = cluster_var))
  iv_Model3_robust <- coeftest(iv_model3, vcov = vcovCL(iv_model3, cluster = cluster_var))
  iv_Model4_robust <- coeftest(iv_model4, vcov = vcovCL(iv_model4, cluster = cluster_var))
  
  # Creating a new list
  model_list1 <- list(iv_Model1_robust, iv_Model2_robust, iv_Model3_robust, iv_Model4_robust)
  
  # Display regression results in HTML format, setting custom notes
  htmlreg(l=model_list1,digits = 3,custom.note="Model 1 - All factories, <br>
          Model 2 - All except metal and textile, <br>
          Model 3 - Metal factories,<br>
          Model 4 - Textile factories", custom.coef.names = custom_names) %>% HTML() %>% browsable()
  # Display regression results in plain text format
  textreg(l=model_list1)



#Table3 from Appendix A: Accounting for Pre-industrial Development
  # It is again IV model with same instrument, but with added pre-industrial control variables to all factories
  
  # Controls for young and old population in 1849, area in 1816, and population in cities in 1816
  iv_model3_1 <- ivreg(fac1849_total_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc, data = bhw_data_main)
  # Builds on iv_model3_1 by adding a control for the number of looms per capita in 1819, suggesting a focus on textile industry presence in the pre-industrial era. The same set of instruments are used.
  iv_model3_2 <- ivreg(fac1849_total_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc +indu1819_texti_pc | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc, data = bhw_data_main)
  # Builds further by adding a control for steam engines in mining per capita in 1849, accounting for technological advancements in the mining industry by 1849.
  iv_model3_3 <- ivreg(fac1849_total_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc, data = bhw_data_main)
  #Along with previous controls, it includes controls for sheep per capita in 1816 (indicative of wool industry or agriculture) and the share of farm laborers in the total population in 1819 (indicative of agricultural prominence).
  iv_model3_4 <- ivreg(fac1849_total_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc +occ1816_farm_laborer_t_pc | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+ occ1816_farm_laborer_t_pc, data = bhw_data_main)
  
  # Cluster robust standard errors once again
  cluster_var <- (bhw_data_main$max_kreiskey1800) 
  # Adjusting models for clustered standard errors
  iv_Model3_1_robust <- coeftest(iv_model3_1, vcov = vcovCL(iv_model3_1, cluster = cluster_var))
  iv_Model3_2_robust <- coeftest(iv_model3_2, vcov = vcovCL(iv_model3_2, cluster = cluster_var))
  iv_Model3_3_robust <- coeftest(iv_model3_3, vcov = vcovCL(iv_model3_3, cluster = cluster_var))
  iv_Model3_4_robust <- coeftest(iv_model3_4, vcov = vcovCL(iv_model3_4, cluster = cluster_var))
  
  # Create a list of models
  model_list2 <- list(iv_Model3_1_robust, iv_Model3_2_robust, iv_Model3_3_robust, iv_Model3_4_robust)
  # Setting custom names for the model coefficients for clearer interpretation in the output
  custom_names1 <- c("(Intercept)"="Intercept",
                     "edu1849_adult_yos" = "Years of schooling 1849",
                     "pop1849_young" = "Share of population < 15 years",
                     "pop1849_old" = "Share of population > 60 years",
                     "area1816_qkm"="County area (in 1,000 km²)" ,
                     "pop1816_cities_pc" = "Share of population living in cities in 1816",
                     "indu1819_texti_pc" = "Looms per capita 1819",
                     "steam1849_mining_pc" = "Steam engines in mining per capita 1849",
                     "vieh1816_schaf_landvieh_pc"="Sheep per capita 1816",
                     "occ1816_farm_laborer_t_pc"="Share of farm laborers in total population 1819"
  )
  # Display regression results in HTML format, setting custom notes
  htmlreg(l=model_list2, digits = 3, custom.coef.names = custom_names1) %>% HTML() %>% browsable()
  # Display regression results in plain text format
  textreg(l=model_list2)


#Table4 from Appendix A: Accounting for Pre-industrial Development
  # It is again IV model with same instrument, but including all pre-industrial control variables by sectors
  # IV for all factories with all pre-industrial control variables
  iv_model31_1 <- ivreg(fac1849_total_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm +pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+occ1816_farm_laborer_t_pc+buil1816_publ_pc + chausseedummy +trans1816_freight_pc| edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+occ1816_farm_laborer_t_pc+buil1816_publ_pc+ chausseedummy +trans1816_freight_pc, data = bhw_data_main)
  # IV excluding metal and textile factories with all pre-industrial control variables
  iv_model31_2 <- ivreg(fac1849_other_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm +pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+occ1816_farm_laborer_t_pc+buil1816_publ_pc+ chausseedummy +trans1816_freight_pc | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+occ1816_farm_laborer_t_pc+buil1816_publ_pc+ chausseedummy +trans1816_freight_pc, data = bhw_data_main)
  # IV for metal factories only with all pre-industrial control variables
  iv_model31_3 <- ivreg(fac1849_metal_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm +pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+occ1816_farm_laborer_t_pc+buil1816_publ_pc+ chausseedummy +trans1816_freight_pc | edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+occ1816_farm_laborer_t_pc+buil1816_publ_pc+ chausseedummy +trans1816_freight_pc, data = bhw_data_main)
  # IV for textile factories only with all pre-industrial control variables
  iv_model31_4 <- ivreg(fac1849_texti_pc ~ edu1849_adult_yos + pop1849_young + pop1849_old + area1816_qkm +pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+occ1816_farm_laborer_t_pc+buil1816_publ_pc + chausseedummy +trans1816_freight_pc| edu1816_pri_enrol + pop1849_young + pop1849_old + area1816_qkm+pop1816_cities_pc+indu1819_texti_pc+steam1849_mining_pc+vieh1816_schaf_landvieh_pc+occ1816_farm_laborer_t_pc+buil1816_publ_pc+ chausseedummy +trans1816_freight_pc, data = bhw_data_main)
  
  # Cluster robust standard errors
  cluster_var <- (bhw_data_main$max_kreiskey1800)  # Adjust the variable name if necessary
  # Adjusting models for clustered standard errors
  iv_Model31_1_robust <- coeftest(iv_model31_1, vcov = vcovCL(iv_model31_1, cluster = cluster_var))
  iv_Model31_2_robust <- coeftest(iv_model31_2, vcov = vcovCL(iv_model31_2, cluster = cluster_var))
  iv_Model31_3_robust <- coeftest(iv_model31_3, vcov = vcovCL(iv_model31_3, cluster = cluster_var))
  iv_Model31_4_robust <- coeftest(iv_model31_4, vcov = vcovCL(iv_model31_4, cluster = cluster_var))
  # Create a list of models
  model_list3<-list(iv_Model31_1_robust,iv_Model31_2_robust,iv_Model31_3_robust,iv_Model31_4_robust)
  # Setting custom names for the model coefficients for clearer interpretation in the output
  custom_names2 <- c("(Intercept)"="Intercept",
                     "edu1849_adult_yos" = "Years of schooling 1849",
                     "pop1849_young" = "Share of population < 15 years",
                     "pop1849_old" = "Share of population > 60 years",
                     "area1816_qkm"="County area (in 1,000 km²)" ,
                     "pop1816_cities_pc" = "Share of population living in cities in 1816",
                     "indu1819_texti_pc" = "Looms per capita 1819",
                     "steam1849_mining_pc" = "Steam engines in mining per capita 1849",
                     "vieh1816_schaf_landvieh_pc"="Sheep per capita 1816",
                     "occ1816_farm_laborer_t_pc"="Share of farm laborers in total population 1819",
                     "buil1816_publ_pc" = "Public buildings per capita 1821",
                     "chausseedummy"="Paved streets 1815 (dummy)",
                     "trans1816_freight_pc"="Tonnage of ships per capita 1819"
  )
  # Display regression results in HTML format, setting custom notes
  htmlreg(l=model_list3, digits = 3 , custom.coef.names = custom_names2,custom.note="Model 1 - All factories, <br>
          Model 2 - All except metal and textile, <br>
          Model 3 - Metal factories,<br>
          Model 4 - Textile factories") %>% HTML() %>% browsable()
  # Display regression results in plain text format
  textreg(l=model_list3)