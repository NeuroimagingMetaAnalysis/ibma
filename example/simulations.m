function simulations()
% SIMULATIONS    Perform simulations based on IBMA toolbox. 
%
%   simulations()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_test_stouffers.m  IBMA toolbox
% Camille Maumet

    % Number of subject per study
    nSubjects = [25 400 100 25]; %[10, 15, 20, 25, 30, 10, 15, 20, 25, 30, 10, 15, 20, 25, 30];
    nStudies = numel(nSubjects);
    
%     nStudies = 5;
%     nSubjects = get_n_subjects_per_studies(nStudies);
    
    % Common level of (intra-studies) variance (ignoring effect of sample 
    % size).
    sigmaSquare = 4;
    
    % Between-studies variance (RFX?)
    sigmaBetweenStudies = 0;
    
    % Study-specific variance (i.e. common study-variance divided by sample
    % size).
    sigmaSquareStudies = sigmaSquare./nSubjects;
    
    % Size of the simulation image (in 1 direction). Each voxel of the
    % simulation image is a simulation sample.
    nSimuOneDir = 10;
    nSimu = nSimuOneDir^3;
    
    % Directory to store the simulation data and results.
    simulationDir = fullfile(pwd, 'simulations');
    
    % Directory to store the simulation data.
    dataDir = fullfile(simulationDir, 'data');
    mkdir(dataDir);
    
    % --- Simulated data ---
    
    % For each study involved in the current meta-analysis
    for iStudy = 1:nStudies
        
        % Degrees of freedom of the within-study variance estimate
        dof = nSubjects(iStudy)-1;
        
        % Estimated variance (from chi square distribution)
        estimatedSigmaSquare = chi2rnd(dof, nSimuOneDir, nSimuOneDir, nSimuOneDir)*sigmaSquareStudies(iStudy)/dof;
        
        % Estimated paramater estimate.
        estimatedContrast = normrnd(0, sqrt(sigmaSquareStudies(iStudy)), nSimuOneDir, nSimuOneDir, nSimuOneDir);
        
        % Write out parameter estimates.      
        conFiles{iStudy} = fullfile(dataDir, ['con_st' num2str(iStudy) ' .nii']);
        vol    = struct('fname',  conFiles{iStudy},...
                   'dim',    [nSimuOneDir nSimuOneDir nSimuOneDir],...
                   'dt',     [spm_type('float32') spm_platform('bigend')],...
                   'mat',    eye(4),...
                   'pinfo',  [1 0 0]',...
                   'descrip','simulation');
        vol    = spm_create_vol(vol);
        spm_write_vol(vol, estimatedContrast);
        
        % Write out estimated variance of parameter estimates.
        varConFiles{iStudy} = fullfile(dataDir, ['varcon_st' num2str(iStudy) ' .nii']);
        vol.fname =  varConFiles{iStudy};
        spm_write_vol(vol, estimatedSigmaSquare);
        
        % Write out corresponding z-values.
        zFiles{iStudy} = fullfile(dataDir, ['z_st' num2str(iStudy) ' .nii']);
        vol.fname = zFiles{iStudy};
        spm_write_vol(vol, estimatedContrast./sqrt(estimatedSigmaSquare));
    end
    
    % --- Compute meta-analysis ---
    
    % Stouffer's
    stoufferDir = fullfile(simulationDir, 'stouffers');
    mkdir(stoufferDir);
    matlabbatch{1}.spm.tools.ibma.stoufferscfg.dir = {stoufferDir};
    matlabbatch{1}.spm.tools.ibma.stoufferscfg.zimages = zFiles;
    matlabbatch{1}.spm.tools.ibma.stoufferscfg.rfx.RFX_no = 1;

    % Optimally weighted z
    weightedZDir = fullfile(simulationDir, 'weightedZ');
    mkdir(weightedZDir);
    matlabbatch{2}.spm.tools.ibma.weightedz.dir = {weightedZDir};
    matlabbatch{2}.spm.tools.ibma.weightedz.zimages = zFiles;
    matlabbatch{2}.spm.tools.ibma.weightedz.nsubjects = nSubjects;
    
    % Mega-analysis FFX using OLS
    megaFfxOlsDir = fullfile(simulationDir, 'megaFFXOLS');
    mkdir(megaFfxOlsDir);
    matlabbatch{4}.spm.tools.ibma.megaffxols.dir = {megaFfxOlsDir};
    matlabbatch{4}.spm.tools.ibma.megaffxols.confiles = conFiles;
    
    % Mega-analysis FFX
    megaFfxDir = fullfile(simulationDir, 'megaFFX');
    mkdir(megaFfxDir);
    matlabbatch{3}.spm.tools.ibma.megaffx.dir = {megaFfxDir};
    matlabbatch{3}.spm.tools.ibma.megaffx.nsubjects = nSubjects;
    matlabbatch{3}.spm.tools.ibma.megaffx.confiles = conFiles;
    matlabbatch{3}.spm.tools.ibma.megaffx.varconfiles = varConFiles;

%     % TODO: Permutation on conFiles
%     matlabbatch{5}.spm.tools.snpm.des.OneSampT.DesignName = 'MultiSub: One Sample T test on diffs/contrasts';
%     matlabbatch{5}.spm.tools.snpm.des.OneSampT.DesignFile = 'snpm_bch_ui_OneSampT';
%     permutConDir = fullfile(simulationDir, 'permutCon');
%     mkdir(permutConDir);
%     matlabbatch{5}.spm.tools.snpm.des.OneSampT.dir = {permutConDir};
%     matlabbatch{5}.spm.tools.snpm.des.OneSampT.P = conFiles;
%     matlabbatch{6}.spm.tools.snpm.cp.spmmat = fullfile(permutConDir, 'SnPM.mat');
% 
    spm_jobman('run', matlabbatch)
    probaStouffers = spm_read_vols(spm_vol(spm_select('FPList', stoufferDir, '.*_minus_log10_p\.nii$')));   
    simu.stouffers = get_proba_CI(probaStouffers(:), nSimuOneDir);
    
    probaWeighted = spm_read_vols(spm_vol(spm_select('FPList', weightedZDir, '.*_minus_log10_p\.nii$')));
    simu.weightedZ = get_proba_CI(probaWeighted(:), nSimuOneDir);
    
    probaMegaffx = spm_read_vols(spm_vol(spm_select('FPList', megaFfxDir, '.*_minus_log10_p\.nii$')));
    simu.megaFfx = get_proba_CI(probaMegaffx(:), nSimuOneDir);

    probaMegaffxOLS = spm_read_vols(spm_vol(spm_select('FPList', megaFfxOlsDir, '.*_minus_log10_p\.nii$')));
    simu.megaFfxOls = get_proba_CI(probaMegaffxOLS(:), nSimuOneDir);

    simu.nSubjects = nSubjects;
    simu.nStudies = nStudies;
    simu.sigmaSquare = sigmaSquare;
    simu.sigmaSquareStudies = sigmaSquareStudies;
    simu.sigmaBetweenStudies = sigmaBetweenStudies;
    simu.nSimuOneDir = nSimuOneDir;
    
    save(fullfile(simulationDir, 'simu.mat'), 'simu')
end

% Compute confidance intervals
function res = get_proba_CI(values, nSimuOneDir)
    if ~all(size(values) == nSimuOneDir)
        values = reshape(values, [nSimuOneDir, nSimuOneDir, nSimuOneDir]);
    end
    
    repeats = sum(sum(values > -log10(0.05), 3), 2)./(nSimuOneDir^2);

    m = mean(repeats);
    s = std(repeats);
    confidenceInterval = [m - 1.96*s; m + 1.96*s];
    
    res.stderror = s;
    res.mean = m;
    res.CI = confidenceInterval;
    res.string = ['CI = [' num2str(confidenceInterval(1)), ' ; ' num2str(confidenceInterval(2)) ']' ...
                ' - avg=' num2str(m) ', std_est=' num2str(s)];
end

% Get number of subject per studies (50% between 20 and 25, 25% between 10
% and 20 and 25% between 25 and 35)
function nSubjects = get_n_subjects_per_studies(nStudies)
    nSubjects = [20 25 10 50];
    nPreDefined = 4;
    
    if nStudies < nPreDefined
        nSubjects = nSubjects(1:nStudies);
    elseif nStudies > nPreDefined
        rng(3)

        quarter = round((nStudies-nPreDefined)/4);
        half = nStudies - nPreDefined - 2*quarter;
        nSubjects = [ nSubjects (randi(5,1,half) + 20), ...
                      (randi(10,1,quarter) + 10), ...
                      (randi(25,1,quarter) + 25);];
    end
    
end