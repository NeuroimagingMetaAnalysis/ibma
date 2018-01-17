%==========================================================================
%Generates a Galbraith plot of standardized effect against inverse 
%Contrast Estimate. It takes the following inputs.
%
%src, event - these are needed for callback event handling.
%dataStruct - the datastructure returned by preprocessing. 
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function galbraithPlot(src, event, dataStruct)
    
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
    
end 