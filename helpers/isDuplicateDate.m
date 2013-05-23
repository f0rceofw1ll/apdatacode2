function [ isDuplicate ] = isDuplicateDate(expFolderName, all_recorded_trials)
% isDuplicateDate Checks to see if the experiment in expFolderName already
% appears in all_recorded_trials
%   Used by create_autopatcher_trial_objs
%   expFolderName should be of the format '2013-05-18 in vivo'
%   date field in all_recorded_trials should be in the format '2013/05/18'

    dates = {all_recorded_trials.date};
    dates = unique(dates); % only look at the unique dates - don't care about repeats
    isDuplicate = 0;
    
    for i = 1:length(dates)
        currentDate = dates{i};
        currentDate = strrep(currentDate, '/', '-');
        if strfind(expFolderName, currentDate)
            isDuplicate = 1; % found duplicate date
            break
        end
    end
end

