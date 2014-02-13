classdef ibma_test_mega_rfx < ibma_test_generic
% IBMA_TEST_MEGA_RFX    Perform non-regression tests third-level 
% of a hierarachical GLM using FFX (at the third-level only) and OLS.
%   Check that results obtained using the current version of the software 
%   are identical to the results computed with an earlier version.
%
%   Usage:
%   Run all tests
%   tests=ibma_test_mega_rfx;res=run(tests)
%   Run a specific test
%   tests=ibma_test_mega_rfx;res=run(tests, 'test_mega_rfx_1')
% 
%   See also IBMA_TEST_STOUFFERS.
%
%   ibma_test_mega_rfx()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_test_mega_rfx.m  IBMA toolbox
% Camille Maumet

    properties

    end
    
    methods (TestMethodSetup)

    end

    methods (Test)
        % Nominal test
        function test_mega_rfx_1(myTest)          
            myTest.testName = 'mega_rfx_1';
            myTest.analysisDir = fullfile(myTest.currentDir, myTest.testName);
            if ~exist(myTest.analysisDir, 'dir')
                mkdir(myTest.analysisDir);
            end
            
            myTest.delete_previous_results();

            matlabbatch{1}.spm.tools.ibma.megarfx.dir = {myTest.analysisDir};
            matlabbatch{1}.spm.tools.ibma.megarfx.confiles = cellstr(...
                spm_select('ExtFPList',myTest.testDataDir, '^conFiles\.nii$', 1:1000));
            
            spm_jobman('run', matlabbatch)
            
            newStatFile = spm_select('FPList', myTest.analysisDir, '^spmT_0001\.img$');
            newProbaFile = spm_select('FPList', myTest.analysisDir, '^mega_rfx_minus_log10_p\.nii$');
            gtStatFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^spmT_0001\.img$');
            gtProbaFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^mega_ffx_ols_ffx_minus_log10_p\.nii$');
            
            newStatData = spm_read_vols(spm_vol(newStatFile));
            gtStatData = spm_read_vols(spm_vol(gtStatFile));
            
            % Remove NaN's as we are comparing with FSL results which are
            % not exactly identical in terms of masking
            myTest.verifyEqual(newStatData(find(~isnan(newStatData(:)))), ...
                gtStatData(find(~isnan(newStatData(:)))), 'AbsTol', 10^-5)
            
            newProbaData = spm_read_vols(spm_vol(newProbaFile));
            gtProbaData = spm_read_vols(spm_vol(gtProbaFile));
            myTest.verifyEqual(newProbaData, gtProbaData, 'AbsTol', 0)
        end
    end
    
    methods
        
    end
end