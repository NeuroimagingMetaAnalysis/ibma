%==========================================================================
%Display an image and add menu options. This function takes in 5 inputs.
%
%src, event - these are needed for event handling for the SPM gui.
%dir - the directory of the map.
%mapName - the name of the map to display. 
%dataStruct - the data read in.
%
%Authors: Thomas Maullin
%==========================================================================

function pubBiasImageDisplay(src, event, dir, mapName, dataStruct)

    %Remove previous menu options and display the image.
    delete(spm_figure('FindWin','Graphics'));
    spm_image('Display', fullfile(dir, mapName));

    %Add the map switch options to the toolbar.
    ToolsMenu = findall(gcf, 'tag', 'figMenuTools');
    mapSwitch = uimenu('Label','Switch Map', 'Parent',ToolsMenu,'Separator','on');
    
    if contains(mapName, 'eu') && contains(mapName, 'Regression')
        %If we're looking at egger unweighted regression we need options
        %for either intercept p-values or just p-values.
        if contains(mapName, 'pi')
            uimenu('Label','Intercept Map', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'euiRegressionMap.nii', dataStruct});
        else
            uimenu('Label','P-Value Map', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'eupiRegressionMap.nii', dataStruct});
        end
    elseif contains(mapName, 'ew') && contains(mapName, 'Regression')
        %If we're looking at egger weighted regression we need options
        %for either intercept p-values or just intercept values.
        if contains(mapName, 'pi')
            uimenu('Label','Intercept Map', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'ewiRegressionMap.nii', dataStruct});
        else
            uimenu('Label','P-Value Map', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'ewpiRegressionMap.nii', dataStruct});
        end
    elseif contains(mapName, 'm') && contains(mapName, 'Regression')
        %If we're looking macaskill regression we need options for either
        %slope p-values or just slope values.
        if contains(mapName, 'ps')
            uimenu('Label','Intercept Map', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'msRegressionMap.nii', dataStruct});
        else
            uimenu('Label','P-Value Map', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'mpsRegressionMap.nii', dataStruct});
        end
    elseif contains(mapName, 'TrimAndFill')
        %If we're looking Trim And Fill we need options for the estimators
        %not already displayed.
        if ~contains(mapName, 'RT')
            uimenu('Label','R Estimator', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'RTrimAndFillMap.nii', dataStruct});
        end
        if ~contains(mapName, 'QT')
            uimenu('Label','Q Estimator', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'QTrimAndFillMap.nii', dataStruct});
        end
        if ~contains(mapName, 'LT')
            uimenu('Label','L Estimator', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'LTrimAndFillMap.nii', dataStruct});
        end
    else
        %If we're looking Beggs Correlation we need options for the 
        %estimators not already displayed.
        if ~contains(mapName, 'zB')
            uimenu('Label','z Estimator', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'zBeggsCorrelationMap.nii', dataStruct});
        end
        if ~contains(mapName, 'tB')
            uimenu('Label','t Estimator', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'tBeggsCorrelationMap.nii', dataStruct});
        end
        if ~contains(mapName, 'pB')
            uimenu('Label','p Estimator', 'Parent', mapSwitch, 'Callback',{@pubBiasImageDisplay, dir, 'pBeggsCorrelationMap.nii', dataStruct});
        end
    end
    
    %Add the voxel plot options to the toolbar.
    voxelPlot = uimenu('Label','Voxel Plot', 'Parent',ToolsMenu,'Separator','on');
    
    %Add plot options to the voxel plots.
    uimenu('Label','Funnel Plot', 'Parent',voxelPlot, 'Callback',{@funnelPlot, dataStruct});
    uimenu('Label','Galbraith Plot', 'Parent',voxelPlot, 'Callback',{@galbraithPlot, dataStruct});

end