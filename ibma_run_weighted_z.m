function ibma_run_weighted_z(job)
% IBMA_RUN_WEIGHTED_Z Get a job and parse it to run Fisher's meta-analysis.
%   IBMA_RUN_WEIGHTED_Z(job) parse the job structure and call IBMA 
%   functions to perform optimally weighted-z meta-analysis as in 
%   D.V. Zaykin, Journal of Evolutionary Biology 2011.
%
%   See also IBMA_RUN_FISHERS, IBMA_RUN_STOUFFERS.
%
%   ibma_run_weigthed_z(job)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_run_weighted_z.m  IBMA toolbox
% Camille Maumet

    ibma_weighted_z(job.zimages, job.dir{1}, job.nsubjects)
end