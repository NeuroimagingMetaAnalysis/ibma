function ibma_weighted_z(zFiles, outDir, nSubjects)
% IBMA_FISHERS Run optimally weighted-z meta-analysis as in D.V. Zaykin, 
% Journal of Evolutionary Biology 2011.
%   IBMA_WEIGHTED_Z(ZFILES, OUTDIR, NSUBJECTS) perform optimally 
%   weighted-z meta-analysis on z-statistics images ZFILES, with each 
%   NSUBJECTS subjects and store the results in OUTDIR. 
%
%   See also IBMA_FISHERS, IBMA_STOUFFERS.
%
%   ibma_weighted_z(zFiles, outDir)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_weighted_z.m  IBMA toolbox
% Camille Maumet

    nStudies = numel(zFiles); % number of studies  
    disp(['Computing optimally weighted-z meta-analysis on ' num2str(nStudies) ' studies.'])
    
    if true%~isRFX
        rfxffx = 'ffx';
        statFile = fullfile(outDir, 'weightedz_ffx_statistic.nii');
        
        expression = '';
        for i = 1:nStudies
            expression = [expression 'i' num2str(i) '*' num2str(sqrt(nSubjects(i))) '+'];
        end
        expression(end) = '';
        
        % Get the statistic
        % stat = sum(z_i * sqrt(n_i)) / sqrt( sum( n_i ) )
        % stat ~ N(0, 1)
        matlabbatch{1}.spm.util.imcalc.input = zFiles;
        matlabbatch{1}.spm.util.imcalc.output = statFile;
        matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
        matlabbatch{1}.spm.util.imcalc.expression = ['(' expression ')./' num2str(sqrt(sum(nSubjects)))];
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
        
        spm_jobman('run', matlabbatch);
        clear matlabbatch;
    else
    end

    % Get the probability
    matlabbatch{1}.spm.util.imcalc.input = {statFile};
    matlabbatch{1}.spm.util.imcalc.output = ['weightedz_' rfxffx '_minus_log10_p.nii'];
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = '-log10(normcdf(-i1))';
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;

    spm_jobman('run', matlabbatch);
end