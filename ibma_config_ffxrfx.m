function ffxrfx = ibma_config_ffxrfx()
 % IBMA_CONFIG_FFXRFX  Define the matlabbatch job structure for selection 
 % of Ramdon-effects (RFX) or Fixed-effects (FFX) procedure.
 %   ffxrfx = IBMA_CONFIG_FFXRFX() return the matlabbatch configuration to 
 %   select Fixed-Effects or Random-Effects procedure.
 %
 %   ffxrfx = ibma_config_ffxrfx()
  
 % Copyright (C) 2014 The University of Warwick
 % Id: ibma_config_ffxrfx.m  IBMA toolbox
 % Camille Maumet
 
     RFX_no      = cfg_const;
     RFX_no.tag  = 'RFX_no';
     RFX_no.name = 'FFX';
     RFX_no.val  = {0};
     RFX_no.help = {'Fixed-effects.'};
 
     RFX_yes      = cfg_const;
     RFX_yes.tag  = 'RFX_yes';
     RFX_yes.name = 'RFX';
     RFX_yes.val  = {0};
     RFX_yes.help = {'Ramdom-effects.'};
 
     ffxrfx         = cfg_choice;
     ffxrfx.name    = 'Random effects?';
     ffxrfx.tag     = 'rfx';
     ffxrfx.values  = {RFX_yes; RFX_no};
     ffxrfx.val     = {RFX_no};
 end