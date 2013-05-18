%% test scripts

test_data = recSegment.v(1:2:end);
dt = 1/10000;
dy = 1;
props.baseline = -40;
props.file_type = 'matlab';
props.spike_finder = 1;

a_trace = trace(test_data, dt, dy, 'my test trace', props);
a_spikes = spikes(a_trace);