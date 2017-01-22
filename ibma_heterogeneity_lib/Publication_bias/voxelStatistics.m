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

function voxelStatistics(src, event, CElist, CSElist)

    %Obtain the voxel coordinates.
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
    
    %Create the title for display.
    title = ['Statistical data for MNI(', num2str(XYZ(1)), ', ', num2str(XYZ(2)), ', ', num2str(XYZ(3)), ')'];

    %Create the figure.
    display = figure('menu','none','toolbar','none', 'resize', 'off');
    panel = uipanel(display,'Units','normalized','position',[0.025 0.025 0.95 0.95],'title',...
    title);
    textbox = uicontrol(panel,'style','listbox','Units','normalized','position',...
    [0.01 0.01 0.98 0.98],'FontSize', 9, 'FontName', 'FixedWidth');
      
    %Calculate FFX statistic values.
    weightsFFX = 1./(contrastSE.^2);
    thetahatFFX = dot(weightsFFX, contrast)/(sum(weightsFFX));
    varFFX = 1/sum(weightsFFX);
    
    %Calculate RFX Statistic values.
    Q = dot(weightsFFX, ((contrast-thetahatFFX).^2));
    bsVar = max((Q-(length-1))/(sum(weightsFFX) - (sum(weightsFFX.^2)/sum(weightsFFX))),0);
    weightsRFX = 1./(contrastSE.^2+bsVar);
    thetahatRFX = dot(weightsRFX, contrast)/(sum(weightsRFX));
    
    %Retrieve data.
    TAFData = trimAndFill(XYZ, CElist, CSElist);
    EUData = EURegression(XYZ, CElist, CSElist);
    EWData = EWRegression(XYZ, CElist, CSElist);

    %Add the text.
    set(textbox,'string', {'The following statistics are Overall Observed effect under:';...
                           '';...
                           ['   Fixed effects:                     ' num2str(thetahatFFX)];...
                           ['   Random effects:                    ' num2str(thetahatRFX)];...
                           '';...
                           'The between study variance is given as:';...
                           '';...
                           ['   BS Variance:                       ' num2str(bsVar)];...
%                            '';...
%                            'Egger''s Regression (EU):                         Egger''s Regression (EW):';...
%                            'Macaskill''s Regression (FIV):                   Macaskill''s Regression (FPV):';...
%                            'Begg''s correlation:';...
                           '';...
                           'The Trim and Fill Estimates are given by:';...
                           '';...
                           ['   R_0:                               ' num2str(TAFData(1))];...
                           ['   L_0:                               ' num2str(TAFData(2))];...
                           ['   Q_0:                               ' num2str(TAFData(3))];...
                           '';...
                           'The Unweighted Egger''s (EU) Regression results are:';...
                           '';...
                           ['   Intercept Estimate:                ' num2str(EUData.estimates(1)) '    (P Value:' num2str(EUData.pValues(1)) ')'];...
                           ['   Slope Estimate:                    ' num2str(EUData.estimates(2)) '    (P Value:' num2str(EUData.pValues(2)) ')'];...
                           '';...
                           'The Weighted Egger''s (EW) Regression results are:';...
                           '';...
                           ['   Intercept Estimate:                ' num2str(EWData.estimates(1)) '    (P Value:' num2str(EWData.pValues(1)) ')'];...
                           ['   Slope Estimate:                    ' num2str(EWData.estimates(2)) '    (P Value:' num2str(EWData.pValues(2)) ')']});
    
end