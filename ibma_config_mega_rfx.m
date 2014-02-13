function megarfxconfig = ibma_config_mega_rfx()
% IBMA_CONFIG_MEGA_RFX  Define the matlabbatch job structure to run the
% third-level of a hierarachical GLM using FFX (at the third-level only)
% and ordinary least-squares (OLS).
%   megarfxconfig = IBMA_CONFIG_MEGA_RFX() return the matlabbatch 
%   configuration to run the third-level of a hierarachical GLM using FFX 
%   (at the third-level only) and ordinary least-squares (OLS).
%
%   See also IBMA_CONFIG_FISHERS, IBMA_CONFIG_STOUFFERS, IBMA_CONFIG_WEIGHTED_Z.
%
%   megarfxconfig = ibma_config_mega_rfx()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_mega_rfx.m  IBMA toolbox
% Camille Maumet

    dir = ibma_config_analysis_dir();
    
    conFiles = ibma_config_contrast_files();
     
    megarfxconfig = cfg_exbranch;
    megarfxconfig.tag     = 'megarfx';
    megarfxconfig.name    = 'Third-level RFX';
    megarfxconfig.val     = {dir conFiles};
    megarfxconfig.help    = {'Third-level of a hierarachical RFX GLM.'};
    megarfxconfig.prog = @ibma_run_mega_rfx;
end