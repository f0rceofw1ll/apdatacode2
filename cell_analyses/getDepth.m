%% getDepth
% depth is the initial depth + length of neuron hunting * step size
% (assuming 2 microns)

function depth = getDepth(rec)

nh = 0;

if isstruct(rec.neuron_hunting) % if there is a legit neuron hunting trace
    initial_depth = rec.initial_depth;
    nh = rec.neuron_hunting.Segment1.data;
else
    initial_depth = NaN; % otherwise, make this an invalid number
end

if initial_depth == 0 % in earlier exps I didn't record initial depth
    initial_depth = 550;
end


step_size = 2; % microns
depth = initial_depth + length(nh)*step_size;
end