%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% neurometric_curve : Neurometric Response Curve
% INPUTS
% expDirectory		: (e.g. '\2013-3-6 in vivo')
% db                : structure of stimulus (array of structures)
% iVar				: independent variable (x-axis of plot)
% window			: response window length (samples)

function [] = neurometric_curve(expDirectory, db, iVar, window)
	%make sure var is numeric
	if ~isnumeric(db(1).(iVar))
		error('neurometric_curve:iVarNotNumeric',...
			['The independent variable, ' iVar ', is not a numeric field of the db']);
	end

	uniqueVals = unique([db.(iVar)]);
	percentResponseArray = [];
	for i = 1:length(uniqueVals)
		value = uniqueVals(i);
		query = [iVar ' == ' num2str(value)];
		dbSubset = query_structure_array(db, {query});
		% loop through the subset of the stimulus structures
		responsesInWindowArray = [];
		for ii = 1:length(dbSubset)
			iterNum = dbSubset(ii).iterNum;
			% load the recording file
			fileLoc = [expDirectory '/recSegments/raw/recData_' num2str(iterNum) '.mat'];
			load(fileLoc);
			% get the number of responses within the stimulus window
			peakLoc = [recData.peakLoc];
			stimOnset = dbSubset(ii).motorStimOnset;
			% save the number of times that the neuron spiked
			responsesInWindow = 0;
			if stimOnset > 0
				responsesInWindow = sum(peakLoc >= stimOnset & peakLoc <= stimOnset + window);
			end
			responsesInWindowArray = [responsesInWindowArray, responsesInWindow];
		end
		% calculate the percentage of time that the neuron responded (spikes)
		percentResponse = 0;
		if ~isempty(responsesInWindowArray)
			percentResponse = sum(responsesInWindowArray>0)/length(responsesInWindowArray);
		end
		percentResponseArray = [percentResponseArray, percentResponse];
	end
	
	% plot
	figure;
	plot(uniqueVals, percentResponseArray);
	ylim([0,1]); xlim([min(uniqueVals),max(uniqueVals)]);
	xlabel(iVar);
	ylabel('Probability of Response');
	title('Neurometric Curve');

end