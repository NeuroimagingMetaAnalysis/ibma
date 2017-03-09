%==========================================================================
%Generate a NIFTI file of regression values measuring the presence of the
%publication bias in a meta-analysis. This function takes in the following
%inputs:
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%outdir - an output directory for the resultant NIIs.
%type - either 'ew' for weighted Egger regression, 'eu' for unweighted 
%               Egger regression or 'm' for Macaskill regression.
%result - either 'i' for intercept values, 's' for slope values, 'pi' for 
%         intercept p values or 'ps' for slope p values.
%sampleSizes - this is only needed if we are doing Macaskill regression - 
%              it is a vector of study sample sizes.
%
%Authors: Thomas Maullin
%==========================================================================

function createRegress(CElist, CSElist, outdir, type, result, sampleSizes)
                    
    tic
    %Firstly we read in the data.                
    dataStruct = readAndPreprocess(CElist, CSElist, 'nan');
    conDataStructure = dataStruct{1};
    conSEDataStructure = dataStruct{2};
    originalVol = dataStruct{3};
    
    %We then calculate the effectSize and precisionValue vectors at each
    %voxel, performing regression if we are able to.
    for i=1:originalVol.dim(1)
        for j=1:originalVol.dim(2)
            for k=1:originalVol.dim(3)
                
                %Read in the effect size and if necessary standard error 
                %values.
                effectSize = squeeze(conDataStructure(i,j,k,:));
                seValues = squeeze(conSEDataStructure(i,j,k,:));
                usefulEntries = (effectSize~=0)&(seValues~=0)&...
                                    (~isnan(effectSize))&(~isnan(seValues));
               
                effectSize = effectSize(usefulEntries);
                
                %If we have enough information perform regression, else
                %enter NaN.
                if(length(effectSize) > min(10, length(CElist)/2))
                    %In Macaskills regression we look at sample size
                    %against observed effect.
                    weights = 1./(seValues(usefulEntries).^2);
                    if strcmp(type, 'm')
                        precisionValues = sampleSizes(usefulEntries)';
                    %In Egger regression we look at inverse standard error
                    %against standardized observed effect.
                    else
                        precisionValues = 1./seValues(usefulEntries);
                        thetahat = dot(weights, effectSize)/(sum(weights));
                        effectSize = (effectSize-thetahat).*precisionValues;
                    end
                    
                    %If we are doing Egger unweighted we do not use
                    %weights, otherwise we do.
                    if strcmp(type, 'eu')
                        [estimates, SE] = lscov([ones(1, length(effectSize))', precisionValues], effectSize);
                    else
                        [estimates, SE] = lscov([ones(1, length(effectSize))', precisionValues], effectSize, weights);
                    end
                    
                    %Store results.
                    if strcmp(result, 'i')                    
                        finalMap(i, j, k) = estimates(1);
                    elseif strcmp(result, 's')
                        finalMap(i, j, k) = estimates(2);
                    elseif strcmp(result, 'pi')
                        pValue = -log10(2*tcdf(-abs(estimates(1)/SE(1)),length(effectSize)-1));
                        finalMap(i, j, k) = pValue;
                    else 
                        pValue = -log10(2*tcdf(-abs(estimates(2)/SE(2)),length(effectSize)-1));
                        finalMap(i, j, k) = pValue;
                    end
                else
                    finalMap(i, j, k) = NaN;
                end
            end
        end
    end

    newVol       = originalVol;
    
    %Create the filename.
    filename = [type, result, 'RegressionMap.nii'];
    
    newVol.fname = fullfile(outdir, filename);
    newVol       = spm_create_vol(newVol);

    for i=1:originalVol.dim(3)
        img = squeeze(finalMap(:, :, i));
        newVol       = spm_write_plane(newVol,img,i);
    end
    
    toc
    
end