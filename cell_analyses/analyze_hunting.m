%% analyze_hunting.m
% Take the mat files and analyze the neuron hunting data

% Assume all MATLAB files start with 'mat_'

function [] = analyze_hunting(expDirectory, plotAll)

mprefix = 'mat_';
mList = dir([expDirectory '\' mprefix '*']);

for i = 1:length(mList)
    mDir = [expDirectory mList(i).name];
    load(mDir); % this should load the rec file
    
    nh = 0;
    if isstruct(rec.neuron_hunting)  %if this structure exists
        j = 1;
        
        nh = [];
        while isfield(rec.neuron_hunting, ['Segment' int2str(j)]) % if this segment exists (there can be multiple segments)
            currentSegment = ['Segment' int2str(j)];            
            nhSegment = rec.neuron_hunting.(currentSegment).data;
            nh = [nh nhSegment];
            j = j+1;
        end
        t = 0:length(nh)-1; % assuming there is no t variable
        if plotAll
            datetime = [rec.date ' ' rec.time(1:8)];
            figure('Name', datetime)
            plot(t, nh, 'ko', 'linewidth', 2)
            title(['Neuron hunting @ ' datetime])
            xlabel('Time (s)')
            ylabel('Resistance (MOhms)')
        end

    end

end
