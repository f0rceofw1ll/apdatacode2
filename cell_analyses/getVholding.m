%% getVholding.m
% Used by create_mats
% Input: fileLoc: location of recording or whisker stim file
% Output: RMP calculated by averaging 1st (or w/everth) second of the
% recording

function rmp = getVholding(fileLoc)

    samplingRate = 20000;
    formatString = '%f32%f32%f32%f32%*q';
    fid=fopen(fileLoc,'rt');
    numHeaderLines = 23; % get first line
    toPlot = 0;
    
    recSegment = textscan_rec(fid, samplingRate, formatString, numHeaderLines, toPlot);
    rmp = calcAvg(recSegment);
    
%     if rmp >= 1.4 && rmp < 1.6 % probably in volts
%         answer = input('Convert to mV? [y]/n: ', 's');
%         switch answer
%             case 'y'
%                 rmp = (1.5-rmp) * 1000; % subtract offset and x 1000
%         end
%     end
%     
    fclose(fid);
end