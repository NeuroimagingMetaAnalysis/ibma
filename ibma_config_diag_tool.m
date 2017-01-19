%==========================================================================
%Configures the job layout for the diagnosis tool.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function diaghetconfig = ibma_config_diag_tool()


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

    commoncfg = {dir scans1 scans2};
    statType = ibma_config_statType();
  
    diaghetconfig = cfg_exbranch;
    diaghetconfig.tag     = 'DiagHet';
    diaghetconfig.name    = 'Diagnose Heterogeneity';
    diaghetconfig.val     = {commoncfg{:} statType};
    diaghetconfig.help    = {'Display Heterogeniety statistic map for further diagnosis.'};
    diaghetconfig.prog = @ibma_run_diag_tool;
    diaghetconfig.check = @ibma_check_diag_tool;
end

function t = ibma_check_diag_tool(job)
    t={};
end