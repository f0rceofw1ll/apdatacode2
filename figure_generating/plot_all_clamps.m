function plot_all_clamps
%PLOT_ALL_CLAMPS plots all current/voltage clamp recordings from combinedAnalysis/allrecorded_trials.mat_
%   Use to generate a sample voltage or current clamp figure
%   Uses helpers/sample_clamp_figure

    load('../combinedAnalysis/all_recorded_trials.mat')
    
    for i = 1:length(all_recorded_trials)
        sample_clamp_figure(all_recorded_trials(i), 'v'); % v for voltage clamp, i for current clamp
    end
end

% good current clamps (with decent spikes)
% 2013-05-04 65444
% 2013-05-04 63834
% 2013-05-16 54929
% 2013-05-16 21831
% 2013-05-18 62610 (OK, not great)