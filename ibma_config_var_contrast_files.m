function varConfiles = ibma_config_var_contrast_files()
% IBMA_CONFIG_VAR_CONTRAST_FILES  Define the matlabbatch job structure for
% selection of the contrast variance files (for any IBMA study).
%
%   varconFilesCfg = ibma_config_var_contrast_files()
 
% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_var_contrast_files.m  IBMA toolbox
% Camille Maumet

    varConfiles         = cfg_files;
    varConfiles.tag     = 'varconfiles';
    varConfiles.name    = 'Contrast variance images';
    varConfiles.help    = {'Select the contrast variance images.'};
    varConfiles.filter = 'image';
    varConfiles.ufilter = '.*';
    varConfiles.num     = [1 Inf];  
end