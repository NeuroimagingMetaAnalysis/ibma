function ibma_fishers(zFiles, outDir)
% IBMA_FISHERS Run Fisher's meta-analysis as in Fisher, R.A. Statistical 
% Methods for Research Workers 1932. 
%   IBMA_FISHERS(ZFILES, OUTDIR, ISRFX) perform Fisher's meta-analysis on
%   z-statistics images ZFILES and store the results in OUTDIR. 
%
%   See also IBMA_STOUFFERS.
%
%   ibma_fishers(zFiles, outDir)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_fishers.m  IBMA toolbox
% Camille Maumet

    nStudies = numel(zFiles); % number of studies  
    disp(['Computing Fisher''s meta-analysis on ' num2str(nStudies) ' studies.'])

    statFile = fullfile(outDir, 'fishers_ffx_statistic.nii');
    rfxffx = 'ffx';

    % Get the statistic
    %     P_i = normcdf(-z_i)
    %     stat = -2 sum( log10(P_i) )
    matlabbatch{1}.spm.util.imcalc.input = zFiles;
    matlabbatch{1}.spm.util.imcalc.output = statFile;
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = '-2*sum( log(normcdf(-X)) )';
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

    spm_jobman('run', matlabbatch);
    clear matlabbatch;

    % Get the probability
    matlabbatch{1}.spm.util.imcalc.input = {statFile};
    matlabbatch{1}.spm.util.imcalc.output = ['fishers_' rfxffx '_minus_log10_p.nii'];
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = ['-log10(cdf(''chi2'',i1, 2*' num2str(nStudies) ', ''upper''))'];
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;

    spm_jobman('run', matlabbatch);
end