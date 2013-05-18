% 5/4/13 get segment within range from recording

function [t v sense stim] = getSegmentfromRec(fileLoc, formatString, numSamplesperSecond, secondNumber,...
    onsetIndex, indicesBefore, indicesAfter)

    fid=fopen(fileLoc,'rt');
    numHeaderLines = 23 + numSamplesperSecond*(secondNumber-1) + onsetIndex - indicesBefore;
    samplesToRead = indicesBefore + indicesAfter;
    data =textscan(fid,formatString, samplesToRead ,'headerlines',numHeaderLines,...
        'delimiter','\t','CollectOutput',1);
    
    if isempty(data{1})
        error('Data in getSegmentfromRec is empty')
    end
    data=data{1};
    t = data(:,1);
    v = data(:, 2);
    sense = data(:,3);
    stim = data(:, 4);
    
    fclose(fid);
end