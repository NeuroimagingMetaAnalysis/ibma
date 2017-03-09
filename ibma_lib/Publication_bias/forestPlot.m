%==========================================================================
%Generates a forest plot of study data. It takes the following inputs.
%
%src, event - these are needed for callback event handling.
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function forestPlot(src, event, CElist, CSElist)
      
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
    
    %Obtain coefficient for width.
    z = norminv(0.975);
    
    %Plot results.
    figure();
    scatter(contrast, [1:length], 'x');
    ylim([-2, length+1]);
    
    %Add labels.
    title(['Forest plot for MNI(', num2str(XYZ(1)), ', ', num2str(XYZ(2)), ', ', num2str(XYZ(3)), ')']);
    xlabel('Study value');
    ylabel('Study number');
    
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
    
    %Plot lines.
    for(i = 1:length)
        p1 = line([(contrast(i)-z*contrastSE(i)),(contrast(i)+z*contrastSE(i))], [i,i]);
    end
  
    %Add line for FFX.
    hold on;
    p2 = line([(thetahatFFX-z*sqrt(varFFX)),(thetahatFFX+z*sqrt(varFFX))], [0,0], 'color', [1 0 0]);
    scatter(thetahatFFX, 0, 'x')
    
    %Add line for RFX.
    p3 = line([(thetahatRFX-z*sqrt(varRFX)),(thetahatRFX+z*sqrt(varRFX))], [-1,-1], 'color', [1 .5 0]);
    scatter(thetahatRFX, -1, 'x')
     
    %Add key.
    legend([p1, p2, p3], 'Study data','Fixed effects','Random effects');
    
    line([0,0], [-2, length+1], [0,0], 'linestyle', '- -', 'color', [0 0 0])
    
end 