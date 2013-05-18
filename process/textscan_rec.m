%% textscan_rec
% Use for large recording files.
% Inputs: fid: id of file (defined in analyze_large_recording.m
%         numSamples: number of recorded samples
%         formatString: how should the file be read
%         numHeaderLines: how many lines should be skipped
%         toPlot: should we plot every recSegment?
% Outputs:
% recSegment: t [1xN]: time vector
%             v [1xN]: voltage vector
%             stim [1]: stimulation level (pA)

function [recSegment] = textscan_rec(fid, numSamples, formatString, numHeaderLines, toPlot)

    numPulses = 0;
    dutyCycle = 0;
    offset = 0;
    amplitude = 0;
    pulseWidth = 0;
    period = 0;
    motorStimOnset = 0;
    motorStimOutset = 0;

    data =textscan(fid,formatString,numSamples,'headerlines',numHeaderLines,'delimiter','\t','CollectOutput',1);

    data=data{1};
    t = data(:,1);
    v = data(:,2);
    sense = data(:,3);
    stim = data(:,4);

    recSegment.t = t;
    recSegment.v = v;
    
    stimVal = mean(stim);
    recSegment.stimVal = stimVal;
    
    uniqueVals = unique(sense);
    switch length(uniqueVals)
        case 1
            type = 'none';
        case {2,3}
            type = 'pulse';
            senseDeriv = diff(sense);
            risingEdges = find( senseDeriv>0 )-1;
            fallingEdges = find( senseDeriv<0 );
            if length(uniqueVals) == 3
               risingEdges = risingEdges(2:end);
               uniqueVals = uniqueVals(2:end);
            end
            
            numPulses = length(risingEdges);
            
            pulseWidth = mean(fallingEdges - risingEdges(1:length(fallingEdges)));
            period = mean(diff(risingEdges));
            
            dutyCycle = pulseWidth/period;
            
            offset = min(uniqueVals);
            amplitude = max(uniqueVals)-offset;
            
            motorStimOnset = risingEdges(1);
            motorStimOutset = fallingEdges(end);
            
        otherwise
            type = 'sinusoid';
            motorStimOnset = find(sense > 0, 1);
            theSinusoid = sense(motorStimOnset : end);
            amplitude = max(theSinusoid) - min(theSinusoid); % peak to peak
            
            period = round(mean(diff(find(diff(diff(theSinusoid)>0)>0))));
            offset = min(theSinusoid) + amplitude/2;
    end
    
    decimalPlaces = 2;
    amplitude = round((10^decimalPlaces)*amplitude)/(10^decimalPlaces);
    pulseWidth = round(pulseWidth);
    period = round(period);
    offset = round((10^decimalPlaces)*offset)/(10^decimalPlaces);
    
    % type = {'pulse sinusoid none}
    recSegment.type = type;
    recSegment.numPulses = numPulses;
    recSegment.dutyCycle = dutyCycle;
    recSegment.offset = offset;
    recSegment.amplitude = amplitude;
    recSegment.pulseWidth = pulseWidth;
    recSegment.period = period;
    recSegment.motorStimOnset = motorStimOnset;
    recSegment.motorStimOutset = motorStimOutset;
    
    
    if toPlot
        figure
        subplot(2,1,1)
        plot(t,v) % in mV
        title(['I_{inj} = ' num2str(stimVal) 'pA'])
        
        ylabel('V_m (mV)')
        subplot(2,1,2)
        plot(t,sense)
        xlabel('Time (s)')
    end
    

end