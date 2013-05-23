function [  ] = reset_all_recorded_trials
% reset_all_recorded_files: clears the structure
% combinedAnalysis/all_recorded_trials.mat
% error usually due to improper path

in = input('Reset all_recorded_trials file? [y]/n ', 's');
switch in
    case 'y'
        all_recorded_trials = autopatch_trial.empty;
        save('../combinedAnalysis/all_recorded_trials.mat', 'all_recorded_trials')
end

end

