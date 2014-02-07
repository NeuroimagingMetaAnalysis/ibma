function ibma_run_mega_ffx(job)
% IBMA_RUN_MEGA_FFX  Get a job and parse it to run third-level of a 
% hierarachical GLM using FFX (at the third-level only).
%
%   See also IBMA_RUN_STOUFFERS.
%
%   ibma_mega_ffx(job)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_mega_ffx.m  IBMA toolbox
% Camille Maumet

    ibma_mega_ffx(job.dir{1}, job.confiles, job.varconfiles, job.nsubjects)
end