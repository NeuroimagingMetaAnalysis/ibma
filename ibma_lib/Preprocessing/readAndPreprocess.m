%==========================================================================
%This function reads in data and preprocess it. It takes in the below
%arguments.
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%masking - the masking job structure.
%
%Authors: Thomas Maullin
%==========================================================================
function dataStruct = readAndPreprocess(CElist, CSElist, masking)
    
    if ~isempty(masking.em{1})
        %Ensure all images are the same size.
        mask = strrep(masking.em, ',1', '');
        flags.interp=0;
        spm_reslice({CElist{:}, CSElist{:}, mask{1}}, flags);
    else
        flags.interp=0;
        spm_reslice({CElist{:}, CSElist{:}}, flags);
    end
    
    %We now want to look at the resliced images.
    CElist = cellfun(@(x) prefixAdd(x), CElist, 'UniformOutput', false);
    CSElist = cellfun(@(x) prefixAdd(x), CSElist, 'UniformOutput', false);
    
    %Read in the data.                
    for(i = 1:length(CElist))

        %Read in the volume/s.
        originalVol       = spm_vol(CElist{i});
        originalSEVol       = spm_vol(CSElist{i});
        
        %To check scaling take the mean of the middle slice
        middleSlice = floor(originalVol.dim(3)/2);
        img      = spm_read_vols(originalVol);
        img2     = spm_read_vols(originalSEVol);
        
        %This is to correct for FSL target intensity.
        imgMean = mean(abs(img(img ~= 0 & ~isnan(img))))
        if(imgMean>10)
            img = img./100;
            img2 = img2./100;
        end

        toMakeNaN = img2==0;
        img(toMakeNaN) = NaN;
        img2(toMakeNaN) = NaN;
        
        conDataStructure(:,:,:,i) = img;  
        conSEDataStructure(:,:,:,i) = img2;
        
    end
    
    dataStruct = {conDataStructure, conSEDataStructure, originalVol};
    
end
%--------------------------------------------------------------------------
%This function changes a full path to a file by the filepath and the files
%name with the prefix 'r'.
%--------------------------------------------------------------------------
function path = prefixAdd(fullpath)

    [filepath, filename, ext] = fileparts(fullpath);
    path = [filepath, filesep, 'r', filename, ext];
    
end