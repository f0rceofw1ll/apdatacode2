%% FIGURE
% Superimposed recordings
% Inputs: experiment directory (e.g. '\2013-3-6 in vivo')
% Inputs: tell it which segments you want it to plot
% Output: stimmed and unstimmed portion array

%% USING '..\Out\2013-03-22 in vivo\experiment_51536 PM_PC' <3/24/13>
%%
function [recVs] = superimposeRecSegments(expDirectory)

mkdir([expDirectory '\Analysis']) % make directory for recording files
segDir = [expDirectory '\recSegments\'];

r0_1 = 'segment_iteration=50_I=0.mat';
r0_2 = 'segment_iteration=51_I=0.mat';
r0_3 = 'segment_iteration=30_I=0.mat';
r25 = 'segment_iteration=56_I=25.mat';
r40 = 'segment_iteration=98_I=40.mat';
r50 = 'segment_iteration=26_I=50.mat';
r60 = 'segment_iteration=115_I=60.mat';
r75 = 'segment_iteration=64_I=75.mat';
rNeg40 = 'segment_iteration=410_I=-40.mat';
rNeg50 = 'segment_iteration=257_I=-50.mat';

names = {r0_1, r0_2, r0_3, r25, r40, r50, r60, r75, rNeg40, rNeg50};

filteredLength = 20000-19;
recVs = zeros(filteredLength,10);
for i = 1:length(names)

    eval(['load(''' segDir names{i} ''');'])
    recVs(:,i) = butter_filter(recSegment);
end

tIndex = 0:filteredLength*3-1;

figure
plot(tIndex, [recVs(:,1); recVs(:,2); recVs(:,3)], 'k-')
hold on
plot(tIndex(filteredLength:2*filteredLength-1), recVs(:,4), 'k-', ...
    tIndex(filteredLength:2*filteredLength-1), recVs(:,5), 'k-', ...
    tIndex(filteredLength:2*filteredLength-1), recVs(:,6), 'k-', ...
    tIndex(filteredLength:2*filteredLength-1), recVs(:,7), 'k-',...
    tIndex(filteredLength:2*filteredLength-1), recVs(:,8), 'k-',...
    tIndex(filteredLength:2*filteredLength-1), recVs(:,9), 'k-',...
    tIndex(filteredLength:2*filteredLength-1), recVs(:,10), 'k-', 'linewidth', 1)

saveas(gcf, [expDirectory '\Analysis\FIGURE_superimposedRecs.fig'])
