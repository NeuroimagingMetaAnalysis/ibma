function megaffxolsconfig = ibma_config_mega_ffx_ols()
% IBMA_CONFIG_MEGA_FFX_OLS  Define the matlabbatch job structure to run the
% third-level of a hierarachical GLM using FFX (at the third-level only)
% and ordinary least-squares (OLS).
%   megaffxolsconfig = IBMA_CONFIG_MEGA_FFX_OLS() return the matlabbatch 
%   configuration to run the third-level of a hierarachical GLM using FFX 
%   (at the third-level only) and ordinary least-squares (OLS).
%
%   See also IBMA_CONFIG_FISHERS, IBMA_CONFIG_STOUFFERS, IBMA_CONFIG_WEIGHTED_Z.
%
%   megaffxolsconfig = ibma_config_mega_ffx_ols()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_mega_ffx_ols.m  IBMA toolbox
% Camille Maumet

    dir = ibma_config_analysis_dir();
    
    conFiles = ibma_config_contrast_files();
     
    megaffxolsconfig = cfg_exbranch;
    megaffxolsconfig.tag     = 'megamfxols';
    megaffxolsconfig.name    = 'Third-level MFX with OLS';
    megaffxolsconfig.val     = {dir conFiles};
    megaffxolsconfig.help    = {'Third-level of a hierarachical MFX GLM using OLS.'};
    megaffxolsconfig.prog = @ibma_run_mega_mfx_ols;
end