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

    samplesSizeEqual      = cfg_choice;
    samplesSizeEqual.tag  = 'equal';
    samplesSizeEqual.name = 'Equal';
    samplesSizeEqual.val  = {ibma_config_nsubjects(true)};
    samplesSizeEqual.values  = {ibma_config_nsubjects(true)};
    samplesSizeEqual.help = {'Equal sample sizes in each study.'};
    
    samplesSizeUnequal      = cfg_choice;
    samplesSizeUnequal.tag  = 'unequal';
    samplesSizeUnequal.name = 'Unequal';
    samplesSizeUnequal.val  = {ibma_config_nsubjects(false)};
    samplesSizeUnequal.values  = {ibma_config_nsubjects(false)};
    samplesSizeUnequal.help = {'Unequal sample sizes.'};

    samplesSize         = cfg_choice;
    samplesSize.name    = 'Sample size';
    samplesSize.tag     = 'samplesize';
    samplesSize.values  = {samplesSizeEqual; samplesSizeUnequal};
    samplesSize.val     = {samplesSizeEqual};
    
    varianceEqual      = cfg_const;
    varianceEqual.tag  = 'equal';
    varianceEqual.name = 'Equal';
    varianceEqual.val  = {1};
    varianceEqual.help = {'Equal variances across studies (regardless of sample-size).'};
    
    varianceUnequal      = cfg_const;
    varianceUnequal.tag  = 'unequal';
    varianceUnequal.name = 'Unequal';
    varianceUnequal.val  = {1};
    varianceUnequal.help = {'Unequal variances across studies.'};

    studyVariances         = cfg_choice;
    studyVariances.name    = 'Variance across studies';
    studyVariances.tag     = 'variances';
    studyVariances.values  = {varianceEqual; varianceUnequal};
    studyVariances.val     = {varianceEqual};
        
    nSubjects         = cfg_entry;
    nSubjects.tag     = 'nsubjects';
    nSubjects.name    = 'Number of subjects per studies';
    nSubjects.help    = {'Number of subjects per studies'};
    nSubjects.strtype = 'e';
    nSubjects.num     = [Inf 1];

    conFiles = ibma_config_contrast_files();
    
    varConfiles = ibma_config_var_contrast_files();
  
    megaffx = cfg_exbranch;
    megaffx.tag     = 'megaffx';
    megaffx.name    = 'Third-level FFX';
    megaffx.val     = {dir conFiles varConfiles samplesSize studyVariances};
    megaffx.help    = {'Third-level of a hierarachical GLM using FFX (at the third-level only).'};
    megaffx.prog = @ibma_run_mega_ffx;
    megaffx.check = @ibma_check_mega_ffx;
end

function t = ibma_check_mega_ffx(job)
    t={};
    if isfield(job.samplesize, 'unequal')
        % nSubjects must have exactly one value per study
        numValues = numel(job.samplesize.unequal.nsubjects);
        numStudies = numel(job.confiles);
        if numValues ~= numStudies
            t = {['Wrong number of values for number of subjects: ' ...
                num2str(numValues) ' values for ' num2str(numStudies) ' studies'...
                '(unequal sample sizes).'] };
        end
        numVariances = numel(job.varconfiles);
        if numVariances ~= numStudies
            t = {['Wrong number of contrast variances: ' ...
                num2str(numVariances) ' variances for ' num2str(numStudies) ' studies.'...
                '(unequal sample sizes).'] };
        end
    elseif isfield(job.samplesize, 'equal')
        numValues = numel(job.samplesize.equal.nsubjects);
        if numValues ~= 1
            t = {['Wrong number of values for number of subjects: ' ...
                num2str(numValues) ' values instead of 1 (equal sample sizes).' ] };
        end
    else
        error('Missing field sample size')
    end
end