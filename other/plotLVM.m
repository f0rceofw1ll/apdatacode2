function [] = plotLVM(location)

m = lvm_import(location);
data = m.Segment1.data(:,1);
figure, plot(data, 'ko', 'linewidth', 2)
ylabel('Pipette resistance (MOhms)')
xlabel('Time (s)')
ylim([0 20])
end