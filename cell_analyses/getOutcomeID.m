function outcomeID = getOutcomeID(resultString)

% Note the outcome IDs will correspond to LabVIEW numbering of the enum
% (i.e. starting w/ 0)

possibleResults = {
    'Pipette OK';
    'Pipette resistance variation too high';
    'Pipette tip blocked';
    'Pipette broken';
    'Pipette resistance too high/low';
    'Neuron hunt failed';
    'Gigasealing failed';
    'Recorded';
    };

outcomeID = strmatch(resultString, possibleResults); % i don't care if it will be removed, i'm using it >:(

if numel(outcomeID) == 0
    outcomeID = 0;
end

outcomeID = outcomeID-1; % starting at 0