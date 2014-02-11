function megaffx = ibma_config_mega_ffx()
% IBMA_CONFIG_MEGA_FFX  Define the matlabbatch job structure for third-level 
% of a hierarachical GLM using FFX (at the third-level only).
%   megaffx = IBMA_CONFIG_MEGA_FFX() return the matlabbatch configuration
%   to run Fisher's meta-analysis.
%
%   See also IBMA_CONFIG_FISHERS, IBMA_CONFIG_STOUFFERS, IBMA_CONFIG_WEIGHTED_Z.
%
%   tmegaffx = ibma_config_mega_ffx()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_mega_ffx.m  IBMA toolbox
% Camille Maumet

    dir = ibma_config_analysis_dir();
    
    nSubjects = ibma_config_nsubjects();

    conFiles = ibma_config_contrast_files();
    
    varConfiles         = cfg_files;
    varConfiles.tag     = 'varconfiles';
    varConfiles.name    = 'Contrast variance images';
    varConfiles.help    = {'Select the contrast variance images.'};
    varConfiles.filter = 'image';
    varConfiles.ufilter = '.*';
    varConfiles.num     = [1 Inf];  
  
    megaffx = cfg_exbranch;
    megaffx.tag     = 'megaffx';
    megaffx.name    = 'Third-level FFX';
    megaffx.val     = {dir nSubjects conFiles varConfiles};
    megaffx.help    = {'Third-level of a hierarachical GLM using FFX (at the third-level only).'};
    megaffx.prog = @ibma_run_mega_ffx;
    megaffx.check = @ibma_check_mega_ffx;
end

function t = ibma_check_mega_ffx(job)
    t={};
    % nSubjects must have exactly one value per study
    numValues = numel(job.nsubjects);
    numStudies = numel(job.confiles);
    if numValues ~= numStudies
        t = {['Wrong number of values for number of subjects: ' ...
            num2str(numValues) ' values for ' num2str(numStudies) ' studies.' ] };
    end
    numVariances = numel(job.varconfiles);
    if numVariances ~= numStudies
        t = {['Wrong number of contrast variances: ' ...
            num2str(numVariances) ' variances for ' num2str(numStudies) ' studies.' ] };
    end
end