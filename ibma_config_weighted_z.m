function weightedZconfig = ibma_config_weighted_z()
% IBMA_CONFIG_FISHERS Define the matlabbatch job structure for Fisher's 
% meta-analysis.
%   weightedZconfig = IBMA_CONFIG_FISHERS() return the matlabbatch configuration
%   to run Fisher's meta-analysis.
%
%   See also IBMA_FISHERS, IBMA_CONFIG_STOUFFERS.
%
%   weightedZconfig = ibma_config_weighted_z()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_weighted_z.m  IBMA toolbox
% Camille Maumet

    commonconfig = ibma_config_zbased_stat();
  
    nSubjects = ibma_config_nsubjects();
  
    weightedZconfig = cfg_exbranch;
    weightedZconfig.tag     = 'weightedz';
    weightedZconfig.name    = 'Optimal weighted-z';
    weightedZconfig.val     = {commonconfig{:} nSubjects};
    weightedZconfig.help    = {'z-weighted by square root of studies sample sizes.'};
    weightedZconfig.prog = @ibma_run_weighted_z;
    weightedZconfig.check = @ibma_check_weighted_z;
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