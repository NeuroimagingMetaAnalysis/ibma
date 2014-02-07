function conFilesCfg = ibma_config_contrast_files()
% IBMA_CONFIG_CONTRAST_FILES  Define the matlabbatch job structure for
% selection of the analysis directory (for any IBMA study).
%   conFilesCfg = ibma_config_contrast_files() return the matlabbatch 
%   configuration to select contrast files.
%
%   conFilesCfg = ibma_config_contrast_files()
 
% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_contrast_files.m  IBMA toolbox
% Camille Maumet

    conFilesCfg         = cfg_files;
    conFilesCfg.tag     = 'confiles';
    conFilesCfg.name    = 'Contrast images';
    conFilesCfg.help    = {'Select the contrast images.'};
    conFilesCfg.filter = 'image';
    conFilesCfg.ufilter = '.*';
    conFilesCfg.num     = [1 Inf];  
end