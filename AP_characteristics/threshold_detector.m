%% threshold_detector

function [APindices APmagnitudes]= threshold_detector(v, threshold)

[APindices APmagnitudes] = peakfinder(v, [], threshold);
end