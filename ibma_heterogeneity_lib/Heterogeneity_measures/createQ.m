%==========================================================================
%Generate a NIFTI file for cochrans Q from a set of studies. This function 
%takes in an input of:
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%outdir - an output directory for the resultant NIIs.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function createQ(CElist, CSElist, outdir)
    
    %Create an overall observed effect NIFTI file.
    path = fullfile(outdir, 'OOE_FFXMap.nii');
    createOOE_FFX(CElist, CSElist, outdir);
    
    %Calculate number of studies
    length = max(size(CElist));
    
    %Create expression for matlab batch to calculate Q.
    string = '(';
    for(k = 1:(length-1))
        string = [string, '(1./(i', num2str(length+k), '.^2)).*((i', num2str(k), '-i', num2str(2*length+1), ').^2) +'];
    end
    string = [string, '(1./(i', num2str(2*length), '.^2)).*((i', num2str(length), '-i', num2str(2*length+1), ').^2))'];
    
    %Create the batch.
    matlabbatch{1}.spm.util.imcalc.input = [CElist, CSElist, path]';
    matlabbatch{1}.spm.util.imcalc.output = 'QMap';
    matlabbatch{1}.spm.util.imcalc.outdir = {outdir};
    matlabbatch{1}.spm.util.imcalc.expression = string;
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 64;
    
    %Run the batch.
    spm_jobman('run', matlabbatch)

end