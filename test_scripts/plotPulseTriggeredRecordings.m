%% plot stimulus-triggered recordings

function [numAccepted] = plotPulseTriggeredRecordings(expDirectory, Vthreshold)

    load([expDirectory 'recSegments\recTable.mat'])
    numSamplesperSecond = 18670;
    formatString = '%f32%f32%f32%f32%*q';
    fileLoc = [expDirectory '\whisker_stim.lvm'];
    
    rawLoc = [expDirectory '\recSegments\raw\'];
    
    indicesBefore = 5000;
    indicesAfter = 1000;

    window = 1000; % samples
    allAmplitudes = queryCellArray(recTable, 'numPulses', 1);
    allAmplitudes = unique([allAmplitudes.amplitude]);

    allAPindices = [];
    allResponses = [];
    allMotorOnset = [];
    
    for j = 1:length(allAmplitudes)
        amplitude = allAmplitudes(j);
        acceptedStructures = queryCellArray(recTable, 'numPulses', 1, 'amplitude', amplitude);

    %     acceptedStructures = recTable([recTable.numPulses] == 1);
        %acceptedStructures = acceptedStructures(1:100);
        acceptedSecondNumbers = [acceptedStructures.iterNum];

        onsetIndices = [acceptedStructures.motorStimOnset];
        %figure
        numAccepted = length(acceptedSecondNumbers);
        
        responded = [];
        allAPindices = [];
        allMotorOnset = [];
        
        for i = 1:length(acceptedSecondNumbers)
            secondNumber = acceptedSecondNumbers(i);
            onsetIndex = onsetIndices(i);
    %         [t v sense stim] = getSegmentfromRec(fileLoc, formatString, numSamplesperSecond, secondNumber,...
    %             onsetIndex, indicesBefore, indicesAfter);
            load([rawLoc 'recSegment_' int2str(secondNumber)])

            response = 0;
            try
            stimTriggeredV = recSegment.v(onsetIndex-indicesBefore:onsetIndex+indicesAfter);
            [APindices APmagnitudes] = threshold_detector(stimTriggeredV, Vthreshold);
            
            allAPindices = [allAPindices APindices];
            allMotorOnset = [allMotorOnset recSegment.motorStimOnset];
            
            
            response = sum(APindices > indicesBefore & APindices < indicesBefore+window) > 0;
            %             if indicesAfter == -1
    %                 plot(recSegment.v(onsetIndex-indicesBefore:end));
    %             else
%                  hold on; plot(stimTriggeredV);
%                  plot(APindices, APmagnitudes, 'ro')

    %             end
            catch
                disp('error occured');
            end

            
            responded = [responded response];

        end
        
        psth(allMotorOnset, allAPindices', 20000, indicesBefore, indicesAfter, window, 500)
        allResponses = [allResponses sum(responded)/length(acceptedSecondNumbers)];
    end
    
    figure
    plot(allAmplitudes, allResponses, 'linewidth', 2)
end