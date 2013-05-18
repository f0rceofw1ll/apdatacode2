%% analyze_gigasealing.m
% Take the mat files and analyze the gigaseal tracing data

% Assume all MATLAB files start with 'mat_'

function [] = analyze_gigasealing(expDirectory, plotAll)

mprefix = 'mat_';
mList = dir([expDirectory '\' mprefix '*']);

for i = 1:length(mList)
    mDir = [expDirectory mList(i).name];
    load(mDir); % this should load the rec file
    
        j = 1;
        
        gt = [];
    if isstruct(rec.gigaseal_traces)  %if this structure exists
        while isfield(rec.gigaseal_traces, ['Segment' int2str(j)]) % if this segment exists (there can be multiple segments)
            currentSegment = ['Segment' int2str(j)];            
            gtSegment = rec.gigaseal_traces.(currentSegment).data(:,1);
            gt = [gt; gtSegment];
            j = j+1;
        end
        t = 0:length(gt)-1; % assuming there is no t variable
        if plotAll
            datetime = [rec.date ' ' rec.time(1:8)];
            figure('Name', datetime)
            plot(t, gt, 'ko', 'linewidth', 2)
            title(['Gigaseal traces @ ' datetime])
            xlabel('Time (s)')
            ylabel('Resistance (MOhms)')
        end
    end

end
