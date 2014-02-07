function nSubjects = ibma_config_nsubjects()
% IBMA_CONFIG_NSUBJECTS  Define the matlabbatch job structure for
% selection of the number of subjects per studies.
%   nSubjects = IBMA_CONFIG_NSUBJECTS() return the matlabbatch 
%   configuration to select an amalysis directory.
%
%   nSubjects = ibma_config_nsubjects()
 
% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_nsubjects.m  IBMA toolbox
% Camille Maumet

    nSubjects         = cfg_entry;
    nSubjects.tag     = 'nsubjects';
    nSubjects.name    = 'Number of subjects per studies';
    nSubjects.help    = {'Number of subjects per studies'};
    nSubjects.strtype = 'e';
    nSubjects.num     = [Inf 1];
end

    