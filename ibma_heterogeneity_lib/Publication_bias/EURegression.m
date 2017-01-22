%==========================================================================
%This function performs Egger Unweighted regression on the study data. It 
%takes the following inputs.
%
%XYZ - the coordinates to perform trim and fill at.
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function data = EURegression(XYZ, CElist, CSElist)

    %Create data structure.
    data = struct;
    
    %Calculate number of studies.
    length = max(size(CElist));
    
    for(i = 1:length)
        
        %Obtain the contrast estimate at XYZ for each study.
        V=spm_vol(CElist{i});
        CEVol=spm_read_vols(V,1);
        contrast(i) = CEVol(XYZ(1), XYZ(2), XYZ(3));
        
        %Obtain the contrast standard error at XYZ for each study.
        V=spm_vol(CSElist{i});
        CSEVol=spm_read_vols(V,1);
        contrastSE(i) = CSEVol(XYZ(1), XYZ(2), XYZ(3));
        
    end 
      
    %Calculate FFX observed effect.
    weightsFFX = 1./(contrastSE.^2);
    
    %Calculate effectSize and precision values.
    effectSize = contrast./contrastSE;
    precisionValues = 1./contrastSE;
    
    %Perform the regression.
    [estimates, SE] = lscov([ones(1, length); precisionValues]', effectSize');
    
    df = length-max(size(estimates));
    pValues = 2*tcdf(estimates./SE,df);
    
    %Record data.
    data.estimates = estimates;
    data.pValues = pValues;
    
end