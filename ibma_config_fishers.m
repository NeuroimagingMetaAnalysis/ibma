function fisherscfg = ibma_config_fishers()
% IBMA_CONFIG_FISHERS Define the matlabbatch job structure for Fisher's 
% meta-analysis.
%   fisherscfg = IBMA_CONFIG_FISHERS() return the matlabbatch configuration
%   to run Fisher's meta-analysis.
%
%   See also IBMA_FISHERS, IBMA_CFG_STOUFFERS.
%
%   fisherscfg = ibma_cfg_fishers()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_fishers.m  IBMA toolbox
% Camille Maumet

  commoncfg = ibma_config_zbased_stat();
  
  fisherscfg = cfg_exbranch;
  fisherscfg.tag     = 'fisher';
  fisherscfg.name    = 'Fisher''s';
  fisherscfg.val     = commoncfg;
  fisherscfg.help    = {'Fisher''s.'};
  fisherscfg.prog = @ibma_run_fishers;
%   choice1.vout = @vout_initial_import;
end