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
  
    nSubjects = ibma_config_nsubjects();
  
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
    nValues = numel(job.nsubjects);
    nStudies = numel(job.zimages);
    if nValues ~= nStudies
        t = {['Wrong number of values for number of subjects: ' ...
            num2str(nValues) ' values for ' num2str(nStudies) ' studies.' ] };
    end
end