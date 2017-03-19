%==========================================================================
%Configures the job layout for the publication bias diagnosis tool.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function diagbiasconfig = ibma_config_pubbiasdiag_tool()
    
%--------------------------------------------------------------------------
% Masking
%--------------------------------------------------------------------------

    masking = ibma_config_masking();
    
%--------------------------------------------------------------------------
% StatType
%--------------------------------------------------------------------------

    statType = ibma_config_pubbiasStatType();
  

%--------------------------------------------------------------------------
% Overall configuration.
%--------------------------------------------------------------------------
    
    diagbiasconfig = cfg_exbranch;
    diagbiasconfig.tag     = 'diagbias';
    diagbiasconfig.name    = 'Diagnose Publication Bias';
    diagbiasconfig.val     = {statType masking};
    diagbiasconfig.help    = {'Display bias statistic map for further diagnosis.'};
    diagbiasconfig.prog = @ibma_run_pubbiasdiag_tool;
    diagbiasconfig.check = @ibma_check_pubbiasdiag_tool;
    
end

function t = ibma_check_pubbiasdiag_tool(job)
    t={};
end