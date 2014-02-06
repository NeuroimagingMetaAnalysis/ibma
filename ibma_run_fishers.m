function ibma_run_fishers(job)
% IBMA_RUN_FISHERS Get a job and parse it to run Fisher's meta-analysis.
%   IBMA_RUN_FISHERS(job) parse the job structure and call IBMA functions
%   to run Fisher's meta-analysis as in Fisher, R.A. Statistical Methods 
%   for Research Workers 1932.
%
%   See also IBMA_RUN_STOUFFERS.
%
%   ibma_run_fishers(job)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_run_fishers.m  IBMA toolbox
% Camille Maumet

    ibma_fishers(job.zimages, job.dir{1})
end