% Modify expression to add input arguments.
% Example:
%   a = [1 2 3; 4 5 6]; 
%   foo(a);
clc; close all;

%% DATA SELECT SELECT
dataDirectory = './data/';
datefolder = '2013-05-18_in_vivo/';
trialNum = 5;
stimDataQuery = {'signalMean <= -50', 'signalMean >= -70', 'limit == 30'};

%% CONSTANTS
fs = 20000;
samplesBefore = 500;
samplesAfter = 10000;
PSTHbinwidth = 50;
PSTHresponseWindow = 500;
viewSigYLims = [-100,20];
stimYLims = [0,10];
APthresholddefault = 0;

%% LOAD DATA
% check if the experiment has been processed
all_recorded_trials_file = [dataDirectory datefolder 'combinedAnalysis/all_recorded_trials.mat'];
if ~exist(all_recorded_trials_file,'file')
	create_autopatcher_trial_objs;
end
load([dataDirectory datefolder 'combinedAnalysis/all_recorded_trials.mat']);
if trialNum > length(all_recorded_trials)
	error('dataCruncherScript:notLegitIndex','trialNum is out of bounds');
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