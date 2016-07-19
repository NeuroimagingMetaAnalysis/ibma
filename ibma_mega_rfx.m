function ibma_mega_rfx(outDir, model)
% IBMA_MEGA_RFX Run third-level of a hierarachical GLM using MFX 
% and Ordinary Least-Squares (OLS).
%   IBMA_MEGA_RFX(OUTDIR, CONTRASTFILES) perform the third-level of a 
%   hierarachical GLM using MFX on contrast estimate CONFILES and store the 
%   results in OUTDIR. 
%
%   See also IBMA_FISHERS.
%
%   ibma_mega_rfx(outDir, conFiles)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_mega_rfx.m  IBMA toolbox
% Camille Maumet

    if ~exist(outDir, 'dir')
        mkdir(outDir);
    end
    
    matlabbatch{1}.spm.stats.factorial_design.dir = {outDir};
    
    if isfield(model, 'one')
        % Compute a one-sample t-test on conFiless  
        
        conFiles = model.one.confiles;
        nStudies = numel(conFiles); % number of studies  

        %     statFile = fullfile(outDir, 'mega_ffx_ols_statistic.nii');
        dof = nStudies - 1;

        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(strvcat(conFiles));
        
        matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(outDir, 'SPM.mat')};

        matlabbatch{3}.spm.stats.con.spmmat = {fullfile(outDir, 'SPM.mat')};
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'group effect';
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;        
    elseif isfield(model, 'two')
        % Compute a two-sample t-test on conFiless  
        conFiles1 = model.two.confiles1;
        conFiles2 = model.two.confiles2;      
        
        nStudies = numel(conFiles1) + numel(conFiles2); % number of studies
        
        dof = nStudies - 2;
        
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1= cellstr(strvcat(conFiles1));
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2= cellstr(strvcat(conFiles2));
        matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 0;

        matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(outDir, 'SPM.mat')};
        
        matlabbatch{3}.spm.stats.con.spmmat = {fullfile(outDir, 'SPM.mat')};
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'bewteen group effect';
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];

    else
        error(['Unrecognised models ' fiednames(model)])
    end

    disp(['Computing RFX mega-analysis on ' num2str(nStudies) ' studies.'])
    spm_jobman('run', matlabbatch);

    statFile = spm_select('FPList', outDir, '^spmT_0001\.(img|nii)$');

    clear matlabbatch;
    
    matlabbatch{1}.spm.util.imcalc.input = {statFile};
    matlabbatch{1}.spm.util.imcalc.output = 'mega_rfx_minus_log10_p.nii';
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = ['-log10(cdf(''T'',-i1, ' num2str(dof) '))'];
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;

    spm_jobman('run', matlabbatch);
end