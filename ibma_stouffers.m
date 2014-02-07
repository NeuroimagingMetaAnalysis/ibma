function ibma_stouffers(zFiles, outDir, isRFX)
% IBMA_STOUFFERS Run Stouffer's meta-analysis in S.A. Stouffer et al. The 
% American Soldier 1949.
%   IBMA_STOUFFERS(ZFILES, OUTDIR, ISRFX) perform Stouffer's meta-analysis 
%   on z-statistics images ZFILES and store the results in OUTDIR. Use
%   fixed-effects (original approach) if ISRFX is false and use
%   random-effects (as "Stouffer's MFX" in G. Salimi-khorshidi et al. 
%   NeuroImage 2009) if ISRFX is true.
%
%   Default values for ISRFX is false.
%
%   See also IBMA_FISHERS.
%
%   ibma_stouffers(zFiles, outDir, isRFX)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_stouffers.m  IBMA toolbox
% Camille Maumet

    nStudies = numel(zFiles); % number of studies  
    disp(['Computing meta-analysis on ' num2str(nStudies) ' studies.'])

    if ~exist(outDir, 'dir')
        mkdir(outDir);
    end

    if ~isRFX
        statFile = fullfile(outDir, 'stouffers_ffx_statistic.nii');
        rfxffx = 'ffx';

        % Get the statistic
        matlabbatch{1}.spm.util.imcalc.input = zFiles;
        matlabbatch{1}.spm.util.imcalc.output = statFile;
        matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
        matlabbatch{1}.spm.util.imcalc.expression = ['sum(X)./sqrt(' num2str(nStudies) ')'];
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

        spm_jobman('run', matlabbatch);
        
        probaExpression = 'normcdf(-i1, 0, 1)';

    else
        %     statFile = fullfile(outDir, 'stouffers_rfx_statistic.nii');
        rfxffx = 'rfx';

        % Compute a one-sample t-test on z
        matlabbatch{1}.spm.stats.factorial_design.dir = {outDir};
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = zFiles;

        matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(outDir, 'SPM.mat')};

        matlabbatch{3}.spm.stats.con.spmmat = {fullfile(outDir, 'SPM.mat')};
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'group effect';
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;

        spm_jobman('run', matlabbatch);

        statFile = spm_select('FPList', outDir, '^spmT_0001\.img$');
        dof = nStudies - 1;
        probaExpression = ['cdf(''T'', -i1, ' num2str(dof) ')'];
    end
    clear matlabbatch;
    
    matlabbatch{1}.spm.util.imcalc.input = {statFile};
    matlabbatch{1}.spm.util.imcalc.output = ['stouffers_' rfxffx '_minus_log10_p.nii'];
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = ['-log10(' probaExpression ')'];
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;

    spm_jobman('run', matlabbatch);
end