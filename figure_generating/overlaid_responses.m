%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% psth : Peristimulus Time Histogram
% INPUTS
% expDirectory		: (e.g. '\2013-3-6 in vivo')
% db                : structure of stimulus (array of structures)
% fs                : sampling frequency (Hz)
% sBefore           : samples to display before (samples)
% sAfter            : samples to display after onset of stimulus (samples)

function [] = overlaid_responses(expDirectory, db, fs, sBefore, sAfter, plotYLims, stimYLims)
		%check that the database has the proper fields
	if isempty(db)
        error('overlaid_responses:EmptyDB','The database is empty');
	end
    
    tAfter = sAfter/fs;     % (s)
    tBefore = sBefore/fs;   % (s)
    
    figure;
    subplot(2,1,1); hold on;
	
	timeVector = -tBefore:1/fs:tAfter;
	
	totalLength = sBefore + sAfter + 1;
	sumV = zeros(totalLength,1);
    
    %loop through trials and display the points
	for i = 1:length(db)-1
		%get the AP indicies
		iterNum = db(i).iterNum;
		
		%load the recording file and get the action potential indicies
		fileLoc = [expDirectory '/recSegments/raw/recData_' num2str(iterNum) '.mat'];
		load(fileLoc);
		
		v = recData.v;
		motorStimOnset = recData.stimOnsetIndex;

		vClippingStart = motorStimOnset-sBefore;
		vClippingEnd = motorStimOnset+sAfter;
		if vClippingStart < 1
			vClippingStart = 1;
		end
		if vClippingEnd > length(v)
			vClippingEnd = length(v);
		end
		v = v(vClippingStart:vClippingEnd);
		%zero pad for averaging purposes
		v = [v;mean(v)*ones(totalLength-length(v),1)];
		plot(timeVector(1:length(v))*1000,v, 'Color', [.6,.6,.6]); %plot each line in gray
		sumV = sumV + v;
	end
	
	%plot the average response
	avgV = sumV/(length(db)-1);
	avgVPlot = avgV;
% 	avgV = mean_response(expDirectory, db);
% 	vClippingEnd = avgV.stimOnsetIndex+sAfter;
% 	vClippingStart = avgV.stimOnsetIndex-sBefore;
% 	if vClippingEnd > length(avgV.v)
% 		vClippingEnd = length(avgV.v);
% 	end
% 	if vClippingStart < 1
% 		vClippingStart = 1;
% 	end
% 	avgVPlot = avgV.v(vClippingStart:vClippingEnd);
	plot(timeVector(1:length(avgVPlot))*1000,avgVPlot, 'k','LineWidth',2);
	
	plot([0,0], plotYLims, 'r'); %plot stim onset line in red
	
	ylim(plotYLims); xlim([-tBefore, tAfter]*1000);
	ylabel('Transmembrane Voltage, V_m (mV)');
	
	subplot(2,1,2);
	sense = db(i).sense;
	senseClippingStart = motorStimOnset-sBefore;
	senseClippingEnd = motorStimOnset+sAfter;
	if senseClippingStart < 1
		senseClippingStart = 1;
	end
	if senseClippingEnd > length(sense)
		senseClippingEnd = length(sense);
	end
	sense = sense(senseClippingStart:senseClippingEnd);
	plot(timeVector(1:length(sense))*1000,sense);

	ylim(stimYLims); xlim([-tBefore, tAfter]*1000);
	
	ylabel('Motor stimulation voltage (V)');
	xlabel('Time from stimulus onset (ms)');
end