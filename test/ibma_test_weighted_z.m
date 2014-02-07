classdef ibma_test_weighted_z < ibma_test_generic
% IBMA_TEST_WEIGHTED_Z    Perform non-regression tests on optimally
% weighted-z meta-analysis in IBMA toolbox. 
%   Check that results obtained using the current version of the software 
%   are identical to the results computed with an earlier version.
%
%   Usage:
%   Run all tests
%   tests=ibma_test_weighted_z;res=run(tests)
%   Run a specific test
%   tests=ibma_test_weighted_z;res=run(tests, 'test_weighted_z_1')
% 
%   See also IBMA_TEST_FISHERS, IBMA_TEST_STOUFFERS.
%
%   ibma_test_weighted_z()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_test_weighted_z.m  IBMA toolbox
% Camille Maumet

    properties

    end
    
    methods (TestMethodSetup)

    end

    methods (Test)
        % Nominal test
        function test_weighted_z_1(myTest)          
            myTest.testName = 'weighted_z_1';
            myTest.analysisDir = fullfile(myTest.currentDir, myTest.testName);
            if ~exist(myTest.analysisDir, 'dir')
                mkdir(myTest.analysisDir);
            end
            
            myTest.delete_previous_results();

            matlabbatch{1}.spm.tools.ibma.weightedz.dir = {myTest.analysisDir};
            % Test is computed based on 5 first studies
            matlabbatch{1}.spm.tools.ibma.weightedz.zimages = cellstr(...
                spm_select('ExtFPList',myTest.testDataDir, '^zstat_studies\.nii$',1:21));
            matlabbatch{1}.spm.tools.ibma.weightedz.nsubjects = ...
                [25 25 20 20 9 9 9 12 12 12 12 13 9 12 14 14 12 12 16 16 16];
            
            spm_jobman('run', matlabbatch)
            
            newStatFile = spm_select('FPList', myTest.analysisDir, '^weightedz_ffx_statistic\.nii$');
            newProbaFile = spm_select('FPList', myTest.analysisDir, '^weightedz_ffx_minus_log10_p\.nii$');
            gtStatFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^zstat_wls_z_ni\.nii$');
            gtProbaFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^weightedz_ffx_minus_log10_p\.nii$');
            
            newStatData = spm_read_vols(spm_vol(newStatFile));
            gtStatData = spm_read_vols(spm_vol(gtStatFile));
            myTest.verifyEqual(newStatData, gtStatData, 'AbsTol', 10^-3)
            
            newProbaData = spm_read_vols(spm_vol(newProbaFile));
            gtProbaData = spm_read_vols(spm_vol(gtProbaFile));
            myTest.verifyEqual(newProbaData, gtProbaData, 'AbsTol', 0)
        end
    end
    
    methods
        
    end
end
