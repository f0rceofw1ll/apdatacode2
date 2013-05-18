function [queryResults] = queryCellArray(db,varargin)
    keys = varargin(1:2:end);
    values = varargin(2:2:end);
    
    queryResults = db;
    
    for i = 1:length(keys)
        if isnumeric(values{i})
           %assume single numeric, not array
           queryResults = queryResults([queryResults.(keys{i})] == values{i});
        else
           %assume string
           queryResults = queryResults(strcmp(values(i),{queryResults.(keys{i})}));
        end
        
        if isempty(queryResults)
           break; %no need to keep searching 
        end
    end

end