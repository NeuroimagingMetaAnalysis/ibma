%==========================================================================
%Runs the diagnosis tool.
%
%job - the matlab job specified by ibma_config_diag_tool
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function ibma_run_diag_tool(job)

    ibma_diag_tool(job.ConE, job.ConSE, job.dir{1},job.statType);
    
end