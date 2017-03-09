function dataEntry = ibma_config_data(withSampleSizes)
 % IBMA_CONFIG_FFXRFX  Define the matlabbatch job structure for selection 
 % of Ramdon-effects (RFX) or Fixed-effects (FFX) procedure.
 %   ffxrfx = IBMA_CONFIG_FFXRFX() return the matlabbatch configuration to 
 %   select Fixed-Effects or Random-Effects procedure.
 %
 %   ffxrfx = ibma_config_ffxrfx()
  
 % Copyright (C) 2014 The University of Warwick
 % Id: ibma_config_ffxrfx.m  IBMA toolbox
 % Camille Maumet
 
    dir = ibma_config_analysis_dir();

    scans1         = cfg_files;
    scans1.tag     = 'ConE';
    scans1.name    = 'Contrast Estimates';
    scans1.help    = {'Select the contrast estimate maps.'};
    scans1.filter = 'image';
    scans1.ufilter = '.*';
    scans1.num     = [1 Inf];  

    scans2         = cfg_files;
    scans2.tag     = 'ConSE';
    scans2.name    = 'Contrast Standard Errors';
    scans2.help    = {'Select the contrast standard error maps.'};
    scans2.filter = 'image';
    scans2.ufilter = '.*';
    scans2.num     = [1 Inf];  
    
    dataEntry_nidmPacks         = cfg_files;
    dataEntry_nidmPacks.tag     = 'dataEntry_nidmPacks';
    dataEntry_nidmPacks.name    = 'NIDM packs';
    dataEntry_nidmPacks.help    = {'Select the NIDM zip files.'};
    dataEntry_nidmPacks.filter = 'image';
    dataEntry_nidmPacks.ufilter = '.nidm.zip';
    dataEntry_nidmPacks.num     = [1 Inf];  
    
    if withSampleSizes
        sampleSizes        = ibma_config_nsubjects();
        commoncfg          = {dir scans1 scans2 sampleSizes};
    else 
        commoncfg          = {dir scans1 scans2};
    end
    
    dataEntry_files         = cfg_exbranch;
    dataEntry_files.name    = 'Individual Files';
    dataEntry_files.tag     = 'dataEntry_files';
    dataEntry_files.val     = {commoncfg{:}};
    
    dataEntry_nidm          = cfg_exbranch;
    dataEntry_nidm.name     = 'NIDM Input';
    dataEntry_nidm.tag      = 'dataEntry_nidm';
    dataEntry_nidm.val      = {dir dataEntry_nidmPacks};
    
    dataEntry         = cfg_choice;
    dataEntry.name    = 'Select input type:';
    dataEntry.tag     = 'dataEntry';
    dataEntry.values  = {dataEntry_nidm, dataEntry_files};
 
end