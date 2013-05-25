%% view_rec
% Using textscan_rec.m
% Input: expDirectory	: (e.g. '\2013-3-6 in vivo')
%        startAt		: iteration # to start at (in seconds)
% Commands: n			: proceed to next recording
%           stop		: stop
% Format of recording file
    % row 1: time
    % row 2: voltage
    % row 3: motor sense
    % row 4: stim

function [] = view_rec(fileLoc, startAt, sigYLims, stimYLims)
    
    numSamplesPerSegment = 18670;
    formatString = '%f32%f32%f32%f32%*q';
    
    fid = fopen(fileLoc,'rt'); %open the file
	
	fileHeaderLines = 23;
    
    iterNum = startAt;
	command = '';
    
    lineNum = numSamplesPerSegment*startAt;
    
	while ~feof(fid) && ~strcmp(command, 'stop')
		
		disp(['Iteration # ' int2str(iterNum)])
		
		if iterNum == startAt % first iteration
			numHeaderLines = fileHeaderLines+lineNum; % start off at the line number of 'startAt' + 22
		else
			numHeaderLines = 0; % otherwise, keep going
		end
		
		% Read the labview file and get data for plotting
		recSegment = textscan_rec(fid, numSamplesPerSegment, formatString, numHeaderLines, 1);
		
		% Plot the data in recSegment
		set(gcf,'name',['Segment ' int2str(iterNum)]);
		
		plotXLim = [min(recSegment.t),max(recSegment.t)];
		
		if(iterNum== 72)
			disp('hello');
		end

		subplot(2,1,1); hold on;
		plot(recSegment.t,recSegment.v); % in mV
		title(['I_{inj} = ' num2str(recSegment.stimVal) 'pA']);
		ylabel('V_m (mV)');
		if recSegment.motorStimOnset > 0
			disp(recSegment.motorStimOnset);
			plot((recSegment.motorStimOnset/20000+min(recSegment.t))*[1,1],...
				sigYLims,'r'); %plot stim onset line in red
		end
		xlim(plotXLim); ylim(sigYLims);
		hold off;

		subplot(2,1,2); hold on;
		plot(recSegment.t,recSegment.sense);
		xlabel('Time (s)');
		xlim(plotXLim); ylim(stimYLims);
		hold off;
		
		% Accept commands from the user
		while true
			command = input('Command: ', 's');
			switch command
				case 'n'
					disp('next');
					break;
				case 'stop'
					break;
				% more commands can be added here
				otherwise
					disp('next');
					break;
			end
		end
        
		iterNum = iterNum + 1;
	end
    
	fclose(fid);
	disp('DONE')
end

