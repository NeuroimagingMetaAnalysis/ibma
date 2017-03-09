%==========================================================================
%Runs the heterogeneity diagnosis tool.
%
%job - the matlab job specified by ibma_config_hetdiag_tool
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function ibma_run_hetdiag_tool(job)
    
    ibma_hetdiag_tool(job.ConE, job.ConSE, job.dir{1},job.statType);
    
end