classdef ibma_test_stouffers < ibma_test_generic
% IBMA_TEST_STOUFFERS    Perform non-regression tests on Stouffer's 
% meta-analysis in IBMA toolbox. 
%   Check that results obtained using the current version of the software 
%   are identical to the results computed with an earlier version.
%
%   Usage:
%   Run all tests
%   tests=ibma_test_stouffers;res=run(tests)
%   Run a specific test
%   tests=ibma_test_stouffers;res=run(tests, 'test_stouffers_1')
% 
%   See also IBMA_TEST_FISHERS.
%
%   ibma_test_stouffers()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_test_stouffers.m  IBMA toolbox
% Camille Maumet

    properties

    end
    
    methods (TestMethodSetup)

    end

    methods (Test)
        % Nominal test
        function test_stouffers_1(myTest)          
            myTest.testName = 'stouffers_1';
            myTest.analysisDir = fullfile(myTest.currentDir, myTest.testName);
            
            if ~exist(myTest.analysisDir, 'dir')
                mkdir(myTest.analysisDir);
            end
            
            myTest.delete_previous_results();

            matlabbatch{1}.spm.tools.ibma.stoufferscfg.dir = {myTest.analysisDir};
            matlabbatch{1}.spm.tools.ibma.stoufferscfg.zimages = cellstr(...
                spm_select('ExtFPList',myTest.testDataDir, '^zstat_studies\.nii$',1:21));
            matlabbatch{1}.spm.tools.ibma.stoufferscfg.rfx.RFX_no = 0;
            
            spm_jobman('run', matlabbatch)
            
            newStatFile = spm_select('FPList', myTest.analysisDir, '^stouffers_ffx_statistic\.nii$');
            newProbaFile = spm_select('FPList', myTest.analysisDir, '^stouffers_ffx_minus_log10_p\.nii$');
            gtStatFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^zstat_ols_z\.nii$');
            gtProbaFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^stouffers_ffx_minus_log10_p\.nii$');
            
            newStatData = spm_read_vols(spm_vol(newStatFile));
            gtStatData = spm_read_vols(spm_vol(gtStatFile));
            myTest.verifyEqual(newStatData, gtStatData, 'AbsTol', 10^-3)
            
            newProbaData = spm_read_vols(spm_vol(newProbaFile));
            gtProbaData = spm_read_vols(spm_vol(gtProbaFile));
            myTest.verifyEqual(newProbaData, gtProbaData, 'AbsTol', 0)
        end
        
        % Random-effects
        function test_stouffers_rfx(myTest)            
            myTest.testName = 'stouffers_rfx';
            myTest.analysisDir = fullfile(myTest.currentDir, myTest.testName);
            
            myTest.delete_previous_results();
                        
            matlabbatch{1}.spm.tools.ibma.stoufferscfg.dir = {...
                fullfile(myTest.testDataDir, 'current', myTest.testName)};
            % Test is computed based on 5 first studies
            matlabbatch{1}.spm.tools.ibma.stoufferscfg.zimages = cellstr(...
                spm_select('ExtFPList',myTest.testDataDir,'^zstat_studies\.nii$',1:5));
            matlabbatch{1}.spm.tools.ibma.stoufferscfg.rfx.RFX_yes = 1;
            
            spm_jobman('run', matlabbatch)
            
            newStatFile = spm_select('FPList', myTest.analysisDir, '^spmT_0001\.img$');
            newProbaFile = spm_select('FPList', myTest.analysisDir, '^stouffers_rfx_minus_log10_p\.nii$');
            gtStatFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^spmT_0001\.img$');
            gtProbaFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^stouffers_isRFX_minus_log10_p\.nii$');
            
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