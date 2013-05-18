%% cellstats_memtest_testbed

close all

load('test_memtest.mat');
stim_onset_index = 750;
stim_offset_index = 1249;
deltaV = 10; % mV!
cellstats_memtest(test_memtest, stim_onset_index, stim_offset_index, deltaV);
