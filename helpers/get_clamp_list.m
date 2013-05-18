function [list_of_clamps] = get_clamp_list(view_recs)
%get_clamp_list Used by sample_clamp_figure.m
%   Input: view_recs, e.g. 20000 x 25 matrix of stimulation protocol profiles
    numRecordings = size(view_recs, 2);
    sizeProfile = length(view_recs);
    
    list_of_clamps = zeros(numRecordings, 1);
    middleIndex = round(sizeProfile/2); % find the middle index in the recording
    for i = 1:numRecordings
        current_profile = view_recs(:, i);
        current_profile_amplitude = current_profile(middleIndex);
        list_of_clamps(i) = current_profile_amplitude;
    end
    
end

