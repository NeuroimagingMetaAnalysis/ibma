function megaffxolscfg = ibma_cfg_mega_ffx_ols()
% IBMA_CFG_MEGA_FFX_OLS  Define the matlabbatch job structure to run the
% third-level of a hierarachical GLM using FFX (at the third-level only)
% and ordinary least-squares (OLS).
%   megaffxolscfg = IBMA_CFG_MEGA_FFX_OLS() return the matlabbatch 
%   configuration to run the third-level of a hierarachical GLM using FFX 
%   (at the third-level only) and ordinary least-squares (OLS).
%
%   See also IBMA_CFG_FISHERS, IBMA_CFG_STOUFFERS, IBMA_CFG_WEIGHTED_Z.
%
%   megaffxolscfg = ibma_cfg_mega_ffx_ols()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_cfg_mega_ffx_ols.m  IBMA toolbox
% Camille Maumet

    dir = ibma_config_analysis_dir();
    
    conFiles = ibma_config_contrast_files();
     
    megaffxolscfg = cfg_exbranch;
    megaffxolscfg.tag     = 'megaffxols';
    megaffxolscfg.name    = 'Third-level FFX OLS';
    megaffxolscfg.val     = {dir conFiles};
    megaffxolscfg.help    = {'Third-level of a hierarachical GLM using FFX (at the third-level only).'};
    megaffxolscfg.prog = @ibma_run_mega_ffx_ols;
end