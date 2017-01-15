files = dir('*.json')
jsonFileList={files.name}
% Find contrast
for(i = 1:length(jsonFileList))
    json = spm_jsonread(jsonFileList{i});
    graph = json.x_graph;
    contrasts = searchforType('nidm_ContrastMap', graph);
    contrastsSE = searchforType('nidm_ContrastStandardErrorMap', graph);
    for(j = 1:length(contrasts))
        if(contains(contrasts{j}.nfo_fileName, '.gz'))
            conName{i} = contrasts{j}.nfo_fileName;%something weird here - ask Camille
        end%should ask ask user which contrasts here
    end
    for(j = 1:length(contrastsSE))
        if(contains(contrastsSE{j}.nfo_fileName, '.gz'))
            conSEName{i} = contrastsSE{j}.nfo_fileName;%something weird here - ask Camille
        end%should ask ask user which contrasts here
    end 
end
% Unzip
jsonFileNameList = strrep(jsonFileList, '.json', '');
for(i = 1:length(jsonFileList))
    gunzip(fullfile(jsonFileNameList{i}, conName{i}));
    gunzip(fullfile(jsonFileNameList{i}, conSEName{i}));
end

% Make batch for overall observed effect

contrastPaths = fullfile(pwd, jsonFileNameList, conName);
contrastSEPaths = fullfile(pwd, jsonFileNameList, conSEName);
matlabbatch{1}.spm.util.imcalc.input = strrep([contrastPaths, contrastSEPaths],'.gz', '')';
matlabbatch{1}.spm.util.imcalc.output = 'Overall observed effect';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
stringNum = '(';
stringDen = '(';
length = max(size(contrastPaths));
for(k = 1:(length-1))
    stringNum = [stringNum, 'i', num2str(k), './(i' num2str(length+k), '.^2) + '];
    stringDen = [stringDen, '1./(i', num2str(length+k), '.^2) + '];
end
stringNum = [stringNum, 'i', num2str(length), './(i' num2str(2*length), '.^2))'];
stringDen = [stringDen, '1./(i', num2str(2*length), '.^2))'];
string = [stringNum './' stringDen];

matlabbatch{1}.spm.util.imcalc.expression = string;
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run', matlabbatch)

% Make batch for Q
string = '(';
length = max(size(contrastPaths));
for(k = 1:(length-1))
    string = [string, '(1./(i', num2str(length+k), '.^2)).*((i', num2str(k), '-i', num2str(2*length+1), ').^2) +'];
end
string = [string, '(1./(i', num2str(2*length), '.^2)).*((i', num2str(length), '-i', num2str(2*length+1), ').^2))'];
matlabbatch{1}.spm.util.imcalc.input = [matlabbatch{1}.spm.util.imcalc.input' fullfile(pwd, 'Overall observed effect.nii')]';
matlabbatch{1}.spm.util.imcalc.output = 'Q-Map';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = string;
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

% Make batch for I^2
matlabbatch{1}.spm.util.imcalc.input = {fullfile(pwd, 'Q-Map.nii')};
matlabbatch{1}.spm.util.imcalc.output = 'I^2-Map';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = ['((i1-', num2str(length-1), ')./i1).*100'];
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

% Make batch for -log10(P) for Q
matlabbatch{1}.spm.util.imcalc.input = {fullfile(pwd, 'test_float.nii')};
matlabbatch{1}.spm.util.imcalc.output = '-logQ-Map';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = ['-log10(chi2pdf(i1,' num2str(length-1) '))'];
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 64;