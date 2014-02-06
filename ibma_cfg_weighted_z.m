function weightedZcfg = ibma_cfg_weighted_z()
% IBMA_CFG_FISHERS Define the matlabbatch job structure for Fisher's 
% meta-analysis.
%   weightedZcfg = IBMA_CFG_FISHERS() return the matlabbatch configuration
%   to run Fisher's meta-analysis.
%
%   See also IBMA_FISHERS, IBMA_CFG_STOUFFERS.
%
%   weightedZcfg = ibma_cfg_weighted_z()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_cfg_weighted_z.m  IBMA toolbox
% Camille Maumet

    commoncfg = ibma_config_zbased_stat();
  
    nSubjects         = cfg_entry;
    nSubjects.tag     = 'nSubjects';
    nSubjects.name    = 'Number of subjects per studies';
    nSubjects.help    = {'Number of subjects per studies'};
    nSubjects.strtype = 'e';
    nSubjects.num     = [Inf 1];
  
    weightedZcfg = cfg_exbranch;
    weightedZcfg.tag     = 'weightedz';
    weightedZcfg.name    = 'Optimal weighted-z';
    weightedZcfg.val     = {commoncfg{:} nSubjects};
    weightedZcfg.help    = {'z-weighted by square root of studies sample sizes.'};
    weightedZcfg.prog = @ibma_run_weighted_z;
    weightedZcfg.check = @ibma_check_weighted_z;
end

function t = ibma_check_weighted_z(job)
    t={};
    % nSubjects must have exactly one value per study
    numValues = numel(job.nSubjects);
    numStudies = numel(job.zimages);
    if numValues ~= numStudies
        t = {['Wrong number of values for number of subjects: ' ...
            num2str(numValues) ' values for ' num2str(numStudies) ' studies.' ] };
    end
end