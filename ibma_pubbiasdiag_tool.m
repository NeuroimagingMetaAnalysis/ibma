%==========================================================================
%Creates the statistic map, opens the statistic map and adds the tools
%option for voxel diagnosis.
%
%masking - the masking job structure.
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%outDir - the directory for output.
%statType - the statistic type the user has requested.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function ibma_pubbiasdiag_tool(masking, ConE, ConSE, dir, statType, estimator, weighting, sampleSizes)
    
    
    addpath(fullfile(fileparts(mfilename('fullpath')), 'ibma_lib', 'Preprocessing'));
    addpath(fullfile(fileparts(mfilename('fullpath')), 'ibma_lib', 'Publication_bias'));
    addpath(fullfile(fileparts(mfilename('fullpath')), 'ibma_lib', 'Heterogeneity_measures'));
    
    %Create the map the user has specified.
    if strcmp(statType, 'EggerRegression')
        dataStruct = createRegress(masking, ConE', ConSE', dir, weighting);
        mapName = [weighting, estimator, 'RegressionMap.nii'];
    elseif strcmp(statType, 'MacaskillRegression')
        dataStruct = createRegress(masking, ConE', ConSE', dir, 'm', sampleSizes);
        mapName = ['m', estimator, 'RegressionMap.nii'];
    elseif strcmp(statType, 'TrimAndFill')
        dataStruct = createTrimAndFill(masking, ConE', ConSE', dir);
        mapName = [estimator, 'TrimAndFillMap.nii'];
    else
        dataStruct = createBeggsCorrelation(masking, ConE', ConSE', dir);
        mapName = [estimator, 'BeggsCorrelationMap.nii'];
    end
    
    pubBiasImageDisplay(0, 0, dir, mapName, dataStruct);
 
end