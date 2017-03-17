%==========================================================================
%Generate a NIFTI file of regression values measuring the presence of the
%publication bias in a meta-analysis. This function takes in the following
%inputs:
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%outdir - an output directory for the resultant NIIs.
%
%Authors: Thomas Maullin
%==========================================================================

function dataStruct = createHetMeasure(masking, CElist, CSElist, outdir)
    
    %Firstly we read in the data.                
    dataStruct = readAndPreprocess(CElist, CSElist, masking);
    
    spm_progress_bar('Init',5,'Trim And Fill Map','Current stage');
    
    conDataStructure = dataStruct{1};
    conSEDataStructure = dataStruct{2};
    originalVol = dataStruct{3};
    
    spm_progress_bar('Set',1);
    
    %We reshape it for efficiency reasons.
    conDataStructure = reshape(conDataStructure, [91*109*91, length(CElist)]);
    conSEDataStructure = reshape(conSEDataStructure, [91*109*91, length(CElist)]);
    
    %Apply thresholding.
    [threshVec, lengthUseful] = obtainMaskVoxels(masking, conDataStructure, originalVol, outdir);
    
    spm_progress_bar('Set',2);
    
    %We now only look at the thresholded voxels.
    effectSize = conDataStructure(threshVec==1,:);
    seValues = conSEDataStructure(threshVec==1,:);
    
    spm_progress_bar('Set',3);
    
    %Calculate the weights and overall observed effect under ffx.
    weights = 1./seValues.^2;
    thetahat=nansum(effectSize.*weights, 2)./nansum(weights, 2); 
    
    %Now we work out the values we are interested in.
    voxelValues_Q = nansum(weights.*((thetahat-effectSize).^2),2);
    voxelValues_I2 = max((voxelValues_Q-lengthUseful+1)./voxelValues_Q,0);
    voxelValues_P = -log10(chi2pdf(voxelValues_Q,lengthUseful-1));
    
    spm_progress_bar('Set',4);
    
    %Create the final maps
    finalMap_Q = repmat(nan, 91*109*91, 1);
    finalMap_Q(threshVec==1) = voxelValues_Q; 
    finalMap_Q = reshape(finalMap_Q, [91, 109, 91]);
    
    finalMap_I2 = repmat(nan, 91*109*91, 1);
    finalMap_I2(threshVec==1) = voxelValues_I2; 
    finalMap_I2 = reshape(finalMap_I2, [91, 109, 91]);
    
    finalMap_P = repmat(nan, 91*109*91, 1);
    finalMap_P(threshVec==1) = voxelValues_P; 
    finalMap_P = reshape(finalMap_P, [91, 109, 91]);
    
    %Create the new volumes
    newVol_Q       = rmfield(originalVol, {'n', 'descrip', 'private'});
    newVol_I2       = rmfield(originalVol, {'n', 'descrip', 'private'});
    newVol_P       = rmfield(originalVol, {'n', 'descrip', 'private'});
    
    %Create the filenames.
    filename_Q = 'QHeterogeneityMap.nii';
    filename_I2 = 'I2HeterogeneityMap.nii';
    filename_P = 'PHeterogeneityMap.nii';
    
    spm_progress_bar('Set',5);
    
    %Output the maps of interest.
    newVol_Q.fname = fullfile(outdir, filename_Q);
    newVol_Q       = spm_create_vol(newVol_Q);
    newVol_Q       = spm_write_vol(newVol_Q,finalMap_Q);
    
    newVol_I2.fname = fullfile(outdir, filename_I2);
    newVol_I2       = spm_create_vol(newVol_I2);
    newVol_I2       = spm_write_vol(newVol_I2,finalMap_I2);

    newVol_P.fname = fullfile(outdir, filename_P);
    newVol_P       = spm_create_vol(newVol_P);
    newVol_P       = spm_write_vol(newVol_P,finalMap_P);
    
    spm_progress_bar('Clear');
    
end