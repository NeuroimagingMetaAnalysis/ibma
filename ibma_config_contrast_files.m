function conFilesCfg = ibma_config_contrast_files(suffix, tag_suffix)
% IBMA_CONFIG_CONTRAST_FILES  Define the matlabbatch job structure for
% selection of the analysis directory (for any IBMA study).
%   conFilesCfg = ibma_config_contrast_files() return the matlabbatch 
%   configuration to select contrast files.
%
%   conFilesCfg = ibma_config_contrast_files()
 
% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_contrast_files.m  IBMA toolbox
% Camille Maumet

    if nargin < 1
        suffix = '';
    end
    if nargin < 2
        tag_suffix = strrep(lower(suffix), ' ', '');
    end

    conFilesCfg         = cfg_files;
    conFilesCfg.tag     = ['confiles' tag_suffix];
    conFilesCfg.name    = ['Contrast images' suffix];
    conFilesCfg.help    = {'Select the contrast images.'};
    conFilesCfg.filter = 'image';
    conFilesCfg.ufilter = '.*';
    conFilesCfg.num     = [1 Inf];  
end