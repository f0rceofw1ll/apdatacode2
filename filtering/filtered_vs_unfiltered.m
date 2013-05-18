%% Creates figures
% fitlered_vs_unfiltered.svg
% fft.svg
% in the illustrations folder of meetings
function out = filtered_vs_unfiltered

close all
clear all

load('D:\Rotation_2\patch chip\Out\2013-03-6 in vivo\experiment_70723 PM\recSegments\segment_iteration=28_I=0.mat')

t = recSegment.t(20:end); % ignoring end effects of filter
v = recSegment.v(20:end);

% butterworth filter
order1 = 2;
order2 = 8;
W1 = 5000;
W2 = 10000;
s_R = 20000;
out = butter_filter(recSegment, order1, order2, W1, W2, s_R);

% bessel filter
% order1 = 1;
% order2 = 1;
% W1 = 2000;
% W2 = 10000;
% s_R = 20000;
% out = bessel_filter(recSegment, order1, order2, W1, W2, s_R);

%take fft
[fftOrig fOrig] = takeFFT(v, s_R);
[fftFilt fFilt] = takeFFT(out, s_R);

figure
plot(t, v, 'r-', t, out, 'k-')
xlabel('Time (s)')
ylabel('V_m (V)')
legend('Original', 'Filtered')
%plot2svg('..\..\meetings\illustrations\filtered_vs_unfiltered.svg')
figure('position', [ 360   464   560   234])
% Plot single-sided amplitude spectrum.
loglog(fOrig, fftOrig, 'r-', fFilt, fftFilt, 'k-') 
title('Amplitude Spectrum')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
xlim([10 10000])
%plot2svg('..\..\meetings\illustrations\fft.svg')
end

