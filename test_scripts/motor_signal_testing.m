%% motor signal testing

data = lvm_import('C:\autopatcher_code\experiment_65146 PM_PC\whisker_stim.lvm');
data = data.Segment1.data;
t = 0 : 1/20000 : length(data)/20000;
t = t(1:end-1);
v = data(:,1);
v = v-mean(v);
sense = data(:,2);
plot(v); hold on; plot(sense, 'r')  