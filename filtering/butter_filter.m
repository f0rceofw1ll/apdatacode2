%% Butterworth filter recordings
% butter_filter.m
% Input: recording segment (consists of t (time) and v (voltage) fields
%         order1: filter order for Wc1
%         order2: filter order for Wc2
%         W1: cutoff frequency 1
%         W2: cutoff frequency 2
%         sR: sampling Rate
% Output: Filtered voltage (NOTE: 20 samples subtrated due to filter end-effects)

function out = butter_filter(recSegment, order1, order2, W1, W2, s_R)

W1 = W1/s_R; % f_c1
W2 = W2/s_R; %f_c2

%filter
%[b1,a1]=butter(order1,[W1 W2], 'low');
[b1, a1]=butter(order1,W1, 'low');
%[b2,a2]=butter(order2,W2);
out = filter(b1,a1,recSegment.v);
%out = filter(b2,a2, out);
out = out(20:end);

h1=dfilt.df2(b1,a1); 
hfvt=fvtool(h1,'FrequencyScale','log');
end

