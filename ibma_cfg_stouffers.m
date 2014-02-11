function stoufferscfg = ibma_cfg_stouffers()
% IBMA_CFG_STOUFFERS Define the matlabbatch job structure for Stouffer's 
% meta-analysis.
%   stoufferscfg = IBMA_CFG_STOUFFERS() return the matlabbatch configuration
%   to run IBMA_CFG_STOUFFERS's meta-analysis.
%
%   See also IBMA_STOUFFERS, IBMA_CFG_FISHERS.
%
%   stoufferscfg = ibma_cfg_stouffers()
 
% Copyright (C) 2014 The University of Warwick
% Id: ibma_cfg_stouffers.m  IBMA toolbox
% Camille Maumet


    commoncfg = ibma_config_zbased_stat();
  
    ffxrfx = ibma_config_ffxrfx();

    stoufferscfg = cfg_exbranch;
    stoufferscfg.tag     = 'stoufferscfg';
    stoufferscfg.name    = 'Stouffer''s';
    stoufferscfg.val     = {commoncfg{:} ffxrfx};
    stoufferscfg.help    = {'Stouffer''s.'};
    stoufferscfg.prog = @ibma_run_stouffers;
    % TODO
    % stoufferscfg.vout = @todo;
end