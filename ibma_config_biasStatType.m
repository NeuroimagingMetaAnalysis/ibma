function statType = ibma_config_biasStatType()
 % IBMA_CONFIG_FFXRFX  Define the matlabbatch job structure for selection 
 % of Ramdon-effects (RFX) or Fixed-effects (FFX) procedure.
 %   ffxrfx = IBMA_CONFIG_FFXRFX() return the matlabbatch configuration to 
 %   select Fixed-Effects or Random-Effects procedure.
 %
 %   ffxrfx = ibma_config_ffxrfx()
  
 % Copyright (C) 2014 The University of Warwick
 % Id: ibma_config_ffxrfx.m  IBMA toolbox
 % Camille Maumet
 
     dataLeaf = ibma_config_data(0);
     dataLeafWithSubjects = ibma_config_data(1);
     
     statType_trimAndFill_Q      = cfg_choice;
     statType_trimAndFill_Q.tag  = 'statType_trimAndFill_Q';
     statType_trimAndFill_Q.name = 'Q_0';
     statType_trimAndFill_Q.values = {dataLeaf};
     statType_trimAndFill_Q.val  = {dataLeaf};
     statType_trimAndFill_Q.help = {['The Q_0 Trim and Fill estimator.']};
     
     statType_trimAndFill_R      = cfg_choice;
     statType_trimAndFill_R.tag  = 'statType_trimAndFill_R';
     statType_trimAndFill_R.name = 'R_0';
     statType_trimAndFill_R.values = {dataLeaf};
     statType_trimAndFill_R.val  = {dataLeaf};
     statType_trimAndFill_R.help = {['The R_0 Trim and Fill estimator.']};
     
     statType_trimAndFill_L      = cfg_choice;
     statType_trimAndFill_L.tag  = 'statType_trimAndFill_L';
     statType_trimAndFill_L.name = 'L_0';
     statType_trimAndFill_L.values = {dataLeaf};
     statType_trimAndFill_L.val  = {dataLeaf};
     statType_trimAndFill_L.help = {['The L_0 Trim and Fill estimator.']};
     
     statType_BeggsCorrelation_z      = cfg_choice;
     statType_BeggsCorrelation_z.tag  = 'statType_BeggsCorrelation_z';
     statType_BeggsCorrelation_z.name = 'Z values';
     statType_BeggsCorrelation_z.values = {dataLeaf};
     statType_BeggsCorrelation_z.val  = {dataLeaf};
     statType_BeggsCorrelation_z.help = {['Z values for Begg''s correlation.']};
     
     statType_BeggsCorrelation_t      = cfg_choice;
     statType_BeggsCorrelation_t.tag  = 'statType_BeggsCorrelation_t';
     statType_BeggsCorrelation_t.name = 'Tau values';
     statType_BeggsCorrelation_t.values = {dataLeaf};
     statType_BeggsCorrelation_t.val  = {dataLeaf};
     statType_BeggsCorrelation_t.help = {['Tau values for Begg''s correlation.']};
     
     statType_BeggsCorrelation_p      = cfg_choice;
     statType_BeggsCorrelation_p.tag  = 'statType_BeggsCorrelation_p';
     statType_BeggsCorrelation_p.name = 'P-values';
     statType_BeggsCorrelation_p.values = {dataLeaf};
     statType_BeggsCorrelation_p.val  = {dataLeaf};
     statType_BeggsCorrelation_p.help = {['P-Values for correlation.']};
     
     statType_MacaskillRegression_slope      = cfg_choice;
     statType_MacaskillRegression_slope.tag  = 'statType_MacaskillRegression_slope';
     statType_MacaskillRegression_slope.name = 'Slope';
     statType_MacaskillRegression_slope.values = {dataLeafWithSubjects};
     statType_MacaskillRegression_slope.val  = {dataLeafWithSubjects};
     statType_MacaskillRegression_slope.help = {['Slope obtained from Macaskill',...
                                                            ' Regression.']};
                                                        
     statType_MacaskillRegression_pVal      = cfg_choice;
     statType_MacaskillRegression_pVal.tag  = 'statType_MacaskillRegression_pVal';
     statType_MacaskillRegression_pVal.name = 'P-values';
     statType_MacaskillRegression_pVal.values = {dataLeafWithSubjects};
     statType_MacaskillRegression_pVal.val  = {dataLeafWithSubjects};
     statType_MacaskillRegression_pVal.help = {['P-Values obtained from the null hypothesis that ',... 
                                                'the Macaskill Regression slope is zero.']};
                                            
     statType_EggerRegression_unweighted_intercepts      = cfg_choice;
     statType_EggerRegression_unweighted_intercepts.tag  = 'statType_EggerRegression_unweighted_intercepts';
     statType_EggerRegression_unweighted_intercepts.name = 'Intercepts';
     statType_EggerRegression_unweighted_intercepts.values = {dataLeaf};
     statType_EggerRegression_unweighted_intercepts.val  = {dataLeaf};
     statType_EggerRegression_unweighted_intercepts.help = {['Intercepts obtained from Egger Unweighted',...
                                                            ' Regression.']};
                                                        
     statType_EggerRegression_weighted_intercepts      = cfg_choice;
     statType_EggerRegression_weighted_intercepts.tag  = 'statType_EggerRegression_weighted_intercepts';
     statType_EggerRegression_weighted_intercepts.name = 'Intercepts';
     statType_EggerRegression_weighted_intercepts.values = {dataLeaf};
     statType_EggerRegression_weighted_intercepts.val  = {dataLeaf};
     statType_EggerRegression_weighted_intercepts.help = {['Intercepts obtained from Egger weighted',...
                                                            ' Regression.']};
                                                        
     statType_EggerRegression_unweighted_pVal      = cfg_choice;
     statType_EggerRegression_unweighted_pVal.tag  = 'statType_EggerRegression_unweighted_pVal';
     statType_EggerRegression_unweighted_pVal.name = 'P-values';
     statType_EggerRegression_unweighted_pVal.values = {dataLeaf};
     statType_EggerRegression_unweighted_pVal.val  = {dataLeaf};
     statType_EggerRegression_unweighted_pVal.help = {['P values for the null hypothesis that the Egger',...
                                                    ' unweighted Regression intercept is zero.']};
     
     statType_EggerRegression_weighted_pVal      = cfg_choice;
     statType_EggerRegression_weighted_pVal.tag  = 'statType_EggerRegression_weighted_pVal';
     statType_EggerRegression_weighted_pVal.name = 'P-values';
     statType_EggerRegression_weighted_pVal.values = {dataLeaf};
     statType_EggerRegression_weighted_pVal.val  = {dataLeaf};
     statType_EggerRegression_weighted_pVal.help = {['P values for the null hypothesis that the Egger',...
                                                    ' Weighted Regression intercept is zero.']};
   
     %Create choice nodes.
     
     statType_EggerRegression_weighted         = cfg_choice;
     statType_EggerRegression_weighted.name    = 'Weighted';    
     statType_EggerRegression_weighted.tag     = 'statType_EggerRegression_weighted';
     statType_EggerRegression_weighted.values  = {statType_EggerRegression_weighted_pVal, statType_EggerRegression_weighted_intercepts};
     
     statType_EggerRegression_unweighted         = cfg_choice;
     statType_EggerRegression_unweighted.name    = 'Unweighted';
     statType_EggerRegression_unweighted.tag     = 'statType_EggerRegression_unweighted';
     statType_EggerRegression_unweighted.values  = {statType_EggerRegression_unweighted_pVal, statType_EggerRegression_unweighted_intercepts};
     
     statType_MacaskillRegression         = cfg_choice;
     statType_MacaskillRegression.name    = 'Macaskill Regression';
     statType_MacaskillRegression.tag     = 'statType_MacaskillRegression';
     statType_MacaskillRegression.values  = {statType_MacaskillRegression_pVal, statType_MacaskillRegression_slope};

     statType_EggerRegression         = cfg_choice;
     statType_EggerRegression.name    = 'Egger Regression';
     statType_EggerRegression.tag     = 'statType_EggerRegression';
     statType_EggerRegression.values  = {statType_EggerRegression_unweighted, statType_EggerRegression_weighted};
     
     statType_BeggsCorrelation         = cfg_choice;
     statType_BeggsCorrelation.name    = 'Begg''s Correlation';
     statType_BeggsCorrelation.tag     = 'statType_BeggsCorrelation';
     statType_BeggsCorrelation.values  = {statType_BeggsCorrelation_p, statType_BeggsCorrelation_z, statType_BeggsCorrelation_t};
     
     statType_trimAndFill         = cfg_choice;
     statType_trimAndFill.name    = 'Trim And Fill';
     statType_trimAndFill.tag     = 'statType_trimAndFill';
     statType_trimAndFill.values  = {statType_trimAndFill_R, statType_trimAndFill_L, statType_trimAndFill_Q};
                                 
     statType         = cfg_choice;
     statType.name    = 'Select statistic type:';
     statType.tag     = 'statType';
     statType.values  = {statType_trimAndFill, statType_BeggsCorrelation,...
                         statType_EggerRegression, statType_MacaskillRegression};
     statType.val     = {statType_trimAndFill};
     
 end