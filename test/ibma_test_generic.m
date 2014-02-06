classdef ibma_test_generic < matlab.unittest.TestCase
% IBMA_TEST_GENERIC    Generic function to perorm non-regression tests in 
% IBMA toolbox. 
%   Check that results obtained using the current version of the software 
%   are identical to the results computed with an earlier version.
%
%   See also IBMA_TEST_FISHERS, IBMA_TEST_STOUFFERS.
%
%   ibma_test_generic()

% Copyright (C) 2014 The University of Warwick
% Id: ibma_test_generic.m  IBMA toolbox
% Camille Maumet
    properties
        testName; % Name of current test
        testDataDir; % Path to test data directory.
        groundTruthDir; % Path to Ground Truth directory.
        currentDir; % Path to all tests result directory;
        
        analysisDir; % Path to current test result directory
    end
    
    methods (TestMethodSetup)
        function set_test_data_dir(myTest)
            global testDataDir;
            ibma_test_config();
            
            if isempty(testDataDir)
                error('Test data directory not set, please update ibma_test_config');
            end
            
            myTest.testDataDir = testDataDir;
            myTest.currentDir = fullfile(myTest.testDataDir, 'current');
            if ~exist(myTest.currentDir, 'dir')
                mkdir(myTest.currentDir);
            end
            myTest.groundTruthDir = fullfile(myTest.testDataDir, 'GT');
            if ~exist(myTest.groundTruthDir, 'dir')
                mkdir(myTest.groundTruthDir);
            end
        end
    end
    
    methods
        function delete_previous_results(myTest)
            SPMmatFile = spm_select('FPList', myTest.analysisDir, '^SPM\.mat$');
            spmStatFiles = spm_select('FPList', myTest.analysisDir, ...
                '^(beta_|spmT_|con_)\d\d\d\d\.(img|hdr|nii)$');
            spmOtherStatFiles = spm_select('FPList', myTest.analysisDir, ...
                '^(mask|ResMS|RPV).(img|hdr|nii)$');
            
            stoufferStatFile = spm_select('FPList', myTest.analysisDir, '^(stouffers|fishers)_(ffx|rfx)_statistic\.nii$');
            stoufferProbaFile = spm_select('FPList', myTest.analysisDir, '^(stouffers|fishers)_(ffx|rfx)_minus_log10_p\.nii$');
            
            
            filesToDelete = cellstr(strvcat(SPMmatFile, spmStatFiles, ...
                spmOtherStatFiles, stoufferStatFile, stoufferProbaFile));
                
            if ~isempty(filesToDelete)
                for i = 1:numel(filesToDelete)
                    if ~isempty(filesToDelete{i})
                        delete(filesToDelete{i});
                    end
                end
            end
        end
    end
end