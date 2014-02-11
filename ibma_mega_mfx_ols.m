function ibma_mega_mfx_ols(outDir, conFiles)
% IBMA_STOUFFERS Run third-level of a hierarachical GLM using MFX 
% and Ordinary Least-Squares (OLS).
%   IBMA_MEGA_MFX_OLS(OUTDIR, CONTRASTFILES) perform the third-level of a 
%   hierarachical GLM using MFX on contrast estimate CONFILES and store the 
%   results in OUTDIR. 
%
%   See also IBMA_FISHERS.
%
%   ibma_mega_mfx_ols(outDir, conFiles)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_mega_mfx_ols.m  IBMA toolbox
% Camille Maumet

    nStudies = numel(conFiles); % number of studies  
    disp(['Computing MFX OLS mega-analysis on ' num2str(nStudies) ' studies.'])

    if ~exist(outDir, 'dir')
        mkdir(outDir);
    end
       
    %     statFile = fullfile(outDir, 'mega_ffx_ols_statistic.nii');
    dof = nStudies - 1;

    % Compute a one-sample t-test on conFiless
    matlabbatch{1}.spm.stats.factorial_design.dir = {outDir};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = conFiles;

    matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(outDir, 'SPM.mat')};

    matlabbatch{3}.spm.stats.con.spmmat = {fullfile(outDir, 'SPM.mat')};
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'group effect';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;

    spm_jobman('run', matlabbatch);

    statFile = spm_select('FPList', outDir, '^spmT_0001\.img$');

    clear matlabbatch;
    
    matlabbatch{1}.spm.util.imcalc.input = {statFile};
    matlabbatch{1}.spm.util.imcalc.output = 'mega_mfx_ols_minus_log10_p.nii';
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = ['-log10(cdf(''T'',-i1, ' num2str(dof) '))'];
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;

    spm_jobman('run', matlabbatch);
end