%==========================================================================
%Generates a funnel plot of Contrast Estimates against 
%
%CElist - a column cell array of contrast estimate NII filepaths.
%CSElist - a column cell array of contrast standard error NII filepaths in
%          order corresponding to CElist. 
%OOEPath - filepath to an overall obseved effect NII.
%XYZ - the coordinates of the point of interest.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function funnelPlot(XYZ, CElist, CSElist, OOEPath)

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
    
    %Obtain overall observed effect at XYZ.
    
    V=spm_vol(OOEPath);
    ooeVol=spm_read_vols(V,1);
    ooe = ooeVol(XYZ(1), XYZ(2), XYZ(3));
    
    %Obtain coefficient for funnel.
    z = norminv(0.995);
    
    %Plot results.
    figure();
    scatter(contrast, contrastSE, 'x');
    set(gca,'YDir','reverse');
    ylim([-10, max(contrastSE)])
    
    %Plot funnel.
    line([ooe,(ooe-z*max(contrastSE))], [0, max(contrastSE)])
    line([ooe,(ooe+z*max(contrastSE))], [0, max(contrastSE)])
    
    %Add labels.
    title(['Funnel plot for (', num2str(XYZ(1)), ', ', num2str(XYZ(2)), ', ', num2str(XYZ(3)), ')']);
    xlabel('Contrast Estimate');
    ylabel('Standard Error');
    
end 