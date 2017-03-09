%==========================================================================
%Creates the statistic map, opens the statistic map and adds the tools
%option for voxel diagnosis.
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%outDir - the directory for output.
%statType - the statistic type the user has requested.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function ibma_biasdiag_tool(ConE, ConSE, dir, statType, estimator, weighting, sampleSizes)
    
    
    addpath(fullfile(fileparts(mfilename('fullpath')), 'ibma_lib', 'Preprocessing'));
    addpath(fullfile(fileparts(mfilename('fullpath')), 'ibma_lib', 'Publication_bias'));
    addpath(fullfile(fileparts(mfilename('fullpath')), 'ibma_lib', 'Heterogeneity_measures'));
    
    %Create the map the user has specified.
    if strcmp(statType, 'EggerRegression')
        createRegress(ConE', ConSE', dir, weighting);
        mapName = [weighting, estimator, 'RegressionMap.nii'];
    elseif strcmp(statType, 'MacaskillRegression')
        createRegress(ConE', ConSE', dir, 'm', sampleSizes);
        mapName = ['m', estimator, 'RegressionMap.nii'];
    elseif strcmp(statType, 'TrimAndFill')
        createTrimAndFill(ConE', ConSE', dir);
        mapName = [estimator, 'TrimAndFillMap.nii'];
    else
        createBeggsCorrelation(ConE', ConSE', dir);
        mapName = [estimator, 'BeggsCorrelationMap.nii'];
    end
        
    %Display the image.
    spm_image('Display', fullfile(dir, mapName));
    
    %Add the voxel diagnosis to the toolbar.
    ToolsMenu = findall(gcf, 'tag', 'figMenuTools');
    voxelPlot = uimenu('Label','Voxel Plot', 'Parent',ToolsMenu,'Separator','on');
    
    %Add plot options to the voxel plots.
    uimenu('Label','Funnel Plot', 'Parent',voxelPlot, 'Callback',{@funnelPlot, ConE', ConSE'});
    uimenu('Label','Galbraith Plot', 'Parent',voxelPlot, 'Callback',{@galbraithPlot, ConE', ConSE'});
 
end