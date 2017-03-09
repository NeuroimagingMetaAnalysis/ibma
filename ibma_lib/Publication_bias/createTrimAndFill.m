%==========================================================================
%Generate NIFTI files of trim and fill values measuring the presence of 
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
function createTrimAndFill(CElist, CSElist, outdir)
    tic
    
    %Firstly we read in the data.                
    dataStruct = readAndPreprocess(CElist, CSElist, 'nan');
    conDataStructure = dataStruct{1};
    conSEDataStructure = dataStruct{2};
    originalVol = dataStruct{3};
    
    %Reshape the matrices to obtain a list of voxels.
    conDataStructure = reshape(conDataStructure, [91*109*91, length(CElist)]);
    conSEDataStructure = reshape(conSEDataStructure, [91*109*91, length(CElist)]);
    
    %Calculate weights.
    weights = 1./conSEDataStructure.^2;
    
    %Calculate which entries are useful.
    usefulEntries = ~isnan(conDataStructure);
    lengthUseful = sum(usefulEntries,2);
    
    %Apply thresholding.
    threshVec = lengthUseful>min(10,length(CElist)/2);
    conDataStructure = conDataStructure(threshVec==1, :);
    weights = weights(threshVec==1, :);
    lengthUseful = lengthUseful(threshVec==1, :);
    
    %Calculate the overall observed effects mean and the deviations from
    %this mean
    thetahat=nansum(conDataStructure.*weights, 2)./nansum(weights, 2); 
    deviation = conDataStructure-thetahat;
    
    [~,indices]=sort(abs(deviation),2);
    
    %Obtain values in order of magnitude.
    signedValues = deviation(sub2ind(size(deviation),repmat([1:size(deviation,1)]',1,size(deviation,2)),indices));
    rankMatrix = repmat([1:size(deviation,2)], size(deviation,1), 1);
    rankMatrix = rankMatrix.*sign(signedValues);
    
    %Calculate the R estimator.
    estimatorValues = lengthUseful - abs(min(rankMatrix')'.*(min(rankMatrix')'<0));
    finalMap_R = estimatorValues;
    
    %Calculate the sum of the positive ranks.
    rankMatrix(rankMatrix<=0)=0;
    T_n = nansum(rankMatrix,2);
    
    %Calculate the L estimator.
    finalMap_L = (4*T_n - lengthUseful.*(lengthUseful+1))./(2*lengthUseful-1);
    finalMap_L = max(finalMap_L, 0);
    
    %Calculate the Q estimator.
    finalMap_Q = lengthUseful - 1/2 - sqrt(max(0,2*(lengthUseful.^2)-4*T_n+1/4));
    finalMap_Q = max(finalMap_Q, 0);
    
    %Add in the NaN background.
    nanBackground = repmat(nan, 91*109*91, 1);
    nanBackground(threshVec==1) = full(finalMap_R)';
    finalMap_R = nanBackground;
    
    nanBackground = repmat(nan, 91*109*91, 1);
    nanBackground(threshVec==1) = full(finalMap_L)';
    finalMap_L = nanBackground;
    
    nanBackground = repmat(nan, 91*109*91, 1);
    nanBackground(threshVec==1) = full(finalMap_Q)';
    finalMap_Q = nanBackground;
    
    %Reshape into original format.
    finalMap_R = reshape(finalMap_R, [91, 109, 91]);
    finalMap_L = reshape(finalMap_L, [91, 109, 91]);
    finalMap_Q = reshape(finalMap_Q, [91, 109, 91]);
    
    %Create volumes.
    newVol_R       = rmfield(originalVol, {'n', 'descrip', 'private'});
    newVol_L       = rmfield(originalVol, {'n', 'descrip', 'private'});
    newVol_Q       = rmfield(originalVol, {'n', 'descrip', 'private'});
    
    %Create the filename.
    filename_R = 'RTrimAndFillMap.nii';
    filename_L = 'LTrimAndFillMap.nii';
    filename_Q = 'QTrimAndFillMap.nii';
    
    %Output.
    newVol_R.fname = fullfile(outdir, filename_R);
    newVol_R       = spm_create_vol(newVol_R);
    newVol_R       = spm_write_vol(newVol_R,finalMap_R);
    
    newVol_L.fname = fullfile(outdir, filename_L);
    newVol_L       = spm_create_vol(newVol_L);
    newVol_L       = spm_write_vol(newVol_L,finalMap_L);
    
    newVol_Q.fname = fullfile(outdir, filename_Q);
    newVol_Q       = spm_create_vol(newVol_Q);
    newVol_Q       = spm_write_vol(newVol_Q,finalMap_Q);
    
    toc
    
end