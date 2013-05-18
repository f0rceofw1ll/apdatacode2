%% Scripts for PatchChip LabVIEW software
% Ilya Kolb

close all
samplingRate = 10000; % Hz
recordingOutput = lvm_import('../Out\2013-02-25 (saline)\saline_2-25-13_recording_stim/recording.lvm');
recordingOutput = recordingOutput.Segment1;
data = recordingOutput.data;

labels = recordingOutput.column_labels;
% plotting
t = data(:,1);
v = data(:,2);
s = data(:,3);
figure
subplot(2,1,1)
plot(t, v)
subplot(2,1,2)
plot(t,s)
legend(labels(2:end))
xlabel('Time (s)')