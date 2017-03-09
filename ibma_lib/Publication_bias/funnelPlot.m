%==========================================================================
%Generates a funnel plot of Contrast Estimates against standard error. It
%takes the following inputs.
%
%src, event - these are needed for callback event handling.
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function funnelPlot(src, event, CElist, CSElist, XYZ)
    
    %XYZ = spm_orthviews('Pos',1);
    XYZ = round(XYZ);
    
    %Calculate number of studies.
    length = max(size(CElist));
    
    for(i = 1:length)
        
        %Read in the volume/s.
        originalVol       = spm_vol(CElist{i});
        
        %To check scaling take the mean of the middle slice
        middleSlice = floor(originalVol.dim(3)/2);
        img      = spm_slice_vol(originalVol,spm_matrix([0 0 middleSlice]),...
                                                    originalVol.dim(1:2),0);
        largeScale = false;
        if(mean(img(img>0))>150)
            largeScale = true;
        end
        
        %Obtain the contrast estimate at XYZ for each study.
        V=spm_vol(CElist{i});
        CEVol=spm_read_vols(V,1);
        contrast(i) = CEVol(XYZ(1), XYZ(2), XYZ(3));
        
        %Obtain the contrast standard error at XYZ for each study.
        V=spm_vol(CSElist{i});
        CSEVol=spm_read_vols(V,1);
        contrastSE(i) = CSEVol(XYZ(1), XYZ(2), XYZ(3));
        
        if largeScale
            contrastSE(i)=contrastSE(i)/100; 
            contrast(i)=contrast(i)/100;
        end
    end 
    
    %Obtain coefficient for funnel.
    z = norminv(0.9999);
    
    %Plot results.
    figure();
    scatter(contrast, contrastSE, 'x');
    set(gca,'YDir','reverse');
    ylim([-max(contrastSE)/10, max(contrastSE)]);
    
    %Add labels.
    title(['Funnel plot for MNI(', num2str(XYZ(1)), ', ', num2str(XYZ(2)), ', ', num2str(XYZ(3)), ')']);
    xlabel('Contrast Estimate');
    ylabel('Standard Error');
    
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
    scatter(thetahatFFX, sqrt(varFFX), 'o');
    scatter(thetahatRFX, sqrt(varRFX), 'd');
    hold off;
    
    %Add key.
    legend('Study data','Fixed effects','Random effects');
    
    %Plot funnel.
    line([thetahatFFX,(thetahatFFX-z*max(contrastSE))], [0, max(contrastSE)])
    line([thetahatFFX,(thetahatFFX+z*max(contrastSE))], [0, max(contrastSE)])
    
end 