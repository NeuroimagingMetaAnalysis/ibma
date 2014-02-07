function ibma_mega_ffx(outDir, contrastFiles, varContrastFiles, nSubjects)
% IBMA_MEGA_FFX Run third-level of a hierarachical GLM using FFX 
% (at the third-level only).
%   IBMA_MEGA_FFX(OUTDIR, CONTRASTFILES, VARCONTRASTFILES) perform 
%   third-level of a hierarachical GLM using FFX on contrast estimate 
%   CONTRASTFILES (with contrast variance VARCONTRASTFILES) and 
%   store the results in OUTDIR. 
%
%   See also IBMA_STOUFFERS.
%
%   ibma_third_level_ffx(contrastFiles, outDir)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_mega_ffx.m  IBMA toolbox
% Camille Maumet

    nStudies = numel(contrastFiles); % number of studies  
    disp(['Computing mega-analysis (with third-level FFX) on ' num2str(nStudies) ' studies.'])

    statFile = fullfile(outDir, 'mega_ffx_statistic.nii');
    rfxffx = 'ffx';

    % Get the statistic
    %   mega-analysis (FFX)
    %   hat_beta_wls = 1 / sum ( 1/ sigma^2_i ) sum ( cope_i / sigma^2_i )
    %   Cov(hat_beta_ls) = 1 / sum ( 1/ sigma^2_i )
    %   stat_wls = 1 / sqrt( sum ( 1/ sigma^2_i ) ) sum ( cope_i / sigma^2_i )
    exprSumVar = 'sqrt(1./(';
    exprSumCopeVar = '(';
    for i = 1:nStudies
        exprSumVar = [exprSumVar '1./i' num2str(i+nStudies) '+'];
        exprSumCopeVar = [exprSumCopeVar 'i' num2str(i) './i' num2str(i+nStudies) '+'];
    end
    exprSumVar(end:end+1) = '))';
    exprSumCopeVar(end) = ')';
    
    matlabbatch{1}.spm.util.imcalc.input = [contrastFiles ;varContrastFiles];
    matlabbatch{1}.spm.util.imcalc.output = statFile;
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = [exprSumVar '.*' exprSumCopeVar];
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

    spm_jobman('run', matlabbatch);
    clear matlabbatch;
    
    dof = sum(nSubjects)-1;

    % Get the probability
    matlabbatch{1}.spm.util.imcalc.input = {statFile};
    matlabbatch{1}.spm.util.imcalc.output = ['mega_ffx_' rfxffx '_minus_log10_p.nii'];
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = ['-log10(cdf(''T'', -i1, ' num2str(dof) '))'];
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;

    spm_jobman('run', matlabbatch);
end