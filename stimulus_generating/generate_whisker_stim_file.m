%% Whisker stim generating file
function stim = generate_whisker_stim_file

samplingRate = 20000; % make sure this is the same as in the LabVIEW VI
try
    load('stimulus_generating/singlepulsemstim')
catch
    error('whikser stimulation file not found!')
end

timeOn = 0.5; % on time in seconds
timeOff = 0.5; % off time in seconds
signal = ones(timeOn*samplingRate, 1);
signal = [signal; zeros(timeOff*samplingRate, 1)];

stim = repmat(signal, 10, 1);

tVec = 0 : 1/samplingRate : length(stim)/samplingRate;
tVec = tVec(1:end-1);

figure, plot(tVec, stim)
try
    save('stimulus_generating/whisker_stim_piezo_input.txt', 'stim', '-ascii')
catch
    error('Unable to save the whisker stim file we created')
end

end