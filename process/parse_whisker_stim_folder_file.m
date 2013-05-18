function [ recData ] = parse_whisker_stim_folder_file( whisker_folder_file )
%parse_whisker_stim_folder_file Summary of this function goes here
%   Detailed explanation goes here
    
    lvm_file = lvm_import(whisker_folder_file,0);
    
    segment = lvm_file.Segment1;
    
    v = segment.data(:,1); % neural voltage
    sense = segment.data(:,2); % motor sense current
    stim = segment.data(:,3); % current clamp
    
    stim = mean(stim); % mean stimulation amplitude
    
    comment = segment.Comment;
    [ protocolName, triangle, pulseTrain, exponential] = parseComment( comment );
    
    recData = struct('tslope', [], 'toffset', [], 'tamplitude', [],...     % triangle
        'pamplitude', [], 'poffset', [], 'pfrequency', [], 'pnum', [], ... % pulse train
        'eamplitude', [], 'eoffset', []);                                  % exponential

    recData.v = v;
    recData.sense = sense;
    recData.stim = stim;
    recData.protocolName = protocolName;

    switch protocolName
        case 'triangle'
            recData.tamplitude = triangle.tamplitude;
            recData.tslope = triangle.tslope;
            recData.toffset = triangle.toffset;
        case 'pulsetrain'
            recData.pamplitude = pulseTrain.pamplitude;
            recData.poffset = pulseTrain.poffset;
            recData.pfrequency = pulseTrain.pfrequency;
            recData.pnum = pulseTrain.pnum;
        case 'exponential'
            recData.eamplitude = exponential.eamplitude;
            recData.eoffset = exponential.eoffset;
        case 'none'
           
        otherwise
            error('parse_whisker_stim_folder error: protocolName not found!')
    end
    
    diffThreshold = 0.1;
    
    % Not done yet - this will define stimOnset and stimOffset
    recData.stimOnsetIndex = find(diff(sense) > .25, 1);
	if isempty(recData.stimOnsetIndex)
		recData.stimOnsetIndex = max(diff(sense));
	end
    recData.stimOutsetIndex = find(diff(sense) < .25, 1);
    if isempty(recData.stimOutsetIndex)
		recData.stimOutsetIndex = min(diff(sense));
	end
end

