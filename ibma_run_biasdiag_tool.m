%==========================================================================
%Runs the bias diagnosis tool.
%
%job - the matlab job specified by ibma_config_biasdiag_tool
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function ibma_run_biasdiag_tool(job)
    
    %Work out what type of map we are creating.
    if isfield(job.statType, 'statType_trimAndFill')
        statType = 'TrimAndFill';
        
        %Work out which Trim and Fill estimator we are using and retrieve the data.
        if isfield(job.statType.statType_trimAndFill, 'statType_trimAndFill_Q')
            estimator = 'Q';
            dataEntry = job.statType.statType_trimAndFill.statType_trimAndFill_Q.dataEntry;
        elseif isfield(job.statType.statType_trimAndFill, 'statType_trimAndFill_R')            
            estimator = 'R';
            dataEntry = job.statType.statType_trimAndFill.statType_trimAndFill_R.dataEntry;
        else
            estimator = 'L';
            dataEntry = job.statType.statType_trimAndFill.statType_trimAndFill_L.dataEntry;
        end
        
    elseif isfield(job.statType, 'statType_BeggsCorrelation')
        statType = 'BeggsCorrelation';
        
        %Find out which estimator we are using and retrieve the data.
        if isfield(job.statType.statType_BeggsCorrelation, 'statType_BeggsCorrelation_p')
            estimator = 'p';
            dataEntry = job.statType.statType_BeggsCorrelation.statType_BeggsCorrelation_p.dataEntry;
        elseif isfield(job.statType.statType_BeggsCorrelation, 'statType_BeggsCorrelation_z')            
            estimator = 'z';
            dataEntry = job.statType.statType_BeggsCorrelation.statType_BeggsCorrelation_z.dataEntry;
        else
            estimator = 't';
            dataEntry = job.statType.statType_BeggsCorrelation.statType_BeggsCorrelation_t.dataEntry;
        end
        
    elseif isfield(job.statType, 'statType_EggerRegression')
        statType = 'EggerRegression';
        
        %Find out whether we are performing weighted or unweighted regression.
        if isfield(job.statType.statType_EggerRegression, 'statType_EggerRegression_unweighted')
            weighting = 'eu';
            
            %Obtain the estimator.
            if isfield(job.statType.statType_EggerRegression.statType_EggerRegression_unweighted,...
                    'statType_EggerRegression_unweighted_pVal')
                estimator = 'pi';
                dataEntry = job.statType.statType_EggerRegression.statType_EggerRegression_unweighted.statType_EggerRegression_unweighted_pVal.dataEntry;
            else
                estimator = 'i';
                dataEntry = job.statType.statType_EggerRegression.statType_EggerRegression_unweighted.statType_EggerRegression_unweighted_intercepts.dataEntry;
            end
        else
            weighting = 'ew';
            
            %Obtain the estimator.
            if isfield(job.statType.statType_EggerRegression.statType_EggerRegression_weighted,...
                    'statType_EggerRegression_weighted_pVal')
                estimator = 'pi';
                dataEntry = job.statType.statType_EggerRegression.statType_EggerRegression_weighted.statType_EggerRegression_weighted_pVal.dataEntry;
            else
                estimator = 'i';
                dataEntry = job.statType.statType_EggerRegression.statType_EggerRegression_weighted.statType_EggerRegression_weighted_intercepts.dataEntry;
            end
        end
            
    else
        statType = 'MacaskillRegression';
        
        %Obtain the estimator.
        if isfield(job.statType.statType_MacaskillRegression, 'statType_MacaskillRegression_pVal')
            estimator = 'ps';
            dataEntry = job.statType.statType_MacaskillRegression.statType_MacaskillRegression_pVal.dataEntry;
        else
            estimator = 's';
            dataEntry = job.statType.statType_MacaskillRegression.statType_MacaskillRegression_slope.dataEntry;
        end

    end
    
    sampleSizes = '';
    %Retrieve the data from inside dataEntry.
    if isfield(dataEntry, 'dataEntry_files')
        ConE = dataEntry.dataEntry_files.ConE;
        ConSE = dataEntry.dataEntry_files.ConSE;
        dir = dataEntry.dataEntry_files.dir;
        if isfield(dataEntry.dataEntry_files, 'nSubjects')
            sampleSizes = dataEntry.nSubjects;
        end
    else
        [ConE, ConSE, sampleSizes] = obtainNIDMData(dataEntry_nidm.dataEntry_nidmPacks);%funct to write
        dir = dataEntry.dataEntry_nidmPacks.dir;
    end
    
    if ~isempty(sampleSizes)
        ibma_biasdiag_tool(ConE, ConSE, dir{1}, statType, estimator, 0, sampleSizes);
    elseif strcmp(statType, 'EggerRegression')
        ibma_biasdiag_tool(ConE, ConSE, dir{1}, statType, estimator, weighting);
    else 
        ibma_biasdiag_tool(ConE, ConSE, dir{1}, statType, estimator);
    end
    
end