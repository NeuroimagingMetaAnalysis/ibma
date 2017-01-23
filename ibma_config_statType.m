function statType = ibma_config_statType()
 % IBMA_CONFIG_FFXRFX  Define the matlabbatch job structure for selection 
 % of Ramdon-effects (RFX) or Fixed-effects (FFX) procedure.
 %   ffxrfx = IBMA_CONFIG_FFXRFX() return the matlabbatch configuration to 
 %   select Fixed-Effects or Random-Effects procedure.
 %
 %   ffxrfx = ibma_config_ffxrfx()
  
 % Copyright (C) 2014 The University of Warwick
 % Id: ibma_config_ffxrfx.m  IBMA toolbox
 % Camille Maumet
 
     statType_Q      = cfg_const;
     statType_Q.tag  = 'statType_Q';
     statType_Q.name = 'Q Statistic';
     statType_Q.val  = {0};
     statType_Q.help = {'Cochran`s Q statistic.'};
 
     statType_I2      = cfg_const;
     statType_I2.tag  = 'statType_I2';
     statType_I2.name = 'I2 Statistic';
     statType_I2.val  = {0};
     statType_I2.help = {'The I squared statistic.'};
 
     statType_NLogP      = cfg_const;
     statType_NLogP.tag  = 'statType_NLogP';
     statType_NLogP.name = '-LogP Statistic';
     statType_NLogP.val  = {0};
     statType_NLogP.help = {'The negative log(P) values for Cochran`s Q.'};
     
     statType_OOE_FFX      = cfg_const;
     statType_OOE_FFX.tag  = 'statType_OOE_FFX';
     statType_OOE_FFX.name = 'Overall observed effect (FFX)';
     statType_OOE_FFX.val  = {0};
     statType_OOE_FFX.help = {'The mean observed effect under fixed effects.'};
     
     statType_OOE_RFX      = cfg_const;
     statType_OOE_RFX.tag  = 'statType_OOE_RFX';
     statType_OOE_RFX.name = 'Overall observed effect (RFX)';
     statType_OOE_RFX.val  = {0};
     statType_OOE_RFX.help = {'The mean observed effect under random effects.'};
     
     statType_BSVar      = cfg_const;
     statType_BSVar.tag  = 'statType_BSVar';
     statType_BSVar.name = 'Between study variance';
     statType_BSVar.val  = {0};
     statType_BSVar.help = {'The between study variance.'};
     
     statType         = cfg_choice;
     statType.name    = 'Select map to view:';
     statType.tag     = 'statType';
     statType.values  = {statType_Q; statType_I2; statType_NLogP; statType_OOE_FFX;...
         statType_OOE_RFX; statType_BSVar};
     statType.val     = {statType_Q};
 end