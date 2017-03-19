%==========================================================================
%Generate NIFTI files of regression values measuring the presence of 
%publication bias in a meta-analysis. This function takes in the following
%inputs:
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%outdir - an output directory for the resultant NIIs.
%type - 'ew' for Egger Weighted, 'eu' for Egger Unweighted or 'm' for
%       Macaskill.
%sampleSizes - an array of each sample size for the relative studies. Only
%              needed for Macaskill regression.
%
%Authors: Thomas Maullin
%==========================================================================

function dataStruct = createRegress(masking, CElist, CSElist, outdir, type, sampleSizes)
    
    warning('off', 'MATLAB:lscov:RankDefDesignMat');
    
    %Firstly we read in the data.                
    dataStruct = readAndPreprocess(CElist, CSElist, masking);
    conDataStructure = dataStruct{1};
    conSEDataStructure = dataStruct{2};
    originalVol = dataStruct{3};
    dim = originalVol.dim;
    
    %Reshape the matrices.
    conDataStructure = reshape(conDataStructure, [dim(1)*dim(2)*dim(3), length(CElist)]);
    conSEDataStructure = reshape(conSEDataStructure, [dim(1)*dim(2)*dim(3), length(CElist)]);
    
    %Calculate the precision values.
    if ~strcmp(type, 'm')
        precisionValues = 1./conSEDataStructure;
    else
        precisionValues = repmat(sampleSizes', dim(1)*dim(2)*dim(3), 1);
    end
    
    %Calculate the effect size.
    weights = 1./(conSEDataStructure.^2);
    if ~strcmp(type, 'm') 
        thetahat=nansum(conDataStructure.*weights, 2)./nansum(weights, 2); 
        effectSize = (conDataStructure-thetahat).*precisionValues;
    else
        effectSize = conDataStructure;
    end
    
    %Apply thresholding.
    [threshVec, lengthUseful] = obtainMaskVoxels(masking, conDataStructure, originalVol, outdir);
    lengthThresh=sum(threshVec);
    
    spm_progress_bar('Init',floor(lengthThresh/200)+3,'Regression Map','Current stage');
    
    %Consider only thresholded voxels.
    effectSize = effectSize(threshVec==1,:);
    precisionValues = precisionValues(threshVec==1,:);
    if strcmp(type, 'm') || strcmp(type, 'ew')
        weights = weights(threshVec==1,:);
        weights=reshape(weights', length(CElist)*size(weights,1),1);
    end
    
    %Create the necessary transformation matrix.
    ident = sparse(eye(200, 200));
    indices = repmat(1:200, length(CElist), 1);
    indices = reshape(indices, 1, length(CElist)*200);
    transform = ident(indices,:);
    
    %We do this in blocks of 200 to avoid exceeding the maximum matlab
    %array sizes.
    for i = 1:floor(lengthThresh/200)
        %Read 200 voxels worth of data.
        oneColumns = ones(200, length(CElist))';
        effectColumns = effectSize((i-1)*200+(1:200), :)';
        precisColumns = precisionValues((i-1)*200+(1:200), :)';
        
        %Set NaN values to zero.
        oneColumns(isnan(effectColumns))=0;
        effectColumns(isnan(effectColumns))=0;
        precisColumns(isnan(precisColumns))=0;
       
        %Create the matrix we regress with.
        datamatrix = [oneColumns,precisColumns];
        
        %Lay out the data so that independent voxels are regressed
        %independently. The contrasts/regressors need intercepts.
        precisTransform =[transform,transform];
        precisTransform(precisTransform==1)=datamatrix;
        
        %The contrast standard error/dependent variable does not need a
        %regressor.
        effectTransform = transform;
        effectTransform(effectTransform==1)=effectColumns;
        
        %Regress.
        if strcmp(type, 'm') || strcmp (type, 'ew')
            weightsColumn = weights((i-1)*200*length(CElist)+(1:(200*length(CElist))));
            weightsColumn(isnan(weightsColumn))=0;
            [coefficients, SEs] = lscov(precisTransform, effectTransform, weightsColumn');
        else
            [coefficients, SEs] = lscov(precisTransform, effectTransform);
        end
        %Record values.
        finalMaps = coefficients([ident; ident] == 1);
        finalMaps = reshape(finalMaps,2,200);
        outputMatrix(:,(i-1)*200+(1:200)) = finalMaps;
        
        %Record Standard error values.
        finalMaps_se = SEs([ident; ident] == 1);
        finalMaps_se = reshape(finalMaps_se,2,200);
        outputMatrix_se(:,(i-1)*200+(1:200)) = finalMaps_se;
        
        spm_progress_bar('Set',i);
    end
    
    %Now we just address the final remaining voxels.
    remainingVoxels = lengthThresh - 200*floor(lengthThresh/200);
    
    %Create the necessary transformation matrix.
    ident = sparse(eye(remainingVoxels, remainingVoxels));
    indices = repmat([1:remainingVoxels], length(CElist), 1);
    indices = reshape(indices, 1, length(CElist)*remainingVoxels);
    transform = ident(indices,:);
    
    %Read remaining data.
    oneColumns = ones(remainingVoxels, length(CElist))';
    effectColumns = effectSize(floor(lengthThresh/200)*200+(1:remainingVoxels), :)';
    precisColumns = precisionValues(floor(lengthThresh/200)*200+(1:remainingVoxels), :)';

    %Set NaN values to zero.
    oneColumns(isnan(effectColumns))=0;
    effectColumns(isnan(effectColumns))=0;
    precisColumns(isnan(precisColumns))=0;

    %Create the matrix we regress with.
    datamatrix = [oneColumns,precisColumns];

    %Lay out the data so that independent voxels are regressed
    %independently. The contrasts/regressors need intercepts.
    precisTransform =[transform,transform];
    precisTransform(precisTransform==1)=datamatrix;

    %The contrast standard error/dependent variable does not need a
    %regressor.
    effectTransform = transform;
    effectTransform(effectTransform==1)=effectColumns;

    %Regress.
    if strcmp(type, 'm') || strcmp (type, 'ew')
        weightsColumn = weights(floor(lengthThresh/200)*200*length(CElist)+(1:(remainingVoxels*length(CElist))));
        weightsColumn(isnan(weightsColumn))=0;
        [coefficients, SEs] = lscov(precisTransform, effectTransform, weightsColumn');
    else
        [coefficients, SEs] = lscov(precisTransform, effectTransform);
    end
    
    spm_progress_bar('Set',floor(lengthThresh/200)+1);
    
    %Record values.
    finalMaps = coefficients([ident; ident] == 1);
    finalMaps = reshape(finalMaps,2,remainingVoxels);
    outputMatrix(:,200*floor(lengthThresh/200)+(1:remainingVoxels)) = finalMaps;
    
    %Record Standard error values.
    finalMaps_se = SEs([ident; ident] == 1);
    finalMaps_se = reshape(finalMaps_se,2,remainingVoxels);
    outputMatrix_se(:,200*floor(lengthThresh/200)+(1:remainingVoxels)) = finalMaps_se;
    
    %Due to the matrix dimensions, outputMatrix_se will be out by a factor
    %of sqrt(4200-400)/sqrt(lengthUseful-2).
    outputMatrix_se=outputMatrix_se.*(sqrt(length(CElist)*200-400))./sqrt(max(lengthUseful'-2,0));
    outputMatrix_p = full(-abs(outputMatrix./outputMatrix_se));
    
    nanBackground = repmat(nan, dim(1)*dim(2)*dim(3), 1);
    nanBackground_p = repmat(nan, dim(1)*dim(2)*dim(3), 1);
    
    spm_progress_bar('Set',floor(lengthThresh/200)+2);
    
    if ~strcmp(type, 'm')
        %Calculate p values.
        outputMatrix_p = outputMatrix_p(1, :);
        outputMatrix_p = -log10(2*tcdf(outputMatrix_p,lengthUseful'-1));
        %Format for output.
        nanBackground(threshVec==1) = full(outputMatrix(1,:))';
        nanBackground_p(threshVec==1) = outputMatrix_p';
    else
        %Calculate p values.
        outputMatrix_p = outputMatrix_p(2, :);
        outputMatrix_p = -log10(2*tcdf(outputMatrix_p,lengthUseful'-1));
        %Format for output.
        nanBackground(threshVec==1) = full(outputMatrix(2,:))';
        nanBackground_p(threshVec==1) = outputMatrix_p';
    end
    
    finalMap = reshape(nanBackground, [dim(1), dim(2), dim(3)]);
    finalMap_p = reshape(nanBackground_p, [dim(1), dim(2), dim(3)]);
    
    newVol       = rmfield(originalVol, {'n', 'descrip', 'private'});
    newVol_p       = rmfield(originalVol, {'n', 'descrip', 'private'});
    
    %Create the filename.
    if strcmp(type, 'm')
        filename = 'msRegressionMap.nii';
        filename_p = 'mpsRegressionMap.nii';
    else
        filename = [type 'iRegressionMap.nii'];
        filename_p = [type 'piRegressionMap.nii'];
    end 
    
    spm_progress_bar('Set',floor(lengthThresh/200)+3);
    
    newVol.fname = fullfile(outdir, filename);
    newVol       = spm_create_vol(newVol);
    newVol       = spm_write_vol(newVol,finalMap);
    
    newVol_p.fname = fullfile(outdir, filename_p);
    newVol_p       = spm_create_vol(newVol_p);
    newVol_p       = spm_write_vol(newVol_p,finalMap_p);
    
    spm_progress_bar('Clear');
    
end