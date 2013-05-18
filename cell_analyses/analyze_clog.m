%% analyze_clog.mat
% Take the mat files and analyze the pipette clog data

% Assume all MATLAB files start with 'mat_'

function [meanClog stdClog] = analyze_clog(expDirectory)

mprefix = 'mat_';
mList = dir([expDirectory '\' mprefix '*']);

meanClog = zeros(1,length(mList));
stdClog = zeros(size(meanClog));

for i = 1:length(mList)
    mDir = [expDirectory mList(i).name];
    load(mDir); % thisshould load the rec file
    
    ct = 0;
    if isstruct(rec.clog_test)
        ct = rec.clog_test.Segment1.data;
    end
    
    meanClog(i) = mean(ct); % mean of clog resistance test
    stdClog(i) = std(ct); % std
end

figure

numExp = 1:length(mList);
h = errorbar(numExp, meanClog, stdClog, 'ko', 'linewidth' ,2);
xlabel('Experiment #')
ylabel('Resistance (MOhms)')
