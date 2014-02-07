function ibma_run_mega_ffx_ols(job)
% IBMA_RUN_MEGA_FFX_OLS Get a job and parse it to run the third-level of a 
% hierarachical GLM using FFX (at the third-level only) and ordinary 
% least-squares (OLS).
%   IBMA_RUN_MEGA_FFX_OLS(job) parse the job structure and call IBMA 
%   functions to run the third-level of a hierarachical GLM using FFX 
%   (at the third-level only) and ordinary least-squares (OLS).
%
%   See also IBMA_RUN_FISHERS.
%
%   ibma_run_mega_ffx_ols(job)

% Copyright (C) 2014 The University of Warwick
% Id: ibma_run_mega_ffx_ols.m  IBMA toolbox
% Camille Maumet

	ibma_mega_ffx_ols(job.dir{1}, job.confiles)
end