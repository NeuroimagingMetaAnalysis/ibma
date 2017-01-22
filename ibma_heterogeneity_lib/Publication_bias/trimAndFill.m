%==========================================================================
%This function performs trim and fill on the study data. It takes the 
%following inputs.
%
%XYZ - the coordinates to perform trim and fill at.
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function estimate = trimAndFill(XYZ, CElist, CSElist)
    
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
    thetahatFFX = dot(weightsFFX, contrast)/(sum(weightsFFX));
    
    %Calculate ranks and T_n.
    differences = abs(contrast-thetahatFFX);
    [~, ranks] = sort(differences, 'ascend');
    ranks = ranks.*sign(contrast-thetahatFFX);
    T_n = sum(ranks(ranks>0));
    
    %Calculate the estimator.
    R_0 = max(length - abs(min(ranks)) - 1,0);
    L_0 = max((4*T_n - length*(length+1))/(2*length-1), 0);
    Q_0 = max(length - 1/2 - sqrt(2*(length^2)-4*T_n+1/4), 0);
    
    estimate = [R_0, L_0, Q_0];
    
end