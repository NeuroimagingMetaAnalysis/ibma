%==========================================================================
%Configures the job layout for the hetdiagnosis tool.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function diaghetconfig = ibma_config_hetdiag_tool()

%--------------------------------------------------------------------------
% Masking
%--------------------------------------------------------------------------

    masking = ibma_config_masking();

%--------------------------------------------------------------------------
% statType
%--------------------------------------------------------------------------

    statType = ibma_config_hetStatType();
    
%--------------------------------------------------------------------------
% dataLeaf
%--------------------------------------------------------------------------

    dataLeaf = ibma_config_data(0);

%--------------------------------------------------------------------------
% diaghetconfig menu
%--------------------------------------------------------------------------
    
    diaghetconfig = cfg_exbranch;
    diaghetconfig.tag     = 'diaghet';
    diaghetconfig.name    = 'Diagnose Heterogeneity';
    diaghetconfig.val     = {statType dataLeaf masking};
    diaghetconfig.help    = {'Display Heterogeniety statistic map for further diagnosis.'};
    diaghetconfig.prog = @ibma_run_hetdiag_tool;
    diaghetconfig.check = @ibma_check_hetdiag_tool;
end

function t = ibma_check_hetdiag_tool(job)
    t={};
end