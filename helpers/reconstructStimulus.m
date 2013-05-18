%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reconstruct stimulus from parameters in stimData
% INPUTS: stimData structure
% OUTPUTS:		stimulusWaveform

function [stimulusWaveform] = reconstructStimulus(stimData)
	fs = 20000;
	d = diff(stimData.sense);
	stimOnset = find(max(d) == d);
	stimOutset = find(min(d) == d);
	stimulusWaveform = [];
	waveform = [];
	switch stimData.protocolName
		case 'triangle'
			%slope is in volts / sec
			slope = stimData.tslope/fs;
			k = stimData.toffset;
			while k < stimData.tamplitude
				waveform = [waveform k];
				k = k + slope;
			end
			while k > 0
				waveform = [waveform k];
				k = k - slope;
			end
			stimulusWaveform = [stimData.toffset*ones(1,stimOnset) waveform];
			stimulusWaveform = [stimulusWaveform stimData.toffset*ones(1,length(stimData.sense)-length(stimulusWaveform))];
		case 'exponential'
			stimulusWaveform = stimData.eoffset*ones(1,stimOnset);
			% TODO: what time constant was used?!
			tau = 5; % ms
			peak = stimOnset + floor((stimOutset - stimOnset)/2);
			
		case 'pulse'
			stimulusWaveform = [stimData.poffset*ones(1,stimOnset)];
			stimulusWaveform = [stimulusWaveform stimData.pamplitude*ones(1,stimOutset-stimOnset)];
			stimulusWaveform = [stimulusWaveform stimData.poffset*ones(1,length(stimData.sense)-length(stimulusWaveform))];
		otherwise
			stimulusWaveform = zeros(1,length(stimData.sense));
	end
end