%% Pandora testing

samplingRate = 10000;
dt = 1/samplingRate;
dy = 1e-3; % mV

test_data = recSegment.v;
test_data = double(test_data(1:2:end));

props = struct;
if exist('filtfilt', 'file') ~= 2
  % If no signal processing toolbox, use  spike_finder method #2
  props = struct('spike_finder', 2, 'threshold', -30);
end

a_trace = trace(test_data, dt, dy, 'my test trace', props);
plot(a_trace)
a_spikes = spikes(a_trace);
