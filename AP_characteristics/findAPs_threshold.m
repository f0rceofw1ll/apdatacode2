%% findAPs_threshold
% Using textscan_rec.m
% Input: expDirectory: (e.g. '\2013-3-6 in vivo')
%        startAt: iteration # to start at (in seconds)
% Commands: n: proceed to next recording w/o saving
%           s: save the recSegment, go to next one
%           stop: stop

function [apMatrix] = findAPs_threshold(expDirectory, startAt)
    
    samplingRate = 20000;
    formatString = '%f32%f32%f32%*q';
    fileLoc = [expDirectory '\recording.lvm'];
    mkdir([expDirectory '\recSegments']) % make directory for recording files
    fid=fopen(fileLoc,'rt');
    
    iterNum = startAt;
    toPlot = 1;
    command = '';
    
    lineNum = samplingRate*startAt;
    
    % for saving the Ap matrix
    saveBefore = 100;
    saveAfter = 400;
    apMatrix = [];
    
    while ~feof(fid) && ~strcmp(command, 'stop')
        
        disp(['Iteration # ' int2str(iterNum)])
        if iterNum == startAt % first iteration
            numHeaderLines = 22+lineNum; % start off at the line number of 'startAt' + 22
        else
            numHeaderLines = 0; % otherwise, keep going
        end
        recSegment = textscan_rec(fid, samplingRate, formatString, numHeaderLines, toPlot);
        
        command = input('Threshold [mV] / n(ext) / stop= : ');
        switch command
            case 'n'
                disp('next')
            case 'stop'
            otherwise
                disp('threshold detect')
                v_filtered = butter_filter(recSegment);
                [foundAPs] = threshold_detector(v_filtered*1000, command); % in mV
                for i = 1:length(foundAPs)
                    if i == 22
                        disp('hi')
                    end
                    currentIndex = foundAPs(i);
                    saveBefore_adj = saveBefore;
                    saveAfter_adj = saveAfter;
                    
                    if currentIndex - saveBefore < 0
                        saveBefore_adj = currentIndex+1;
                    end
                    if currentIndex + saveAfter > length(v_filtered)
                        saveAfter_adj = length(v_filtered)-currentIndex;
                    end
                    
                    currentAP = v_filtered(currentIndex-saveBefore_adj:currentIndex+saveAfter_adj);
                    currentAP = padarray(currentAP, saveBefore+saveAfter+1-length(currentAP), 'post');
                    apMatrix = [apMatrix currentAP];
                end
        end



        close all
        iterNum = iterNum+1;
    end
    
     fclose(fid);
     
     lengthAp = [0:saveBefore+saveAfter]/20000;
     % plot AP matrix
     plot(lengthAp, apMatrix)
     plot2svg('..\..\meetings\illustrations\APslinedUp.svg')

end

