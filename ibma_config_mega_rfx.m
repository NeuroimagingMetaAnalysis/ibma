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
    conFiles_gr1 = ibma_config_contrast_files(' in group 1', '1');
    conFiles_gr2 = ibma_config_contrast_files(' in group 2', '2');
    
    %----------------------------------------------------------------------
    % One-sample
    %----------------------------------------------------------------------
    one_sample = cfg_branch;
    one_sample.tag      = 'one';
    one_sample.name     = 'One-sample';   
    one_sample.val      = {conFiles};
    one_sample.help     = {['One-sample test.']};

    %----------------------------------------------------------------------
    % Two-sample
    %----------------------------------------------------------------------
    two_sample      = cfg_branch;
    two_sample.tag  = 'two';
    two_sample.name = 'Two-sample';
    two_sample.val  = { conFiles_gr1 conFiles_gr2 };
    two_sample.help = {'Two-sample test.'};

    %----------------------------------------------------------------------
    % One-sample or two-sample analysis
    %----------------------------------------------------------------------
    model_type    = cfg_choice;
    model_type.tag    = 'model';
    model_type.name   = 'One/Two-sample analysis';
    model_type.help   = {''};
    model_type.values = {one_sample two_sample};
    model_type.val = {one_sample};
     
    %----------------------------------------------------------------------
    % Mega-RFX meta-analysis on contrast maps
    %----------------------------------------------------------------------
    megarfxconfig = cfg_exbranch;
    megarfxconfig.tag     = 'megarfx';
    megarfxconfig.name    = 'Third-level RFX';
    megarfxconfig.val     = {dir model_type};
    megarfxconfig.help    = {'Third-level of a hierarachical RFX GLM.'};
    megarfxconfig.prog = @ibma_run_mega_rfx;
end