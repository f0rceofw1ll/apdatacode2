%% analyze_recording.m
% This only works for SMALL recording files
% Avoid using it 3-20-13
% Take the mat files and analyze the recording tracing data

% Assume all MATLAB files start with 'mat_'

function [] = analyze_recording(expDirectory, plotAll)

mprefix = 'mat_';
mList = dir([expDirectory '\' mprefix '*']);

for i = 1:length(mList)
    mDir = [expDirectory mList(i).name];
    load(mDir); % this should load the rec file
    
        j = 1;
        
        gt = [];
    if isstruct(rec.recording)  %if this structure exists
%         while isfield(rec.gigaseal_traces, ['Segment' int2str(j)]) % if this segment exists (there can be multiple segments)
%             currentSegment = ['Segment' int2str(j)];            
%             gtSegment = rec.recording.(currentSegment).data(:,1);
%             gt = [gt; gtSegment];
%             j = j+1;
%         end
        r = rec.recording.Segment1.data(:,2);
        r = r-1.65;
        r = r*1000;
        t = rec.recording.Segment1.data(:,1);
        if plotAll
            datetime = [rec.date ' ' rec.time(1:8)];
            figure('Name', datetime)
            plot(t, r, 'k-', 'linewidth', 1)
            title(['Neural recording @ ' datetime])
            xlabel('Time (s)')
            ylabel('Voltage (mV)')
        end
    end

end
