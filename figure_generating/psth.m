%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% psth : Peristimulus Time Histogram
% INPUTS
% expDirectory		: (e.g. '\2013-3-6 in vivo')
% db                : structure of stimulus (array of structures)
% fs                : sampling frequency (Hz)
% sBefore           : samples to display before (samples)
% sAfter            : samples to display after onset of stimulus (samples)
% responseWindow    : length of response window (starting at stimulus onset)
% binWidth          : width of bins (s)


function [] = psth(expDirectory, db, fs, sBefore, sAfter, responseWindow, binWidth)
    %check that the database has the proper fields
%     if ~isfield(db, {'motorStimOnset'})
%         error('psth:MissingFields','The database is missing some fields');
% 	end
    
    tAfter = sAfter/fs*1000;     % (ms)
    tBefore = sBefore/fs*1000;   % (ms)
    responseWindow = responseWindow/fs*1000; % (ms)
    binWidth = binWidth/fs*1000; % (ms)
    
    % LOOK AND FEEL
    boxcolor = [0.8,0.8,0.8];
    spikeColor = 'ko';
    responseColor = 'ro';
    
    figure;
    subplot(2,1,1); hold on;
    %display the window (grey box)
	if responseWindow
		rectangle('Position',[0,0,responseWindow,length(db)-1],'FaceColor',boxcolor,'EdgeColor',boxcolor);
	end
	AllAPtimes = [];
    
    %loop through trials and display the points
    for i = 1:length(db)-1
		%get the AP indicies
		iterNum = db(i).iterNum;
		
		%load the recording file and get the action potential indicies
		fileLoc = [expDirectory '/recSegments/raw/recData_' num2str(iterNum) '.mat'];
		load(fileLoc);
		APindices = [recData.peakLoc];
		
		%convert AP indicies to AP times
		normAPindices = [];
		if ~isempty(APindices)
			normAPindices = APindices - recData.stimOnsetIndex;
		end
        normAPtimes = normAPindices./fs*1000;
        APtimes = normAPtimes(normAPtimes > -tBefore & normAPtimes < tAfter);
        
        yvals = (i-1)*ones(length(APtimes),1);
        plot(APtimes,yvals,spikeColor);
		title('Peri-Stimulus Time Histogram');
		
		% save the AP times for histogram plotting
        AllAPtimes = [AllAPtimes; APtimes];
        
        %overlay plot with emphasis on spikes within the plot window
        responseAPtimes = APtimes(APtimes >= 0 & APtimes <= responseWindow);
        plot(responseAPtimes,yvals(1:length(responseAPtimes)),responseColor);
	end
	
	% analyze firing rate
	% before, during and after response window
	APbefore = AllAPtimes(AllAPtimes < 0);
	APduring = AllAPtimes(AllAPtimes >= 0 & AllAPtimes < responseWindow);
	APafter = AllAPtimes(AllAPtimes >= responseWindow);
	
	frBefore = length(APbefore)/length(db)/(tBefore);
	frDuring = length(APduring)/length(db)/(responseWindow);
	frAfter = length(APafter)/length(db)/(tAfter);
    
	disp('Firing Rate');
	fprintf(1,'Before Stimulus         : %.2f Hz\n', frBefore);
	fprintf(1,'Within Response Window  : %.2f Hz\n', frDuring);
	fprintf(1,'After Stimulus          : %.2f Hz\n', frAfter);
	
    xlim([-tBefore, tAfter]); ylim([-.1,length(db)-1+.1]);
    ylabel('Trials');
    
    subplot(2,1,2);
    binCenters = linspace(-tBefore,tAfter,round((tAfter + tBefore)/binWidth)); % (s)
    
    hist(AllAPtimes, binCenters);
	h = findobj(gca,'Type','patch');
	set(h,'FaceColor','k','EdgeColor','k')
    xlim([-tBefore, tAfter]);
    xlabel('Time from stimulus onset (ms)');
    ylabel('Binned Responses');
end