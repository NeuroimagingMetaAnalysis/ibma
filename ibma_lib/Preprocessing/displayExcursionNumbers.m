%==========================================================================
%Return the integers corresponding to each NIDM pack.
%
%nidmPackList - A cell array of NIDM packs.
%excursionNumbers - A list of excursion set numbers, one for each study.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function displayExcursionNumbers(nidmPack)

    %If it is zipped unzip it.
    if contains(nidmPack, '.zip')
        [path, filename] = fileparts(nidmPack);
        %unzip(nidmPack, fullfile(path, filename));
        nidmPack = fullfile(path, filename);
    end

    %Find out what type of document we are dealing with.
    try
        jsonfilepath = fullfile(nidmPack, 'nidm.jsonld');
        jsondoc=spm_jsonread(jsonfilepath);
        jsonLD = true;
    catch
        jsonfilepath = fullfile(nidmPack, 'nidm.json');
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
    ids = cellfun(@(x) get_value(x.('x_id')), graph, 'UniformOutput', false);
    
    if(~jsonLD)
        
        %Find the excursion set maps.
        excursionSetMaps = searchforType('nidm_ExcursionSetMap', graph);
        
        for i = 1:length(excursionSetMaps)
            inference = searchforID(excursionSetMaps{i}.prov_wasGeneratedBy.x_id, graph, ids);
            disp([num2str(i), ': ', inference.xsd_label]); 
        end
    else
        %Find the inference object.
        contrastWeightMatrix = searchforType('obo_contrastweightmatrix', graph);
        disp(['1: ', contrastWeightMatrix{1}.rdfs_label]); 
    end
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