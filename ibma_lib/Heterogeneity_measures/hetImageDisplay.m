%==========================================================================
%Display an image and add menu options. This function takes in 6 inputs.
%
%src, event - these are needed for event handling for the SPM gui.
%dir - the directory of the map.
%mapName - the name of the map to display. 
%dataStruct - the data read in.
%
%Authors: Thomas Maullin
%==========================================================================

function hetImageDisplay(src, event, dir, mapName, dataStruct)

    delete(spm_figure('FindWin','Graphics'));
    spm_image('Display', fullfile(dir, mapName));

    %Add the map switch options to the toolbar.
    ToolsMenu = findall(gcf, 'tag', 'figMenuTools');
    mapSwitch = uimenu('Label','Switch Map', 'Parent',ToolsMenu,'Separator','on');

    if ~contains(mapName, 'Q')
        uimenu('Label','Q Map', 'Parent', mapSwitch, 'Callback',{@hetImageDisplay, dir, 'QHeterogeneityMap.nii', dataStruct});
    end
    if ~contains(mapName, 'I2')
        uimenu('Label','I Squared Map', 'Parent', mapSwitch, 'Callback',{@hetImageDisplay, dir, 'I2HeterogeneityMap.nii', dataStruct});
    end
    if ~contains(mapName, 'PH')
        uimenu('Label','P-Value Map', 'Parent', mapSwitch, 'Callback',{@hetImageDisplay, dir, 'PHeterogeneityMap.nii', dataStruct});
    end

    %Add the voxel plot options to the toolbar.
    voxelPlot = uimenu('Label','Voxel Plot', 'Parent',ToolsMenu,'Separator','on');

    %Add plot options to the voxel plots.
    uimenu('Label','Forest Plot', 'Parent',voxelPlot, 'Callback',{@forestPlot, dataStruct});

end