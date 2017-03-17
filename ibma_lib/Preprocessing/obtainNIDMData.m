%==========================================================================
%Obtain the necessary data from NIDM packs. This takes in 2 inputs:
%
%nidmPackList - A cell array of NIDM packs.
%excursionNumbers - A list of excursion set numbers, one for each study.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function [contrastMaps, contrastSEMaps, sampleSizes] = obtainNIDMData(nidmPackList, excursionNumbers)
    
    sampleSizes = [];
    %Look through each nidm pack.
    for i = 1:length(nidmPackList)
        
        %If it is zipped unzip it.
        if contains(nidmPackList{i}, '.zip')
            [path, filename] = fileparts(nidmPackList{i});
            unzip(nidmPackList{i}, fullfile(path, filename));
            nidmPackList{i} = fullfile(path, filename);
        end
        
        %Find out what type of document we are dealing with.
        try
            jsonfilepath = fullfile(nidmPackList{i}, 'nidm.jsonld');
            bugFix(jsonfilepath);
            jsondoc=spm_jsonread(jsonfilepath);
            jsonLD = true;
        catch
            jsonfilepath = fullfile(nidmPackList{i}, 'nidm.json');
            jsondoc=spm_jsonread(jsonfilepath);
            jsonLD = false;
        end

        % Deal with sub-graphs (bundle)
        if ~iscell(jsondoc)
            graph = jsondoc.x_graph;
            if isfield(graph{2}, 'x_graph')
                graph = graph{2}.x_graph;
            end
        else
            graph = jsondoc;
            graph = graph{2}.x_graph;
        end
        
        %Remove derivation objects.
        graphTemp = {};
        for j = 1:length(graph)
            if isfield(graph{j}, 'x_id')
                graphTemp{end+1} = graph{j};
            end
        end
        graph = graphTemp;
        
        if(~jsonLD)
            %Find the excursion set map of interest.
            excursionSetMaps = searchforType('nidm_ExcursionSetMap', graph);
            excursionSetMap = excursionSetMaps{excursionNumbers(i)};

            ids = cellfun(@(x) get_value(x.('x_id')), graph, 'UniformOutput', false);
            
            %Trace the excursionSetMap to a contrastEstimation object.
            inference = searchforID(excursionSetMap.prov_wasGeneratedBy.x_id, graph, ids);
            usedIDs = {inference.prov_used.x_id};
            
            for j = 1:length(usedIDs)
                usedObject=searchforID(usedIDs{j}, graph, ids);
                if any(contains(usedObject.x_type,'nidm_StatisticMap'))
                   statisticMap = usedObject; 
                end
            end
            
            contrastEstimationID = statisticMap.prov_wasGeneratedBy.x_id;
            
            %Now look through the contrast maps for the one that points at
            %contrastEstimation.
            contrastMapObjects = searchforType('nidm_ContrastMap', graph);
            for j = 1:length(contrastMapObjects)
                if isfield(contrastMapObjects{j}, 'prov_wasGeneratedBy')
                    jconEstID = contrastMapObjects{j}.prov_wasGeneratedBy.x_id;
                    if strcmp(jconEstID, contrastEstimationID)
                        contrastMaps{i} = fullfile(nidmPackList{i}, contrastMapObjects{j}.prov_atLocation.x_value);
                    end
                end
            end
            contrastStandardErrorMapObjects = searchforType('nidm_ContrastStandardErrorMap', graph);
            for j = 1:length(contrastStandardErrorMapObjects)
                if isfield(contrastStandardErrorMapObjects{j}, 'prov_wasGeneratedBy')
                    jconSEestID = contrastStandardErrorMapObjects{j}.prov_wasGeneratedBy.x_id;
                    if strcmp(jconSEestID, contrastEstimationID)
                        contrastSEMaps{i} = fullfile(nidmPackList{i}, contrastStandardErrorMapObjects{j}.prov_atLocation.x_value);
                    end
                end
            end
            
        else
            %Currently in jsonLD NIDM packs there is only one excursionSet.
            contrastMapObjects = searchforType('nidm_ContrastMap', graph);
            for j = 1:length(contrastMapObjects)
                if isfield(contrastMapObjects{j}, 'prov_atLocation')
                    contrastMaps{i} = fullfile(nidmPackList{i}, contrastMapObjects{j}.prov_atLocation.x_value);
                end
            end
            contrastStandardErrorMapObjects = searchforType('nidm_ContrastStandardErrorMap', graph);
            for j = 1:length(contrastStandardErrorMapObjects)
                if isfield(contrastStandardErrorMapObjects{j}, 'prov_atLocation')
                    contrastSEMaps{i} = fullfile(nidmPackList{i}, contrastStandardErrorMapObjects{j}.prov_atLocation.x_value);
                end
            end
        end
        
        %Finding sample sizes.
        groupStats = searchforType('obo_studygrouppopulation', graph);
        if isempty(groupStats)
            groupStats = searchforType('obo:STATO_0000193', graph);
        end
        sampleSizes = [sampleSizes str2num(groupStats{1}.nidm_numberOfSubjects.x_value)];
        
    end
    
    for i=1:length(contrastMaps)
        dir = fileparts(contrastMaps{i});
        gunzip(contrastMaps{i}, dir);  
        gunzip(contrastSEMaps{i}, dir);
    end
    
    contrastMaps = strrep(contrastMaps, '.gz', '')';
    contrastSEMaps = strrep(contrastSEMaps, '.gz', '')';
    sampleSizes = sampleSizes';
    
end

%==========================================================================
%This function simply searches for a given type inside an NIDM-Results
%pack.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function [result, index] = searchforType(type, graph) 
    
    index = [];
    result = [];
    n = 1;
    
    %Look through the graph for objects of a type 'type'.
    for k = 1:length(graph)
        %If an object has one of its types listed as 'type' recorded it.
        if any(ismember(graph{k}.('x_type'), type)) && isa(graph{k}.('x_type'), 'cell')
            result{n} = graph{k};
            index{n} = k;
            n = n+1;
        end
        %If an object has it's only type listed as 'type' recorded it.
        if isa(graph{k}.('x_type'), 'char')
            if strcmp(graph{k}.('x_type'), type)
                result{n} = graph{k};
                index{n} = k;
                n = n+1;
            end
        end
    end
end

%==========================================================================
%This function simply searches for a given ID inside an NIDM-Results
%pack.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function result = searchforID(ID, graph, ids) 
    
    try
        result = graph{find(strcmp(ids, ID))};
    catch
        result = '';
    end
    
end

%--------------------------------------------------------------------------
%This function is temporary and only here due to a bug in the current SPM
%export leading to additional ':' characters appearing in the jsonld. The
%function and all references to it should be removed during the next spm
%update.
%--------------------------------------------------------------------------
function bugFix(jsonPath)
    %Open the file and read in the text.
    fileID = fopen(jsonPath, 'r+');
    text = fscanf(fileID, '%c', inf);
    
    %Remove the colons.
    text = strrep(text, ':"', '"');
    text = strrep(text, '\n', '\\n');
    text = strrep(text, '\"', '\\"');
    fclose(fileID);
    
    %Print out.
    fileID = fopen(jsonPath, 'wt');
    fprintf(fileID, text);
    fclose(fileID);
end