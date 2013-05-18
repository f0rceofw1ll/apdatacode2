%% findAPs
% Using textscan_rec.m
% Input: expDirectory: (e.g. '\2013-3-6 in vivo')
%        startAt: iteration # to start at (in seconds)
% Commands: n: proceed to next recording w/o saving
%           s: save the recSegment, go to next one
%           stop: stop

function [] = findAPs(expDirectory, startAt)
    
    samplingRate = 20000;
    formatString = '%f32%f32%f32%*q';
    fileLoc = [expDirectory '\recording.lvm'];
    mkdir([expDirectory '\recSegments']) % make directory for recording files
    fid=fopen(fileLoc,'rt');
    
    iterNum = startAt;
    toPlot = 1;
    command = '';
    
    lineNum = samplingRate*startAt;
    
    while ~feof(fid) && ~strcmp(command, 'stop')
        
        disp(['Iteration # ' int2str(iterNum)])
        if iterNum == startAt % first iteration
            numHeaderLines = 22+lineNum; % start off at the line number of 'startAt' + 22
        else
            numHeaderLines = 0; % otherwise, keep going
        end
        recSegment = textscan_rec(fid, samplingRate, formatString, numHeaderLines, toPlot);
        
        command = input('Command: ', 's');

        if isempty(command)
            command = 'n';
        end
        
        switch command
            case 'n'
                disp('next')
            case 's'
                disp('save')
                saveRecSegment(expDirectory, recSegment, iterNum)
            case 'stop'
            otherwise
                disp('next')
        end
        
        if generateTable
            currentTableVal = [iterNum recSegment.stimVal];
        end
        close all
        iterNum = iterNum+1;
    end
    
     fclose(fid);
end

