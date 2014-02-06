function ibma_test_config()
% IBMA_TEST_CONFIG() Configuration file for testing IBMA toolbox.
%
%   Update this file to specify your testing data directory.
%
%   ibma_test_config()
%
% Copyright (C) 2014 The University of Warwick
% Id: ibma_test_config.m  IBMA toolbox
% Camille Maumet

    global testDataDir;

    % In testDataDir you must find: a 4D file called zstudies.nii containing 
    % z-statistic volumes (1 per study).
    
    testDataDir = ''; % Set path to your test data here
end