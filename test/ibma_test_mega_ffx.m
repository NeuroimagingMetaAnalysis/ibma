classdef ibma_test_mega_ffx < ibma_test_generic
% IBMA_TEST_MEGA_FFX    Perform non-regression tests third-level 
% of a hierarachical GLM using FFX (at the third-level only).
%   Check that results obtained using the current version of the software 
%   are identical to the results computed with an earlier version.
%
%   Usage:
%   Run all tests
%   tests=ibma_test_mega_ffx;res=run(tests)
%   Run a specific test
%   tests=ibma_test_mega_ffx;res=run(tests, 'test_mega_ffx_1')
% 
%   See also IBMA_TEST_STOUFFERS.
%
%   ibma_test_mega_ffx()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_test_mega_ffx.m  IBMA toolbox
% Camille Maumet

    properties

    end
    
    methods (TestMethodSetup)

    end

    methods (Test)
        % Nominal test
        function test_mega_ffx_1(myTest)          
            myTest.testName = 'mega_ffx_1';
            myTest.analysisDir = fullfile(myTest.currentDir, myTest.testName);
            if ~exist(myTest.analysisDir, 'dir')
                mkdir(myTest.analysisDir);
            end
            
            myTest.delete_previous_results();

            matlabbatch{1}.spm.tools.ibma.megaffx.dir = {myTest.analysisDir};
            matlabbatch{1}.spm.tools.ibma.megaffx.confiles = cellstr(...
                spm_select('ExtFPList',myTest.testDataDir, '^conFiles\.nii$', 1:1000));
            matlabbatch{1}.spm.tools.ibma.megaffx.varconfiles = cellstr(...
                spm_select('ExtFPList',myTest.testDataDir, '^varConFiles\.nii$', 1:1000));
            matlabbatch{1}.spm.tools.ibma.megaffx.nsubjects = ...
                [313 zeros(1, 20)]%[25 25 20 20 9 9 9 12 12 12 12 13 9 12 14 14 12 12 16 16 16];
            
            spm_jobman('run', matlabbatch)
            
            newStatFile = spm_select('FPList', myTest.analysisDir, '^mega_ffx_statistic\.nii$');
            newProbaFile = spm_select('FPList', myTest.analysisDir, '^mega_ffx_ffx_minus_log10_p\.nii$');
            gtStatFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^tstat1\.nii$');
            gtProbaFile = spm_select('FPList', fullfile(myTest.groundTruthDir, myTest.testName), '^mega_ffx_ffx_minus_log10_p\.nii$');
            
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