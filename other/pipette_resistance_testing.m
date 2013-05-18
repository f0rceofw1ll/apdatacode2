%% Pipette resistance testing
% Pair with pipette_resistance_testing.vi
clear all
close all
numPipettes = 8;

traceDir = '../Out/Resistance Measurements/Traces/';
resDir = '../Out/Resistance Measurements/Resistances/';

allResistances_pc = zeros(11, numPipettes);
allResistances_m = zeros(11, numPipettes);

pc_raw = {}; m_raw = {};
for numP = 1:numPipettes
    trialNum = numP - 1;
    trialStr = int2str(trialNum);
    
    % Patch chip
    traces_pc = lvm_import([traceDir 'patchChip_pipette_' trialStr '.lvm']);
    resistances_pc = lvm_import([resDir 'patchChip_pipette_' trialStr '.lvm']); 
    allResistances_pc(:, numP) = resistances_pc.Segment1.data;
    pc_raw{numP} = traces_pc;
    
    % Multiclamp
    traces_m = lvm_import([traceDir 'Multiclamp_pipette_' trialStr '.lvm']);
    resistances_m = lvm_import([resDir 'Multiclamp_pipette_' trialStr '.lvm']);
    allResistances_m(:, numP) = resistances_m.Segment1.data;
    m_raw{numP} = traces_pc;

end

figure('Name', 'All results')

for i = 1:numPipettes
    subplot(numPipettes, 1, i)
    plot(allResistances_pc, 'ko', 'linewidth', 2);
    hold on
    plot(allResistances_m, 'bo', 'linewidth', 2)
    if i == 1
        title('Resistance measurements', 'fontsize', 12)
    end
end

xlabel('Measurement #', 'fontsize', 12)

figure('Name', 'Difference in resistance')
difference = allResistances_pc - allResistances_m;
errorbar(mean(difference), std(difference), 'ko-', 'linewidth', 2, 'markersize' ,6)
ylabel('|Patch clamp - Multiclamp)| (MOhms)', 'fontsize' ,12)
xlabel('Pipette Number', 'fontsize' ,12)

figure('Name', 'All resistances')
errorbar(1:numPipettes, mean(allResistances_pc), std(allResistances_pc), 'ko', 'linewidth', 2)
hold on,errorbar(1:numPipettes, mean(allResistances_m), std(allResistances_m), 'bo', 'linewidth', 2)
title('Resistance measurements', 'fontsize' ,12)
xlabel('Pipette number', 'fontsize' ,12)
ylabel('Resistance (MOhms)', 'fontsize' ,12)

legend('Patch chip', 'Multiclamp')