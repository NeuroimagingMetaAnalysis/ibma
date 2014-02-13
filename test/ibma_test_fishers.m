classdef ibma_test_fishers < ibma_test_generic
% IBMA_TEST_FISHERS    Perform non-regression tests on Fisher's 
% meta-analysis in IBMA toolbox. 
%   Check that results obtained using the current version of the software 
%   are identical to the results computed with an earlier version.
%
%   Usage:
%   Run all tests
%   tests=ibma_test_fisher;res=run(tests)
%   Run a specific test
%   tests=ibma_test_fisher;res=run(tests, 'test_fisher_1')
% 
%   See also IBMA_TEST_STOUFFERS.
%
%   ibma_test_fisher()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_test_fisher.m  IBMA toolbox
% Camille Maumet

    properties

    end
    
    methods (TestMethodSetup)

    end

    methods (Test)
        % Nominal test
        function test_fisher_1(myTest)          
            myTest.testName = 'fisher_1';
            myTest.analysisDir = fullfile(myTest.currentDir, myTest.testName);
            if ~exist(myTest.analysisDir, 'dir')
                mkdir(myTest.analysisDir);
            end
            
            myTest.delete_previous_results();

            matlabbatch{1}.spm.tools.ibma.fishers.dir = {myTest.analysisDir};
            % Test is computed based on 5 first studies
            matlabbatch{1}.spm.tools.ibma.fishers.zimages = cellstr(...
                spm_select('ExtFPList',myTest.testDataDir, '^zstat_studies\.nii$',1:5));
            
            spm_jobman('run', matlabbatch)
            
            newStatFile = spm_select('FPList', myTest.analysisDir, '^fishers_ffx_statistic\.nii$');
            newProbaFile = spm_select('FPList', myTest.analysisDir, '^fishers_ffx_minus_log10_p\.nii$');
            gtStatFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^fishers_ffx_statistic\.nii$');
            gtProbaFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^fishers_ffx_minus_log10_p\.nii$');
            
            newStatData = spm_read_vols(spm_vol(newStatFile));
            gtStatData = spm_read_vols(spm_vol(gtStatFile));
            myTest.verifyEqual(newStatData, gtStatData, 'AbsTol', 0)
            
            newProbaData = spm_read_vols(spm_vol(newProbaFile));
            gtProbaData = spm_read_vols(spm_vol(gtProbaFile));
            myTest.verifyEqual(newProbaData, gtProbaData, 'AbsTol', 0)
        end
    end
    
    methods
        
    end
end