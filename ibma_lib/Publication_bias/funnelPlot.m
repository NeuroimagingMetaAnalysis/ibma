%==========================================================================
%Generates a funnel plot of Contrast Estimates against standard error. It
%takes the following inputs.
%
%src, event - these are needed for callback event handling.
%dataStruct - the datastructure returned by preprocessing.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function funnelPlot(src, event, dataStruct)
    
    XYZ = spm_orthviews('Pos',1);
    XYZ = round(XYZ);
    
    conDataStructure = dataStruct{1};
    conSEDataStructure = dataStruct{2};
    
    %Read the data in.
    contrast = squeeze(conDataStructure(XYZ(1), XYZ(2), XYZ(3), :));
    contrastSE = squeeze(conSEDataStructure(XYZ(1), XYZ(2), XYZ(3), :));
    
    %Removed NaN values.
    contrast = contrast(~isnan(contrast));
    contrastSE = contrastSE(~isnan(contrastSE));
    
    %Calculate number of studies.
    length = size(contrast, 1);
    
    if(length == 0)
        disp('Not enough studies are present at this voxel for plot display.')
    else
        %Obtain coefficient for funnel.
        z = norminv(0.95);

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

end 