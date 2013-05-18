%% analyze_large_recording
% Using textscan_rec.m
% Input: expDirectory: (e.g. '\2013-3-6 in vivo')
%        startAt: iteration # to start at (in seconds)
%        generateTable: Generate a recTable (recSegments/recTable.mat) or not
% recTable is Column 1: second #, Column 2: stimVal
% Commands: n: proceed to next recording w/o saving
%           s: save the recSegment, go to next one
%           stop: stop
% Format of recording file
    % row 1: time
    % row 2: voltage
    % row 3: motor sense
    % row 4: stim

function [recTable] = analyze_large_recording(expDirectory, startAt, generateTable)
    
    numSamples = 18670;
    formatString = '%f32%f32%f32%f32%*q';
    fileLoc = [expDirectory '\whisker_stim.lvm'];
    mkdir([expDirectory '\recSegments']) % make directory for recording files
    mkdir([expDirectory '\recSegments\raw'])
    
    fid=fopen(fileLoc,'rt');
    
    iterNum = startAt;
    toPlot = 1;
    command = '';
    
    lineNum = numSamples*startAt;
    recTable = [];
    
    while ~feof(fid) && ~strcmp(command, 'stop')
        disp(['Iteration # ' int2str(iterNum)])
        if iterNum == startAt % first iteration
            numHeaderLines = 23+lineNum; % start off at the line number of 'startAt' + 22
        else
            numHeaderLines = 0; % otherwise, keep going
        end
        recSegment = textscan_rec(fid, numSamples, formatString, numHeaderLines, toPlot);
        recSegment.iterNum = iterNum;
        if generateTable
            command = 'n';
%             currentTableVal = {iterNum... %1
%                 recSegment.stimVal... %2
%                 recSegment.type... %3
%                 recSegment.numPulses... %4
%                 recSegment.dutyCycle... %5
%                 recSegment.offset... %6
%                 recSegment.amplitude... %7
%                 recSegment.pulseWidth... %8
%                 recSegment.period... %9
%                 recSegment.motorStimOnset... %10
%                 recSegment.motorStimOutset}; %11

%             recTable = [recTable; currentTableVal];
              save([expDirectory '\recSegments\raw\recSegment_' int2str(recSegment.iterNum) '.mat'], 'recSegment')
              recSegment = rmfield(recSegment, {'t', 'v'});
              recTable = [recTable recSegment];
              
        else
            while true
                command = input('Command: ', 's');
                switch command
                case 'n'
                    disp('next'); break;
                case 's'
                    disp('save')
                    saveRecSegment(expDirectory, recSegment, iterNum); break;
                case 'stop'
                    break;
                case 'avg'
                    avgV = calcAvg(recSegment);
                    disp(['Average V = ' num2str(avgV) ' mV']);
                case 'count'
%                     thresh = 
%                     [peakLoc, peakMag] = peakfinder(x0, sel, thresh, extrema);
                    
                otherwise
                    disp('next'); break
                end
                
            end
        end
        if isempty(command)
            command = 'n';
        end
        
        
        close all
        iterNum = iterNum+1;
    end
    
    if generateTable
        save([expDirectory '\recSegments\recTable.mat'], 'recTable')
    end
     fclose(fid);
     disp('DONE')
end

