%% getPipetteR
% Pipette resistance (MOhms) as determined by the pipette clog test

function R = getPipetteR(rec)

if isstruct(rec.clog_test) % if there is a legit pipette clog trace
    R = mean(rec.clog_test.Segment1.data);
else
    R = NaN; % otherwise, make this an invalid number
end


end