%==========================================================================
%Unit tests for testing features of the publication bias options in the 
%ibma toolbox. To run the below run the runTest_het function.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

classdef ibma_test_het < matlab.unittest.TestCase
       
    methods
        %Function for deleting any previous nii files.
        function deleteNII(testCase, data_path)
            close all;
            %Delete the study number map.
            index = fullfile(data_path, 'studyNumberMap.nii');
            if exist(index, 'file')
                delete(index);
            end
            %Delete the Q map.
            index = fullfile(data_path, 'QHeterogeneityMap.nii');
            if exist(index, 'file')
                delete(index);
            end
            %Delete the I2 map.
            index = fullfile(data_path, 'I2HeterogeneityMap.nii');
            if exist(index, 'file')
                delete(index);
            end
            %Delete the -logP map.
            index = fullfile(data_path, 'PHeterogeneityMap.nii');
            if exist(index, 'file')
                delete(index);
            end
        end
    end
        
    methods(Test)
        
        %Check the Q-statistic runs correctly
        function qStatistic(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_Q = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConE = {...
                                  [fullfile(data_input_path, 'pain_01','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','Contrast.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConSE = {...
                                  [fullfile(data_input_path, 'pain_01','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','ContrastStandardError.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch);
            deleteNII(testCase, data_output_path);
        end
        
        %Check the I2-statistic runs correctly
        function I2Statistic(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_I2 = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConE = {...
                                  [fullfile(data_input_path, 'pain_01','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','Contrast.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConSE = {...
                                  [fullfile(data_input_path, 'pain_01','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','ContrastStandardError.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch);
            deleteNII(testCase, data_output_path);
        end
        
        %Check the P values run correctly
        function PStatistic(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_NLogP = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConE = {...
                                  [fullfile(data_input_path, 'pain_01','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','Contrast.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConSE = {...
                                  [fullfile(data_input_path, 'pain_01','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','ContrastStandardError.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch);
            deleteNII(testCase, data_output_path);
        end
        
        %Check the Q statistic runs correctly with nidm input.
        function QStatistic_nidm(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data', 'NIDM-Packs');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_Q = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dataEntry_nidmPacks = {...
                          fullfile(data_input_path, 'pain_01.nidm.zip')
                          fullfile(data_input_path, 'pain_02.nidm.zip')
                          fullfile(data_input_path, 'pain_03.nidm.zip')
                          fullfile(data_input_path, 'pain_04.nidm.zip')
                          fullfile(data_input_path, 'pain_05.nidm.zip')
                          fullfile(data_input_path, 'pain_06.nidm.zip')
                          fullfile(data_input_path, 'pain_07.nidm.zip')
                          fullfile(data_input_path, 'pain_08.nidm.zip')
                          fullfile(data_input_path, 'pain_09.nidm.zip')
                          fullfile(data_input_path, 'pain_10.nidm.zip')
                          fullfile(data_input_path, 'pain_11.nidm.zip')
                          fullfile(data_input_path, 'pain_12.nidm.zip')
                          fullfile(data_input_path, 'pain_13.nidm.zip')
                          fullfile(data_input_path, 'pain_14.nidm.zip')
                          fullfile(data_input_path, 'pain_15.nidm.zip')
                          fullfile(data_input_path, 'pain_16.nidm.zip')
                          fullfile(data_input_path, 'pain_17.nidm.zip')
                          fullfile(data_input_path, 'pain_18.nidm.zip')
                          fullfile(data_input_path, 'pain_19.nidm.zip')
                          fullfile(data_input_path, 'pain_20.nidm.zip')
                          fullfile(data_input_path, 'pain_21.nidm.zip')
                          };
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dataEntry_exNums = [1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1];
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch); 
            deleteNII(testCase, data_output_path);
        end
        
        %Check the P-values run correctly with nidm input.
        function PStatistic_nidm(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data', 'NIDM-Packs');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_NLogP = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dataEntry_nidmPacks = {...
                          fullfile(data_input_path, 'pain_01.nidm.zip')
                          fullfile(data_input_path, 'pain_02.nidm.zip')
                          fullfile(data_input_path, 'pain_03.nidm.zip')
                          fullfile(data_input_path, 'pain_04.nidm.zip')
                          fullfile(data_input_path, 'pain_05.nidm.zip')
                          fullfile(data_input_path, 'pain_06.nidm.zip')
                          fullfile(data_input_path, 'pain_07.nidm.zip')
                          fullfile(data_input_path, 'pain_08.nidm.zip')
                          fullfile(data_input_path, 'pain_09.nidm.zip')
                          fullfile(data_input_path, 'pain_10.nidm.zip')
                          fullfile(data_input_path, 'pain_11.nidm.zip')
                          fullfile(data_input_path, 'pain_12.nidm.zip')
                          fullfile(data_input_path, 'pain_13.nidm.zip')
                          fullfile(data_input_path, 'pain_14.nidm.zip')
                          fullfile(data_input_path, 'pain_15.nidm.zip')
                          fullfile(data_input_path, 'pain_16.nidm.zip')
                          fullfile(data_input_path, 'pain_17.nidm.zip')
                          fullfile(data_input_path, 'pain_18.nidm.zip')
                          fullfile(data_input_path, 'pain_19.nidm.zip')
                          fullfile(data_input_path, 'pain_20.nidm.zip')
                          fullfile(data_input_path, 'pain_21.nidm.zip')
                          };
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dataEntry_exNums = [1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1];
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch); 
            deleteNII(testCase, data_output_path);
        end
        
        %Check the I^2 statistic runs correctly with nidm input.
        function I2Statistic_nidm(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data', 'NIDM-Packs');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_I2 = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dataEntry_nidmPacks = {...
                          fullfile(data_input_path, 'pain_01.nidm.zip')
                          fullfile(data_input_path, 'pain_02.nidm.zip')
                          fullfile(data_input_path, 'pain_03.nidm.zip')
                          fullfile(data_input_path, 'pain_04.nidm.zip')
                          fullfile(data_input_path, 'pain_05.nidm.zip')
                          fullfile(data_input_path, 'pain_06.nidm.zip')
                          fullfile(data_input_path, 'pain_07.nidm.zip')
                          fullfile(data_input_path, 'pain_08.nidm.zip')
                          fullfile(data_input_path, 'pain_09.nidm.zip')
                          fullfile(data_input_path, 'pain_10.nidm.zip')
                          fullfile(data_input_path, 'pain_11.nidm.zip')
                          fullfile(data_input_path, 'pain_12.nidm.zip')
                          fullfile(data_input_path, 'pain_13.nidm.zip')
                          fullfile(data_input_path, 'pain_14.nidm.zip')
                          fullfile(data_input_path, 'pain_15.nidm.zip')
                          fullfile(data_input_path, 'pain_16.nidm.zip')
                          fullfile(data_input_path, 'pain_17.nidm.zip')
                          fullfile(data_input_path, 'pain_18.nidm.zip')
                          fullfile(data_input_path, 'pain_19.nidm.zip')
                          fullfile(data_input_path, 'pain_20.nidm.zip')
                          fullfile(data_input_path, 'pain_21.nidm.zip')
                          };
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_nidm.dataEntry_exNums = [1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1
                                                                     1];
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch); 
            deleteNII(testCase, data_output_path);
        end
        
        %Check a job with percentage masking works.
        function mask_percentage(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_Q = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConE = {...
                                  [fullfile(data_input_path, 'pain_01','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','Contrast.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConSE = {...
                                  [fullfile(data_input_path, 'pain_01','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','ContrastStandardError.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tmp.pthresh = 70;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch);
            deleteNII(testCase, data_output_path);
        end
        
        %Check a job with relative masking works.
        function mask_relative(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_Q = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConE = {...
                                  [fullfile(data_input_path, 'pain_01','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','Contrast.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','Contrast.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConSE = {...
                                  [fullfile(data_input_path, 'pain_01','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_02','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_03','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_04','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_05','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_06','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_07','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_08','ContrastStandardError.nii'),',1'];...
                                  [fullfile(data_input_path, 'pain_09','ContrastStandardError.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tmr.rthresh = 5;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch);
            deleteNII(testCase, data_output_path);
        end
        
        %Check a job with no implicit mask works.
        function mask_noImp(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_Q = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConE = {...
                      [fullfile(data_input_path, 'pain_01','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_02','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_03','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_04','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_05','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_06','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_07','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_08','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_09','Contrast.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConSE = {...
                      [fullfile(data_input_path, 'pain_01','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_02','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_03','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_04','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_05','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_06','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_07','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_08','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_09','ContrastStandardError.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {''};
            spm_jobman('run', matlabbatch);
            deleteNII(testCase, data_output_path);
        end
        
        %Check a job with an explicit mask works.
        function mask_exp(testCase)
            data_output_path = fullfile(fileparts(mfilename('fullpath')), '..');
            data_input_path = fullfile(fileparts(mfilename('fullpath')), '..', 'ibma_data');
            matlabbatch{1}.spm.tools.ibma.diaghet.statType.statType_Q = 0;
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.dir = {data_output_path};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConE = {...
                      [fullfile(data_input_path, 'pain_01','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_02','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_03','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_04','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_05','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_06','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_07','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_08','Contrast.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_09','Contrast.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.dataEntry.dataEntry_files.ConSE = {...
                      [fullfile(data_input_path, 'pain_01','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_02','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_03','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_04','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_05','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_06','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_07','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_08','ContrastStandardError.nii'),',1'];...
                      [fullfile(data_input_path, 'pain_09','ContrastStandardError.nii'),',1']};
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.im = 1;
            matlabbatch{1}.spm.tools.ibma.diaghet.masking.em = {[fullfile(data_input_path, 'temp.nii'),',1']};
            websave([data_input_path filesep 'temp.nii.gz'], 'http://neurovault.org/media/images/1290/TPJ_Mask.nii.gz');
            gunzip([data_input_path filesep 'temp.nii.gz'], data_input_path);
            spm_jobman('run', matlabbatch);
            deleteNII(testCase, data_output_path);
        end
    end
end