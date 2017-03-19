%==========================================================================
%This function runs the publication Bias toolbox option tests.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function runTest_pubBias()

    %Clear previous classes.
    clear all;

    %Setup steps for the test.
    datapath = fullfile(fileparts(mfilename('fullpath')),'..', 'ibma_data');
    mkdir(datapath);
    mkdir(fullfile(datapath, 'NIDM-packs'));
    
    %Download data.
    for i = 1:21
        dataPath_temp = [datapath, filesep, 'pain_', num2str(i, '%02d')];
        mkdir(dataPath_temp);
        zipPath = [datapath, filesep, 'NIDM-Packs', filesep, 'pain_', num2str(i, '%02d'), '.nidm.zip'];
        websave(zipPath, ['http://neurovault.org/collections/HJLBXBNL/pain_', num2str(i, '%02d'), '.nidm.zip']);
 	 	unzip(zipPath, [dataPath_temp, filesep]);
    end
    
    %Unzip contrasts and contrast standard errors for the first 9 datasets.
    for i = 1:9
        dataPath_temp = [datapath, filesep, 'pain_', num2str(i, '%02d')];
 	 	gunzip([dataPath_temp, filesep, 'Contrast.nii.gz'], [dataPath_temp, filesep]);
 	 	gunzip([dataPath_temp, filesep, 'ContrastStandardError.nii.gz'], [dataPath_temp, filesep]);
    end
    
    %Run all tests.
    tests = matlab.unittest.TestSuite.fromFile(which('ibma_test_pubBias'));
    result = run(tests)
    
    rmdir(datapath, 's');

end