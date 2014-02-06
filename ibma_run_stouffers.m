function ibma_run_stouffers(job)
% IBMA_RUN_STOUFFERS Get a job and parse it to run Stouffer's 
% meta-analysis.
%   IBMA_RUN_STOUFFERS(job) parse the job structure and call IBMA functions
%   to run Stouffer's meta-analysis as in S.A. Stouffer et al. The American 
%   Soldier 1949.
%
%   See also IBMA_RUN_FISHERS.
%
%   ibma_run_stouffers(job)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_run_stouffers.m  IBMA toolbox
% Camille Maumet

	ibma_stouffers(job.zimages, job.dir{1}, isfield(job.rfx, 'RFX_yes'))
end
