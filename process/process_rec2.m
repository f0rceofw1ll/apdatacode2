%% process_rec2
% Using textscan_rec.m
% Input: expDirectory	: (e.g. '\2013-3-6 in vivo')
%		 APthreshold	: threshold (in mV) for AP / peak detection
% Format of recording file
    % row 1: time
    % row 2: voltage
    % row 3: motor sense
    % row 4: stim

function [] = process_rec2(expDirectory, APthreshold)
    
	%loop through the contents of the experimetnal derectory
	%folderLoc = [expDirectory '/whisker_stim_folder/'];
	folderLoc = [expDirectory];
    listing = dir([folderLoc '/*.lvm']);
	listing = {listing.name};
	
	mkdir([expDirectory '/recSegments']); % make directory for recording files
	mkdir([expDirectory '/recSegments/raw']);

	decimalPlaces = 3;

	stimDataArray = [];

	for i = 1:length(listing)
		disp(['Iteration: ' int2str(i)]);
		file = listing{i};
		% import data from the file (1 s)

		fileLoc = [folderLoc '/' file];	
		
		[recData] = parse_whisker_stim_folder_file(fileLoc);
		recData.iterNum = i-1;
		
		% find AP peaks
		sel = (max(recData.v)-min(recData.v))/4;
		[peakLoc, peakAmp] = peak_finder(recData.v,sel,APthreshold);
		peakAmp(peakLoc < 5) = [];
		peakLoc(peakLoc < 5) = [];

		% remove the t and v fields
		stimSegment = recData;
		stimSegment = rmfield(stimSegment,{'v'});
		% calculate signal mean (doesn't belong in stimSegment, but we want
		% to filter by this
		stimSegment.signalMean = mean(recData.v);

		% create an array of stimSegment structures
		stimDataArray = [stimDataArray, stimSegment];

		%rec segment data
		recData.iterNum = i - 1;
		recData.peakLoc = peakLoc;
		recData.peakAmp = peakAmp;

		% save the recording segment
		save([expDirectory '/recSegments/raw/recData_' int2str(recData.iterNum) '.mat'], 'recData');

	end
	%save the stimulus data
	save([expDirectory '/recSegments/stimDataArray.mat'], 'stimDataArray');
	disp('DONE');
end

