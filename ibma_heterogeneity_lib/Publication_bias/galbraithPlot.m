%==========================================================================
%Generates a Galbraith plot of standardized effect against inverse 
%Contrast Estimate. It takes the following inputs.
%
%src, event - these are needed for callback event handling.
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function galbraithPlot(src, event, CElist, CSElist)
    
    XYZ = spm_orthviews('Pos',1);
    XYZ = round(XYZ);

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
    
    %Obtain coefficient for galbraith.
    z = norminv(0.995);
    
    %Plot results.
    figure();
    scatter(1./contrastSE, contrast./contrastSE, 'x');
    
    %Add labels.
    title(['Galbraith plot for MNI(', num2str(XYZ(1)), ', ', num2str(XYZ(2)), ', ', num2str(XYZ(3)), ')']);
    xlabel('Inverse Standard Error');
    ylabel('Standardized Contrast Estimate');
    
    %Calculate FFX statistic values.
    weightsFFX = 1./(contrastSE.^2);
    thetahatFFX = dot(weightsFFX, contrast)/(sum(weightsFFX));
    varFFX = 1/sum(weightsFFX);
    
    %Calculate RFX Statistic values.
    Q = dot(weightsFFX, ((contrast-thetahatFFX).^2));
    bsVar = max((Q-(length-1))/(sum(weightsFFX) - (sum(weightsFFX.^2)/sum(weightsFFX))),0);
    weightsRFX = 1./(contrastSE.^2+bsVar);
    thetahatRFX = dot(weightsRFX, contrast)/(sum(weightsRFX));
    varRFX = 1/sum(weightsRFX);
    
    %Add these values to scatter plot.
    hold on;
    scatter(1/sqrt(varFFX),thetahatFFX/sqrt(varFFX), 'o');
    scatter(1/sqrt(varRFX),thetahatRFX/sqrt(varRFX), 'd');
    hold off;
    
    %Add key.
    legend('Study data','Fixed effects','Random effects');
    
    %Plot interval.
    refline(thetahatFFX, -1.96);
    refline(thetahatFFX, 0);
    refline(thetahatFFX, 1.96);
    
end 