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

function ibma_hetdiag_tool(masking, contrastPaths, contrastSEPaths, outDir, statType)

    addpath(fullfile(fileparts(mfilename('fullpath')), 'ibma_lib', 'Heterogeneity_measures'));
    
    %Created the map the user has specified and open it.
    dataStruct = createHetMeasure(masking, contrastPaths', contrastSEPaths', outDir);
    if isfield(statType, 'statType_Q')
        mapName = 'QHeterogeneityMap.nii';
    elseif isfield(statType, 'statType_I2')
        mapName = 'I2HeterogeneityMap.nii';
    else 
        mapName = 'PHeterogeneityMap.nii';
    end
    
    hetImageDisplay(0, 0, outDir, mapName, dataStruct);
    
end