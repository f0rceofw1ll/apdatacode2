function [] = cell_characteristics(  )
%cell_characteristics displays/plots all the important cell characteristics
%   Finds all_recorded_trials.mat file in folder 'combinedAnalysis'.
%%

% 0: all plots on the same figure
% 1: all plots on separate figures
sameFigure = 0; 

close all

load('..\combinedAnalysis\all_recorded_trials.mat')

all_recorded_trials(13).RMP = -43.25; % manually inspected from recordings
all_recorded_trials(16).RMP = -37.46;
all_recorded_trials(7).RMP = -43.2;
all_recorded_trials(15).RMP = -31.8;
all_recorded_trials(1).RMP = -70.3;
all_recorded_trials(23).RMP = -64.1;
all_recorded_trials(20).RMP = -61.32;
all_recorded_trials(14).maxR = 1593; % visual inspection of
%gigasealing trace
all_recorded_trials(13).maxR = 4002;
all_recorded_trials(14).maxR = 3011;
all_recorded_trials(4).maxR =  2814;
% holding time > 5 minutes
LongTrials = all_recorded_trials([all_recorded_trials.holding_time] > 5*60);
LongAndRealTrials = LongTrials([LongTrials.RMP] < -40);

allDepths = [LongAndRealTrials.finalDepth];
allRa = [LongAndRealTrials.Ra];
allRm = [LongAndRealTrials.Rm];
allCm = [LongAndRealTrials.Cm];
allIh = [LongAndRealTrials.Ih];
allMaxR = [LongAndRealTrials.maxR];
allRMP = [LongAndRealTrials.RMP];
allHoldingTime = [LongAndRealTrials.holding_time];
allRin = [LongAndRealTrials.Rin];

allVOffset = [LongAndRealTrials.voltage_offset];

% Corrections

%% Ra
if sameFigure
    figure
    xlabel('Depth (\mum)', 'fontsize', 12)
else
    subplot(4,2,2)
end
plot(allDepths, allRa*1e-6, 'o', 'linewidth', 2)
title('Access resistance (Ra)', 'fontsize' ,12)
ylabel('R (M\Omega)', 'fontsize', 12)

%% Rm
if sameFigure
    figure
    xlabel('Depth (\mum)', 'fontsize', 12)
else
    subplot(4,2,4)
end
plot(allDepths, allRm*1e-6, 'o', 'linewidth', 2)
title('Membrane resistance (Rm)', 'fontsize' ,12)
ylabel('R (M\Omega)', 'fontsize', 12)

%% Cm
if sameFigure
    figure
    xlabel('Depth (\mum)', 'fontsize', 12)
else
    subplot(4,2,6)
end
plot(allDepths, allCm*1e12, 'o', 'linewidth', 2)
title('Membrane capacitance (Cm)', 'fontsize' ,12)
ylabel('C_m (pF)', 'fontsize', 12)

%% Rin
if sameFigure
    figure
else
    subplot(4,2,8)
end
plot(allDepths, allRin*1e-6, 'o', 'linewidth', 2)
title('Input Resistance', 'fontsize' ,12)
xlabel('Depth (\mum)', 'fontsize', 12)
ylabel('R (M\Omega)', 'fontsize', 12)

%% Iholding
if sameFigure
    figure
    xlabel('Depth (\mum)', 'fontsize', 12)
else
    subplot(4,2,1)
end
% 12.5 is the conversion factor in patch chip
% *1e12 to convert to pA
offsets = allVOffset/12.5e6*1e12;
plot(allDepths, allIh, 'o', 'linewidth', 2)
title('Holding current (pA)', 'fontsize' ,12)
ylabel('I_h (pA)', 'fontsize', 12)

%% Max R
if sameFigure
    figure
    xlabel('Depth (\mum)', 'fontsize', 12)
else
    subplot(4,2,3)
end
plot(allDepths, allMaxR/1000, 'o', 'linewidth', 2) % Gigaohms
title('Gigasealing resistance', 'fontsize' ,12)
ylabel('R (G\Omega)', 'fontsize', 12)


%% RMP
if sameFigure
    figure
    xlabel('Depth (\mum)', 'fontsize', 12)
else
    subplot(4,2,5)
end
plot(allDepths, allRMP, 'o', 'linewidth', 2)
title('Resting potential', 'fontsize' ,12)
ylabel('RMP (mV)', 'fontsize', 12)


%% Holding time
if sameFigure
    figure
else
    subplot(4,2,7)
end
plot(allDepths, allHoldingTime/60, 'o', 'linewidth', 2) % holding time in minutes
title('Holding Time', 'fontsize' ,12)
ylabel('Holding time (min)', 'fontsize', 12)
xlabel('Depth (\mum)', 'fontsize', 12)

disp(['N = ' int2str(length(LongAndRealTrials)) ' trials'])
disp(['Num RMP = ' int2str(length(allRMP(~isnan(allRMP))))])
disp(['Num Iholding = ' int2str(length(allIh(~isnan(allIh))))])
disp(['Num Ra = ' int2str(length(allRa(~isnan(allRa))))])
disp(['Num Rm = ' int2str(length(allRm(~isnan(allRm))))])
disp(['Num Cm = ' int2str(length(allCm(~isnan(allCm))))])
disp(['Num maxR = ' int2str(length(allMaxR(~isnan(allMaxR))))])
disp(['Num HoldingTime = ' int2str(length(allHoldingTime(~isnan(allHoldingTime))))])
disp(['Num Rin = ' int2str(length(allRin(~isnan(allRin))))])
end


