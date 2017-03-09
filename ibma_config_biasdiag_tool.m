%==========================================================================
%Configures the job layout for the bias diagnosis tool.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function diagbiasconfig = ibma_config_biasdiag_tool()
    
%--------------------------------------------------------------------------
% Masking
%--------------------------------------------------------------------------

    masking = ibma_config_masking();
    
%--------------------------------------------------------------------------
% StatType
%--------------------------------------------------------------------------

    statType = ibma_config_biasStatType();
  

%--------------------------------------------------------------------------
% Overall configuration.
%--------------------------------------------------------------------------
    
    diagbiasconfig = cfg_exbranch;
    diagbiasconfig.tag     = 'diagbias';
    diagbiasconfig.name    = 'Diagnose Bias';
    diagbiasconfig.val     = {statType masking};
    diagbiasconfig.help    = {'Display bias statistic map for further diagnosis.'};
    diagbiasconfig.prog = @ibma_run_biasdiag_tool;
    diagbiasconfig.check = @ibma_check_biasdiag_tool;
    
end

function t = ibma_check_biasdiag_tool(job)
    t={};
end