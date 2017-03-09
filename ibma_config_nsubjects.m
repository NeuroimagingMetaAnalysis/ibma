function nSubjects = ibma_config_nsubjects(sameForAllStudies)
% IBMA_CONFIG_NSUBJECTS  Define the matlabbatch job structure for
% selection of the number of subjects per studies.
%   nSubjects = IBMA_CONFIG_NSUBJECTS() return the matlabbatch 
%   configuration to select an amalysis directory.
%
%   nSubjects = ibma_config_nsubjects()
 
% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_nsubjects.m  IBMA toolbox
% Camille Maumet

    if nargin < 1
        sameForAllStudies = false;
    end

    if sameForAllStudies
        num = [1 1];        
    else
        num = [Inf 1];
    end
    
    name = 'Number of subjects per study';
    
    nSubjects         = cfg_entry;
    nSubjects.tag     = 'nsubjects';
    nSubjects.name    = name;
    nSubjects.help    = {[name '.']};
    nSubjects.strtype = 'e';
    nSubjects.num     = num;
end

    