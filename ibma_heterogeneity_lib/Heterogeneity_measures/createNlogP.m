%==========================================================================
%Generate a NIFTI file of negative log10 P values for Cochran's Q from a 
%set of studies. This function takes in an input of:
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%outdir - an output directory for the resultant NIIs.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function createNlogP(CElist, CSElist, outdir)
    
    %Create a Q NIFTI file.
    path = fullfile(outdir, 'QMap.nii');
    createQ(CElist, CSElist, outdir);
    
    %Calculate number of studies
    length = max(size(CElist));
    
    %Make the batch
    matlabbatch{1}.spm.util.imcalc.input = {path};
    matlabbatch{1}.spm.util.imcalc.output = 'NlogPMap';
    matlabbatch{1}.spm.util.imcalc.outdir = {outdir};
    matlabbatch{1}.spm.util.imcalc.expression = ['-log10(chi2pdf(i1,' num2str(length-1) '))'];
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;
    
    %Run the batch.
    spm_jobman('run', matlabbatch)
   
end