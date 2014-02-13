function stouffersconfig = ibma_config_stouffers()
% IBMA_CONFIG_STOUFFERS Define the matlabbatch job structure for Stouffer's 
% meta-analysis.
%   stouffersconfig = IBMA_CONFIG_STOUFFERS() return the matlabbatch configuration
%   to run IBMA_CONFIG_STOUFFERS's meta-analysis.
%
%   See also IBMA_STOUFFERS, IBMA_CONFIG_FISHERS.
%
%   stouffersconfig = ibma_config_stouffers()
 
% Copyright (C) 2014 The University of Warwick
% Id: ibma_config_stouffers.m  IBMA toolbox
% Camille Maumet


    commonconfig = ibma_config_zbased_stat();
  
    ffxrfx = ibma_config_ffxrfx();

    stouffersconfig = cfg_exbranch;
    stouffersconfig.tag     = 'stouffers';
    stouffersconfig.name    = 'Stouffer''s';
    stouffersconfig.val     = {commonconfig{:} ffxrfx};
    stouffersconfig.help    = {'Stouffer''s.'};
    stouffersconfig.prog = @ibma_run_stouffers;
    % TODO
    % stouffersconfig.vout = @todo;
endo;
end