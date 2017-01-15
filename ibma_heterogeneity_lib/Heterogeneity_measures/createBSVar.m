%==========================================================================
%Generate a NIFTI file for between study variance from a set of studies. 
%This function takes in an input of:
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%outdir - an output directory for the resultant NIIs.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function createBSVar(CElist, CSElist, outdir)

    %Create a Q NIFTI file.
    path = fullfile(outdir, 'QMap.nii');
    createQ(CElist, CSElist, outdir);
    
    %Calculate number of studies
    length = max(size(CElist));
    
    %Create strings for the sums involving the inverse of standard errors.
    sum = '(';
    sumSquare = '(';
    for(i = 1:(length-1))
        sum = [sum, '(1./(i', num2str(i), '))+'];
        sumSquare = [sumSquare, '(1./(i', num2str(i), '.^2))+'];
    end 
    sum = [sum, '(1./(i', num2str(length), ')))'];
    sumSquare = [sumSquare, '(1./(i', num2str(length), '.^2)))'];
    
    %Write string for the overall expression.
    numerator = ['((i', num2str(length+1), ')-', num2str(length-1), ')'];
    denominator = ['(', sum, '-(', sumSquare, './', sum, '))']; 
    expression = [numerator, './', denominator];
    
    %Make the batch.
    matlabbatch{1}.spm.util.imcalc.input = [CSElist, path]';
    matlabbatch{1}.spm.util.imcalc.output = 'BSVarMap';
    matlabbatch{1}.spm.util.imcalc.outdir = {outdir};
    matlabbatch{1}.spm.util.imcalc.expression = expression;
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    
    %Run the batch.
    spm_jobman('run', matlabbatch)

end