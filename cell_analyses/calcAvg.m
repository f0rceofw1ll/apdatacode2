%% calcAvg.m
% Calculates average of 1-second recording segment
% Input: recSegment (contains t, v, stimVal)
% Output: avgV - average value across the recording
% Used by analyze_large_recordings

function avgV = calcAvg(recSegment)
    
    avgV = mean(recSegment.v);
    
end