%% stepThroughRec.m
% Input: recording file (mat_experiment_XXXXX AM.mat)
% Input: step size (in seconds)
% Input: sampling rate of recording in Hz
% Output: Step through a recording file

function [] = stepThroughRec(rec, stepSize, samplingRate)

datetime = [rec.date ' ' rec.time(1:8)];
r = rec.recording.Segment1.data(:,2);
t = rec.recording.Segment1.data(:,1);

numSamples = length(t);

currentIndex = 1; % first index to be plotted
DCoffset = -1*(1.51+.05);
figure
while currentIndex+stepSize*samplingRate < numSamples
    
    nextIndex = currentIndex + stepSize*samplingRate;
    recPlot = r(currentIndex:nextIndex);
    tPlot = t(currentIndex:nextIndex);
    plot(tPlot, 1000*(recPlot+DCoffset) , 'k-')
    xlim([min(tPlot) max(tPlot)])
    title(['Neural recording @ ' datetime])
    xlabel('Time (s)')
    ylabel('Voltage (mV)')
    pause
    currentIndex = nextIndex;
    
end