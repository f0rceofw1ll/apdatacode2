%% view_rec2.m
% View all recordings in whisker_stim_folder
% Inputs: expDirectory: (i.e. C:\Greg\Out\2013-05-08 in
%                       vivo\experiment_10556 PM_PC\)
%         startAt: iteration number
%         sigYLims: display limits [lower upper]
%         stimYLims: display limits [lower upper]

function [] = view_rec2(expDirectory, startAt, sigYLims, stimYLims)
    %% INITIALIZE
	close all;
	figure;

	%% CONSTANTS
	fs = 20000;
	
	% check if there is actually a whisker_stim_folder
	if ~exist(expDirectory,'dir')
		error('view_rec2:stimfoldernotfound', 'Stimulus folder not found');
	end

    mkdir([expDirectory 'recSegments']) % make directory for recording files
    folderLoc = [expDirectory];

    iterNum = startAt;
	command = '';
    
	while ~strcmp(command, 'stop')
		disp(['File # ' int2str(iterNum)])
		
		if iterNum == 0
            iterString = [];
        else
            iterString = ['_' int2str(iterNum)];
		end
        
		% check to see if the recData file exists
		potentialFname = [expDirectory '/recSegments/raw/recData_' int2str(iterNum) '.mat'];
		if exist(potentialFname,'file')
			load(potentialFname);
		else
			% Read the labview file and get data for plotting
			recData = parse_whisker_stim_folder_file( [folderLoc '/whisker_stim' iterString '.lvm'] );
		end
		
        t = 0:1/fs:length(recData.v)/fs;
        t = t(1:end-1);
        
		% Plot the data in recData
		
		%plotXLim = [0 length(recData.v)];
		
        set(gcf,'name',['Segment' iterString]);
		subplot(2,1,1);
		plot(t,recData.v); % in mV
		title(['I_{inj} = ' num2str(recData.stim) 'pA']);
		ylabel('V_m (mV)');
		if ~strcmp(recData.protocolName, 'none')
            hold on
			plot(recData.stimOnsetIndex/20000*[1,1],...
				sigYLims,'r'); %plot stim onset line in red
		end
		if isfield(recData, 'peakLoc')
			plot(recData.peakLoc/fs, recData.peakAmp, 'ro');
		end
		hold off;
        

		ylim(sigYLims);

		subplot(2,1,2);
		plot(t,recData.sense);
		xlabel('Time (s)');
		ylim(stimYLims);
		
		% Accept commands from the user
		while true
			command = input('Command: ', 's');
			switch command
				case 'n'
					disp('next');
                    close
					break;
				case 'stop'
					break;
                case 'save'
                    saveRecSegment2(expDirectory, recData, iterNum)
                    break;
                case 'goto'
                    gotoNum = input('Segment # : ');
                    iterNum = gotoNum - 1; % since iterNum will be incremented by 1 at the end
                    close
                    break;
				% more commands can be added here
				otherwise
					disp('next');
					break;
			end
		end
        
		iterNum = iterNum + 1;
	end
    
	disp('DONE')
end

