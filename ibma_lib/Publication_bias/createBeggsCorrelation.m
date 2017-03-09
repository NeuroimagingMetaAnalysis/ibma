%==========================================================================
%Generate a NIFTI file of Begg's correlation measuring the presence of the
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

function createBeggsCorrelation(CElist, CSElist, outdir)
    tic
    
    %Firstly we read in the data.                
    dataStruct = readAndPreprocess(CElist, CSElist, 'nan');
    conDataStructure = dataStruct{1};
    conSEDataStructure = dataStruct{2};
    originalVol = dataStruct{3};
    
    %We reshape it for efficiency reasons.
    conDataStructure = reshape(conDataStructure, [91*109*91, length(CElist)]);
    conSEDataStructure = reshape(conSEDataStructure, [91*109*91, length(CElist)]);
    
    %We work out which entries are useful to us.
    usefulEntries = ~isnan(conDataStructure);
    lengthUseful = sum(usefulEntries,2);
    
    %Threshold them.
    threshVec = lengthUseful>min(10,length(CElist)/2);
    
    %We now only look at the thresholded voxels.
    effectSize = conDataStructure(threshVec==1,:);
    seValues = conSEDataStructure(threshVec==1,:);
    
    %Calculate the weights and overall observed effect under ffx.
    weights = 1./seValues.^2;
    thetahat=nansum(effectSize.*weights, 2)./nansum(weights, 2); 
    
    %Standardize the effect size and calculate modified variances.
    effectSize = (effectSize-thetahat)./seValues;
    mVar = seValues.^2 - 1./nansum(weights,2);
    
    %We rank the mVar values and sort them by order of corresponding effect
    %size.
    [~,indices]=sort(effectSize,2);
    [~, ~, ranks] = arrayfun(@(i) unique(mVar(i,:)), 1:size(mVar, 1), 'UniformOutput',false);
    ranks = horzcat(ranks{:})';
    columnVals = mVar(sub2ind(size(indices),repmat([1:size(indices,1)]',1,size(indices,2)),indices));
    columnRanks = ranks(sub2ind(size(indices),repmat([1:size(indices,1)]',1,size(indices,2)),indices));
    columnRanks(isnan(columnVals)) = NaN;
    
    for(i = 1:length(CElist))
        tempRank = columnRanks(:, i:length(CElist));
        sumCon(:,i) = nansum(tempRank>tempRank(:,1),2);
        sumDis(:,i) = nansum(tempRank<tempRank(:,1),2);
    end
    
    sumCon = sum(sumCon, 2);
    sumDis = sum(sumDis, 2);
    
    %Create the t final map with a background of NaN values.
    voxelValues_t = (sumCon - sumDis)./(sumCon + sumDis);
    finalMap_t = repmat(nan, 91*109*91, 1);
    finalMap_t(threshVec==1) = voxelValues_t; 
    finalMap_t = reshape(finalMap_t, [91, 109, 91]);
    
    %Create the z final map with a background of NaN values.
    lengthUseful = lengthUseful(threshVec==1);
    voxelValues_z  = (sumCon - sumDis)./sqrt(lengthUseful.*...
                   (lengthUseful-1).*(2*lengthUseful+5).*...
                   (1/18));
    finalMap_z = repmat(nan, 91*109*91, 1);
    finalMap_z(threshVec==1) = voxelValues_z; 
    finalMap_z = reshape(finalMap_z, [91, 109, 91]);
    
    %Create the p final map with a background of NaN values.
    voxelValues_p = -log10(2*(1-normcdf(abs(voxelValues_z))));
    finalMap_p = repmat(nan, 91*109*91, 1);
    finalMap_p(threshVec==1) = voxelValues_p; 
    finalMap_p = reshape(finalMap_p, [91, 109, 91]);
    
    %Create the new volumes
    newVol_t       = rmfield(originalVol, {'n', 'descrip', 'private'});
    newVol_z       = rmfield(originalVol, {'n', 'descrip', 'private'});
    newVol_p       = rmfield(originalVol, {'n', 'descrip', 'private'});
    
    %Create the filenames.
    filename_t = 'tBeggsCorrelationMap.nii';
    filename_z = 'zBeggsCorrelationMap.nii';
    filename_p = 'pBeggsCorrelationMap.nii';
    
    %Output the maps of interest.
    newVol_t.fname = fullfile(outdir, filename_t);
    newVol_t       = spm_create_vol(newVol_t);
    newVol_t       = spm_write_vol(newVol_t,finalMap_t);
    
    newVol_z.fname = fullfile(outdir, filename_z);
    newVol_z       = spm_create_vol(newVol_z);
    newVol_z       = spm_write_vol(newVol_z,finalMap_z);

    newVol_p.fname = fullfile(outdir, filename_p);
    newVol_p       = spm_create_vol(newVol_p);
    newVol_p       = spm_write_vol(newVol_p,finalMap_p);
    
    toc
    
end