%% Workflow_ik
clc; close all;

%% DATA SELECT
% 1: nothing
% 2: nothing
% 3: good subthreshold, lots of activity 400 ms after stim onset. ~ 10 mV
% subthreshold amplitude
% 4: good APs in the beginning (amplitude ~ 70 mV). Good stim response (high-amplitude APs 40
% ms after stim onset.)
% 5: good overall subthreshold but overall very noisy cell. Bad RMP
% 6: OK APs (-60 to ~-10 swing). Good response to stim (~30 ms after
% onset). Seeing more activity 350 ms after stim onset
% 7: nothing
% 8: nothing
% 9: 
trialNum = 8;
stimDataQuery = {'signalMean <= -50', 'signalMean >= -70'};

%% CONSTANTS
fs = 20000;
samplesBefore = 500;
samplesAfter = 10000;
PSTHbinwidth = 200;
PSTHresponseWindow = 140;
viewSigYLims = [-100,20];
stimYLims = [0,10];
APthresholddefault = 0;

%% LOAD DATA
% assume all_recorded_trials.mat structure already exists
try
    load('../combinedAnalysis/all_recorded_trials.mat');
catch
    error('workflow_ik:Load Data: Could not find all_recorded_trials.mat')
end

if trialNum > length(all_recorded_trials)
	error('workflow_ik:notLegitIndex','trialNum is out of bounds');
end
expDirectory = [all_recorded_trials(trialNum).whisker_stim_folder];

%% VIEW / PROCESS RECORDING
stim_data_array_file = [expDirectory '/recSegments/stimDataArray.mat'];
if ~exist(stim_data_array_file,'file')
	%give the option to view first
	disp('The data from this trial has not been processed');
	a = input('Would you like to view it first? y/n: ','s');
	if strcmp('y', a)
		startAt = input('Start at second [#]: ');
		if ~isnumeric(startAt)
			startAt = 0;
		end
		view_rec2(expDirectory, startAt, viewSigYLims, stimYLims);
	end
	APthreshold = input('Value to threshold APs At? (mV): ');
	if ~isnumeric(APthreshold)
		APthreshold = APthresholddefault;
	end
	process_rec2(expDirectory, APthreshold);
end
stimDataArray = load(stim_data_array_file);
stimDataArray = stimDataArray.stimDataArray;

%% QUERY DATABASE
db = query_structure_array(stimDataArray, stimDataQuery);

%% OVERLAID RESPONSES
overlaid_responses(expDirectory, db, fs, samplesBefore, samplesAfter, viewSigYLims, stimYLims);

%% PSTH
psth(expDirectory, db, fs, samplesBefore, samplesAfter, PSTHresponseWindow, PSTHbinwidth)