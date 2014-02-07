function analysisDirCfg = ibma_config_analysis_dir()
% IBMA_CONFIG_ANALYSIS_DIR  Define the matlabbatch job structure for
% selection of the analysis directory (for any IBMA study).
%   analysisDirCfg = IBMA_CONFIG_ANALYSIS_DIR() return the matlabbatch 
%   configuration to select an amalysis directory.
%
%   analysisDirCfg = ibma_config_analysis_dir()
 
% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_analysis_dir.m  IBMA toolbox
% Camille Maumet

  analysisDirCfg         = cfg_files; 
  analysisDirCfg.name    = 'Analysis Directory'; 
  analysisDirCfg.tag     = 'dir';       
  analysisDirCfg.filter  = 'dir';
  analysisDirCfg.ufilter = '.*';
  analysisDirCfg.num     = [1 1];     
  analysisDirCfg.help    = {'','This sets the IBMA anlaysis directory.','All results will appear in this directory.'}; 
end