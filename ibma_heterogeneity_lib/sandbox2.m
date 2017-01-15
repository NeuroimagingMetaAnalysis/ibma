%Sandbox2

%MIPS
json = spm_jsonread(jsonFileList{1});
graph = json.x_graph;
[excursionSetMaps, excurIndices] = searchforType('nidm_ExcursionSetMap', graph);
coordSpaceId = excursionSetMaps{1}.('nidm_inCoordinateSpace').('x_id');
coordSpace = searchforID(coordSpaceId, graph);
dim = str2num(coordSpace.('nidm_dimensionsInVoxels'))';

 %Create the excursionSet accounting for NaNs.
    V=spm_vol('QMap.nii');
    M=V.mat;
    [T,XYZ]=spm_read_vols(V,1);
    I = ~isnan(T);
    Tth=T(I);
    XYZth=XYZ(:,I);
    
    %Convert the units to the required format.
    units = {'mm' 'mm' 'mm'}
    
    %Get Ms and Md.
    [Ms, Md] = getMsMd(units, M, dim);
    
    %Account for the units.
    pXYZ = Ms*Md*[XYZth;ones(1,size(XYZth,2))];
    mip = spm_mip(Tth,pXYZ(1:3,:),Ms*Md*M,units);
    
    %Write the image:
    mipPath = spm_file(fullfile(pwd, 'QMIP.png'));
    imwrite(mip,gray(64),mipPath,'png');

%Obtain coords

spm_image('Display', 'QMap.nii')
XYZ = spm_orthviews('Pos',1)
XYZ = round(XYZ);

%Creating funnel plots:
V=spm_vol('I2Map.nii');
M=V.mat;
[T,XYZ]=spm_read_vols(V,1);
I = ~isnan(T);
Tth=T(I);
XYZth=XYZ(:,I);


