function ibma_mega_ffx(outDir, contrastFiles, varContrastFiles, ...
    sampleSizesEqual, variancesEqual, nSubjects)
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

    % Very important to avoid confusion between contrast and variance maps
    if size(contrastFiles, 2) > 1
        contrastFiles = contrastFiles';
    end
    if size(varContrastFiles, 2) > 1
        varContrastFiles = varContrastFiles';
    end

    nStudies = numel(contrastFiles); % number of studies  
    disp(['Computing mega-analysis (with third-level FFX) on ' num2str(nStudies) ' studies.'])

    statFile = fullfile(outDir, 'mega_ffx_statistic.nii');
    rfxffx = 'ffx';
    
    % Number of studies        
    kExpr = num2str(nStudies);
    
    if variancesEqual
        if sampleSizesEqual
            contrastSumExpr = '';
            estimatedSigmaSquaredExpr = '';

            % Number of subjects in each study
            nExpr = num2str(nSubjects);

            for i = 1:nStudies
                conIdx = i;
                varIdx = i+nStudies;
                contrastSumExpr = [ contrastSumExpr 'i' num2str(conIdx) '+'];
                estimatedSigmaSquaredExpr = [estimatedSigmaSquaredExpr 'i' num2str(varIdx) '+'];
            end

            % Remove trailing '+'   
            estimatedSigmaSquaredExpr(end) = '';
            contrastSumExpr(end) = '';
            
            contrastSumExpr = ['(' contrastSumExpr ')'];
            
            % This is only needed because the variance estimate have already been divided by sample size;            
%             estimatedSigmaSquaredExpr = ['(' estimatedSigmaSquaredExpr ').*' nExpr];

            % Multiply by 1/k          
            estimatedSigmaSquaredExpr = ['1/' kExpr '.*(' estimatedSigmaSquaredExpr ')'];

            expr = ['1/sqrt(' kExpr ').*' contrastSumExpr './sqrt(' estimatedSigmaSquaredExpr './' nExpr ')'];

            % Degrees of freedom            
            dof = nStudies*(nSubjects-1);
        else           
            WeightedContrastSumExpr = '';
            estimatedSigmaSquaredExpr = '';
            for i = 1:nStudies
                conIdx = i;
                varIdx = i+nStudies;
                WeightedContrastSumExpr = [ WeightedContrastSumExpr 'i' num2str(conIdx) '.*' num2str(nSubjects(i)) '+'];
                
                % This is only needed because the variance estimate have already been divided by sample size;            
                estimatedSigmaSquaredExpr = [estimatedSigmaSquaredExpr 'i' num2str(varIdx) '.*' num2str(nSubjects(i)-1) '+'];
%                 estimatedSigmaSquaredExpr = [estimatedSigmaSquaredExpr 'i' num2str(varIdx) '.*' num2str(nSubjects(i)-1) '.*' num2str(nSubjects(i)) '+'];
            end
            % Remove trailing '+'   
            WeightedContrastSumExpr(end) = '';
            estimatedSigmaSquaredExpr(end) = '';
            
            WeightedContrastSumExpr = ['(' WeightedContrastSumExpr ')'];
            
            % Multiply by 1/sum(ni-1)          
            estimatedSigmaSquaredExpr = ['1/' num2str(sum(nSubjects-1)) '.*(' estimatedSigmaSquaredExpr ')'];
            
            expr = ['1/sqrt(' num2str(sum(nSubjects)) ').*' WeightedContrastSumExpr './sqrt(' estimatedSigmaSquaredExpr ')'];
            
            % Degrees of freedom            
            dof = sum(nSubjects-1);       
        end
    else
        error('Unequal variances not available yet')
    end

%     % Get the statistic
%     %   mega-analysis (FFX)
%     %   hat_beta_wls = 1 / sum ( 1/ sigma^2_i ) sum ( cope_i / sigma^2_i )
%     %   Cov(hat_beta_ls) = 1 / sum ( 1/ sigma^2_i )
%     %   stat_wls = 1 / sqrt( sum ( 1/ sigma^2_i ) ) sum ( cope_i / sigma^2_i )
%     exprSumVar = 'sqrt(1./(';
%     exprSumCopeVar = '(';
%     for i = 1:nStudies
%         exprSumVar = [exprSumVar '1./i' num2str(i+nStudies) '+'];
%         exprSumCopeVar = [exprSumCopeVar 'i' num2str(i) './i' num2str(i+nStudies) '+'];
%     end
%     exprSumVar(end:end+1) = '))';
%     exprSumCopeVar(end) = ')';
    
    matlabbatch{1}.spm.util.imcalc.input = [contrastFiles ;varContrastFiles];
    matlabbatch{1}.spm.util.imcalc.output = statFile;
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = expr;% [exprSumVar '.*' exprSumCopeVar];
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

    spm_jobman('run', matlabbatch);
    clear matlabbatch;
    
%     dof = sum(nSubjects-1)-1;

    % Get the probability
    matlabbatch{1}.spm.util.imcalc.input = {statFile};
    matlabbatch{1}.spm.util.imcalc.output = ['mega_ffx_' rfxffx '_minus_log10_p.nii'];
    matlabbatch{1}.spm.util.imcalc.outdir = {outDir};
    matlabbatch{1}.spm.util.imcalc.expression = ['-log10(cdf(''T'', -i1, ' num2str(dof) '))'];
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;

    spm_jobman('run', matlabbatch);
end