%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% overlaid_APs: show APs overlaid on top of each other
% INPUTS
% expDirectory		: (e.g. '\2013-3-6 in vivo')
% db                : structure of stimulus (array of structures)
% fs                : sampling frequency (Hz)
% sBefore           : samples to display before (samples)
% sAfter            : samples to display after onset of stimulus (samples)

function [] = overlaid_APs(expDirectory, db, fs, sBefore, sAfter)
		%check that the database has the proper fields
	if isempty(db)
        error('overlaid_APs:EmptyDB','The database is empty');
	end
    
    tAfter = sAfter/fs;     % (s)
    tBefore = sBefore/fs;   % (s)
    
    f = figure('Name', 'Overlaid action potentials');
	
	timeVector = -tBefore:1/fs:tAfter;
	
	totalLength = sBefore + sAfter + 1;
	sumV = zeros(totalLength,1);
    
    %loop through trials and display the points
    avgV = [];
    avgPeakAmplitude = [];
    halfwidths = [];
	for i = 1:length(db)-1
		%get the AP indicies
		iterNum = db(i).iterNum;
		
		%load the recording file and get the action potential indicies
		fileLoc = [expDirectory '/recSegments/raw/recData_' num2str(iterNum) '.mat'];
		load(fileLoc);
		
		v = recData.v;
        numPeaks = length(recData.peakLoc);
        
        if numPeaks > 0 % if we find any peaks
            for j = 1:length(numPeaks)
                thisPeakLoc = recData.peakLoc(j);
                try
                    
                    clippedV = v(thisPeakLoc-sBefore:thisPeakLoc+sAfter);
                    hold on, plot(timeVector(1:length(clippedV))*1000, clippedV, 'Color', [.6,.6,.6])
                    avgV = [avgV clippedV];
                    baseline = mean(clippedV(sBefore - 100 : sBefore - 50));
                    peak = recData.peakAmp(j);
                    peakAmplitude = peak-baseline;
                    avgPeakAmplitude = [avgPeakAmplitude peakAmplitude];
                    
                    %structure for calculating half width
                    APrange = v(thisPeakLoc-200:thisPeakLoc+200);
                    % half width
                    HW = length([find(APrange > baseline + peakAmplitude/2)]);
                    HW = HW/20000*1000; % convert samples to milliseconds
                    halfwidths = [halfwidths HW];
                catch 
                    disp('overlaid_APs:EmptyDB :: Out of bounds... Continuing...')
                end
                
            end
        end
	end
	
	%plot the average response
	hold on, plot(timeVector(1:length(clippedV))*1000, mean(avgV, 2), 'k-', 'linewidth', 2)
    xlabel('Time (ms)', 'fontsize' ,12)
    ylabel('Voltage (mV)', 'fontsize' ,12)
    
    disp(['Peak amplitude = ' num2str(mean(avgPeakAmplitude)) ' +/- ' ...
        num2str(std(avgPeakAmplitude)) ' mV'])
    disp(['Half-widths = ' num2str(mean(halfwidths)) ' +/- ' ...
        num2str(std(halfwidths)) ' ms'])
end