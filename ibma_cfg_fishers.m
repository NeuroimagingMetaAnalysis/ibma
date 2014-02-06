function fisherscfg = ibma_cfg_fishers()
% IBMA_CFG_FISHERS Define the matlabbatch job structure for Fisher's 
% meta-analysis.
%   fisherscfg = IBMA_CFG_FISHERS() return the matlabbatch configuration
%   to run Fisher's meta-analysis.
%
%   See also IBMA_FISHERS, IBMA_CFG_STOUFFERS.
%
%   fisherscfg = ibma_cfg_fishers()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_run_fishers.m  IBMA toolbox
% Camille Maumet

  commoncfg = ibma_config_zbased_stat();
%    dir         = cfg_files; 
%   dir.name    = 'Analysis Directory'; 
%   dir.tag     = 'dir';       
%   dir.filter  = 'dir';
%   dir.ufilter = '.*';
%   dir.num     = [1 1];     
%   dir.help    = {'','This sets the SnPM anlaysis directory.','All results will appear in this directory.'}; 

  
  fisherscfg = cfg_exbranch;
  fisherscfg.tag     = 'fisher';
  fisherscfg.name    = 'Fisher''s';
  fisherscfg.val     = commoncfg;
  fisherscfg.help    = {'Fisher''s.'};
  fisherscfg.prog = @ibma_run_fishers;
%   choice1.vout = @vout_initial_import;
end