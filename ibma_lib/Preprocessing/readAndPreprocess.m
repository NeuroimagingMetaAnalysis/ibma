%==========================================================================
%This function reads in data and preprocess it. It takes in the below
%arguments.
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%
%Authors: Thomas Maullin
%==========================================================================
function dataStruct = readAndPreprocess(CElist, CSElist, masktype)
    
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
        if(mean(img(img>0))>1000)
            img = img./100;
            img2 = img2./100;
        end
        
        if strcmp(masktype,'nan')
            toMakeNaN = img2==0;
            img(toMakeNaN) = NaN;
            img2(toMakeNaN) = NaN;
        elseif strcmp(masktype,'zero')
            toMakezero = isnan(img2);
            img(toMakezero) = 0;
            img2(toMakezero) = Inf;
        else
        end
        
        conDataStructure(:,:,:,i) = img;  
        conSEDataStructure(:,:,:,i) = img2;
        
        if strcmp(masktype,'nan')
            usefulEntries(:, :, :, i) = ~isnan(img);
        elseif strcmp(masktype,'zero')
            usefulEntries(:, :, :, i) = img~=0;
        else
        end
    end
    
    usefulEntries = sum(usefulEntries, 4);
    
    dataStruct = {conDataStructure, conSEDataStructure, originalVol};
    
end
    