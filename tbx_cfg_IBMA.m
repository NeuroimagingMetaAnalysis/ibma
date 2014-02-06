function ibma = tbx_cfg_ibma()
% TBX_CFG_IBMA Start-up function of Image-Based Meta-Analysis (IBMA) 
% toolbox.
%   ibma = TBX_CFG_IBMA() Define the matlabbatch job structure for
%   image-based meta-analysis.
%
%   See also IBMA_CFG_FISHERS, IBMA_CFG_STOUFFERS.
%
%   ibma = tbx_cfg_IBMA()

% Copyright (C) 2014 The University of Warwick
% Id: tbx_cfg_IBMA.m  IBMA toolbox
% Camille Maumet

  toolboxDir = spm_str_manip(mfilename('fullpath'), 'h');
  addpath(toolboxDir);
  addpath(fullfile(toolboxDir, 'test'));
  
  % IBMA Tools
  ibma         = cfg_choice;
  ibma.tag     = 'IBMA';
  ibma.name    = 'Image-Based Meta-Analysis Tools';
  ibma.help    = {
                    'Image-Based NeuroImaging Meta-Analysis.'
  }';
  ibma.values  = {ibma_cfg_stouffers ibma_cfg_fishers ibma_cfg_weighted_z};
  
end
