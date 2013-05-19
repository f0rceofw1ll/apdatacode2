%% load_experiment_data.m
% called by analyze_experiments.m
% returns the fields for the structure
function [clog_test, neuron_hunting, gigaseal_traces, whole_cell,...
    date, result, initial_depth, recording_file,...
    current_trace_file, voltage_offset, memtest_rec_file, vclamp_folder_names, iclamp_folder_names,...
    whisker_stim_folder]...
    = load_experiment_data...
                                        (expDirectory, expList, i)

clog_test = 0;
neuron_hunting = 0;
gigaseal_traces = 0;
result = 'Unknown';
whole_cell = 0;
initial_depth = 0; % micrometers
voltage_offset = 0;

whisker_stim_folder = []; % only after 5/7/13
vclamp_folder_names = [];
iclamp_folder_names = [];

date = 0;
%time = 0; 5/9/13 no longer recording time of experiment since recording file does not
%give an accurate time reading

try
    clog_test = lvm_import([expDirectory expList(i).name '/clog_test.lvm'],0);
    %Grab date and time from clog test
    date = clog_test.Date;
catch ME
    if (strcmp(ME.identifier,'MATLAB:badsubscript'))
        disp('Empty file')
    elseif (length(ME.message)>14 && strcmp(ME.message(1:14), 'File not found'))
        disp('No clog test')
    else
        rethrow(ME)
    end
end

try
    neuron_hunting = lvm_import([expDirectory expList(i).name '/neuron_hunting.lvm']);
    if date == 0
        %Grab date and time from clog test
        
        date = neuron_hunting.Date;
    end
catch ME
    if (strcmp(ME.identifier,'MATLAB:badsubscript'))
        disp('Empty file')
    elseif (length(ME.message)>14 && strcmp(ME.message(1:14), 'File not found'))
        disp('No neuron hunting')
    else
        rethrow(ME)
    end
end

% gigasealing traces 
try
    gigaseal_traces = lvm_import([expDirectory expList(i).name '/gigaseal_traces.lvm']);
    if date == 0
        %Grab date and time from clog test
        date = clog_test.Date;
    end
catch ME
    if (strcmp(ME.identifier,'MATLAB:badsubscript'))
        disp('Empty file')
    elseif (length(ME.message)>14 && strcmp(ME.message(1:14), 'File not found'))
        disp('No gigasaeal traces')
    else
        rethrow(ME)
    end
end

% whole cell current

try
    whole_cell = lvm_import([expDirectory expList(i).name '/whole_cell_current.lvm']);
catch ME
    if (strcmp(ME.identifier,'MATLAB:badsubscript'))
        disp('No whole-cell currents')
    elseif (length(ME.message)>14 && strcmp(ME.message(1:14), 'File not found'))
        disp('No whole-cell currents')
    else
        rethrow(ME)
    end
end

% outcome
try
    result = textread([expDirectory expList(i).name '/result.lvm'], '%s', 'delimiter', '/n');
catch ME
    if (strcmp(ME.identifier,'MATLAB:textread:FileNotFound'))
        disp('No result.')
    else
        rethrow(ME)
    end
end

% current trace file
current_trace_file = [expDirectory expList(i).name '/current_traces.lvm'];

if ~exist(current_trace_file, 'file')
    current_trace_file = [];
end

% voltage offset
try
    voltage_offset = load([expDirectory expList(i).name '/voltage_offset.lvm']);
catch ME
    disp('No voltage offset')
end

% Voltage/current clamp folders
allFiles = dir([expDirectory expList(i).name]);
isub = [allFiles.isdir];
folderNames = {allFiles(isub).name}';

for j = 1:length(folderNames)

    currentFolder = folderNames{j};
    if strfind(currentFolder, 'Vclamp') % if found a folder with Vclamp in the name
        vclamp_folder_names{end+1} = [expDirectory expList(i).name '/' currentFolder];
    elseif strfind(currentFolder, 'Iclamp') % if found a folder with Iclamp in the name
        iclamp_folder_names{end+1} = [expDirectory expList(i).name '/' currentFolder];
    end
end


% initial_depth
try
    initial_depth = dlmread([expDirectory expList(i).name '/initial_depth.lvm']);
catch ME
    if (strcmp(ME.identifier,'MATLAB:dlmread:FileNotOpened'))
        disp('No initial_depth.')
    else
        rethrow(ME)
    end
end


% Recording: check if either recording or whisker stimulation recording exists
recording_file = [expDirectory expList(i).name '/recording.lvm'];

if ~exist(recording_file, 'file')
    whisker_file = [expDirectory expList(i).name '/whisker_stim.lvm'];
    if ~exist(whisker_file, 'file')
        recording_file = [];
    else
        recording_file = whisker_file;
    end
end


% Membrane test
memtest_rec_file = [expDirectory expList(i).name '/membrane_test_recordings.lvm'];

if ~exist(memtest_rec_file, 'file')
    memtest_rec_file = [];
end

% Whisker stim folder (on and after 5/7/13)
whisker_stim_folder = [expDirectory expList(i).name '/whisker_stim_folder'];

if ~exist(whisker_stim_folder, 'dir')
    whisker_stim_folder = [];
end

end


% Recording: not saving b/c it's too big
% try
%     recording = lvm_import([expDirectory expList(i).name '/recording.lvm']);
%     if date == 0
%         %Grab date and time from clog test
%         date = clog_test.Date;
%         time = clog_test.Time;
%     end
% catch ME
%     if (strcmp(ME.identifier,'MATLAB:badsubscript'))
%         disp('Empty file')
%     elseif (length(ME.message)>14 && strcmp(ME.message(1:14), 'File not found'))
%         disp('File does not exist')
%     else
%         rethrow(ME)
%     end
% end


% Vholding
% 4/30: no longer used - Vholding will be gotten from vclcamp
% try
%     Vholding = dlmread([expDirectory expList(i).name '/Vholding.lvm']);
% catch ME
%     if (strcmp(ME.identifier,'MATLAB:dlmread:FileNotOpened'))
%         disp('No Vholding.')
%     else
%         rethrow(ME)
%     end
% end

% Rseries
% 4/30: no longer used - Rseries will be gotten from vclcamp or whole cell
% currents
% try
%     Rseries = dlmread([expDirectory expList(i).name '/Rseries.lvm']);
% catch ME
%     if (strcmp(ME.identifier,'MATLAB:dlmread:FileNotOpened'))
%         disp('No Rseries.')
%     else
%         rethrow(ME)
%     end
% end

% Iholding
% 4/30: no longer used - Iholding will be gotten from vclcamp 
% try
%     Iholding = dlmread([expDirectory expList(i).name '/Iholding.lvm']);
% catch ME
%     if (strcmp(ME.identifier,'MATLAB:dlmread:FileNotOpened'))
%         disp('No Iholding.')
%     else
%         rethrow(ME)
%     end
% end
