function statType = ibma_config_hetStatType()
 % IBMA_CONFIG_FFXRFX  Define the matlabbatch job structure for selection 
 % of Ramdon-effects (RFX) or Fixed-effects (FFX) procedure.
 %   ffxrfx = IBMA_CONFIG_FFXRFX() return the matlabbatch configuration to 
 %   select Fixed-Effects or Random-Effects procedure.
 %
 %   ffxrfx = ibma_config_ffxrfx()
  
 % Copyright (C) 2014 The University of Warwick
 % Id: ibma_config_ffxrfx.m  IBMA toolbox
 % Camille Maumet
     
%--------------------------------------------------------------------------
% statType Q
%--------------------------------------------------------------------------

     statType_Q      = cfg_const;
     statType_Q.tag  = 'statType_Q';
     statType_Q.name = 'Q Statistic';
     statType_Q.val  = {0};
     statType_Q.help = {'Cochran`s Q statistic.'};
 
%--------------------------------------------------------------------------
% statType I^2
%--------------------------------------------------------------------------

     statType_I2      = cfg_const;
     statType_I2.tag  = 'statType_I2';
     statType_I2.name = 'I2 Statistic';
     statType_I2.val  = {0};
     statType_I2.help = {'The I squared statistic.'};
 
%--------------------------------------------------------------------------
% statType NLogP
%--------------------------------------------------------------------------
     
     statType_NLogP      = cfg_const;
     statType_NLogP.tag  = 'statType_NLogP';
     statType_NLogP.name = '-LogP Statistic';
     statType_NLogP.val  = {0};
     statType_NLogP.help = {'The negative log(P) values for Cochran`s Q.'};
     
     
%--------------------------------------------------------------------------
% statType Q
%--------------------------------------------------------------------------
     
     statType         = cfg_choice;
     statType.name    = 'Select map to view:';
     statType.tag     = 'statType';
     statType.values  = {statType_Q; statType_I2; statType_NLogP};
     statType.val     = {statType_Q};
 end