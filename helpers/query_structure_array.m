%% query_structure_array
% query structure array as though it were a database
% Inputs: structureArray: An 1xn array of structures
%         varargin		: query of the form
%							'structurefield >= searchvalue'
% Outputs:
%		  queryResults	: array of structures matching queries


function [queryResults] = query_structure_array(structureArray,conditionals)
	% loop through varargin and parse equality
    queryResults = structureArray;
	
	limit = 0;
    
	for i = 1:length(conditionals)
		% parse the equality
		contents = textscan(conditionals{i}, '%s', 'delimiter', ' ');
		contents = contents{1};
		
		if length(contents) ~= 3
			error('query_structure_array:badQuery','Misformed query');
		end
		
		key = contents{1};
		equality = contents{2};
		value = contents{3};
		
		if ~strcmp(equality, {'==','>=','<=','<','>'})
			error('query_structure_array:badEquality','Misformed equality statement');
		end
		
		if strcmp(key, 'limit')
			limit = str2double(value);
		elseif ~isfield(structureArray,key)
			error('query_structure_array:badKey',...
				['Bad Key: ' key ' is not a key of the structures in structureArray.\n' ...
				' keys are: ' implode(fieldnames(structureArray), ', ')]);
		elseif ~isnan(str2double(value))
			value = str2double(value);
			switch equality
				case '>'
					queryResults = queryResults([queryResults.(key)] > value);
				case '<'
					queryResults = queryResults([queryResults.(key)] < value);
				case '<='
					queryResults = queryResults([queryResults.(key)] <= value);
				case '>='
					queryResults = queryResults([queryResults.(key)] >= value);
				otherwise
					%assume equality
					queryResults = queryResults([queryResults.(key)] == value);
			end
		else
			%doesn't matter what the equality statement is if the value is
			%a string
        	queryResults = queryResults(strcmp(value,{queryResults.(key)}));
		end
        
        if isempty(queryResults)
			break; %no need to keep searching 
        end
	end
	
	if limit && limit < length(queryResults)
		queryResults = queryResults(1:limit);
	end
end