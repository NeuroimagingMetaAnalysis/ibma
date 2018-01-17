%==========================================================================
%Runs the heterogeneity diagnosis tool.
%
%job - the matlab job specified by ibma_config_hetdiag_tool
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function ibma_run_hetdiag_tool(job)
    
    dataEntry = job.dataEntry;
    masking = job.masking;

    %Retrieve the data from inside dataEntry.
    if isfield(dataEntry, 'dataEntry_files')
        ConE = dataEntry.dataEntry_files.ConE;
        ConSE = dataEntry.dataEntry_files.ConSE;
        dir = dataEntry.dataEntry_files.dir;
    else
        [ConE, ConSE] = obtainNIDMData(dataEntry.dataEntry_nidm.dataEntry_nidmPacks, dataEntry.dataEntry_nidm.dataEntry_exNums);
        dir = dataEntry.dataEntry_nidm.dir;
    end

    ibma_hetdiag_tool(masking, ConE, ConSE, dir{1}, job.statType);
    
end