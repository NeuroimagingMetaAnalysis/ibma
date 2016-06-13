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

    equalFields = {'variances', 'samplesize'};
    
    for f = 1:numel(equalFields)
        if isfield(job.(equalFields{f}), 'equal')
            equal.(equalFields{f}) = true;
        elseif isfield(job.(equalFields{f}), 'unequal')
            equal.(equalFields{f}) = false;
        else
            error(['Unexpected value for job.' equalFields{f}])
        end
    end
    
    if isfield(job.samplesize, 'equal')
        nSubjects = job.samplesize.equal.nsubjects;
    else
        nSubjects = job.samplesize.unequal.nsubjects;
    end

    ibma_mega_ffx(job.dir{1}, job.confiles, job.varconfiles, ...
        equal.samplesize, equal.variances, nSubjects)
end