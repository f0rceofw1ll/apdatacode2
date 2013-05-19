%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean_response: Average response for a set of 
% INPUTS
% expDirectory		: (e.g. '\2013-3-6 in vivo')
% db                : structure of stimulus (array of structures)
% OUTPUTS
% avgRec			: structure of average recording
	% .v			: average voltage recording
	% stimOnsetIndex: stimulus onset index of average recording

function [avgV] = mean_response(expDirectory, db)
		%check that the database has the proper fields
	if isempty(db)
        error('mean_response:EmptyDB','The database is empty');
	end
	
	if length(db) ~= length([db.stimOnsetIndex])
		% if all of the db elements don't have a nonempty onset index,
		% throw error
		error('mean_response:NotAllStimOnset',...
			'All elements in database must have nonzero stimonsets for proper alignment');
	end
	
	stimOnsets = [db.stimOnsetIndex];
	minStimOnset = min(stimOnsets);
	maxStimOnset = max(stimOnsets);
	
    %loop through trials and display the points
	for i = 1:length(db)-1
		%get the AP indicies
		iterNum = db(i).iterNum;
		
		%load the recording file and get the action potential indicies
		fileLoc = [expDirectory '/recSegments/raw/recData_' num2str(iterNum) '.mat'];
		load(fileLoc);
		
		v = recData.v;
		
		if i == 1
			normalizedLength = length(v) - (maxStimOnset-minStimOnset);
			summedV = zeros(normalizedLength,1);
		end
		
		stimOnset = stimOnsets(i);
        
		thisStart = stimOnset-minStimOnset+1;
		summedV = summedV + v(thisStart:thisStart+normalizedLength-1);

	end
	
	avgV.v = summedV/length(db);
	avgV.stimOnsetIndex = minStimOnset;
end