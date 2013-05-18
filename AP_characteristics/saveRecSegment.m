%% saveRecSegment.m
% Used by analyze_large_recording.m
% Input expDirectory (e.g. '..\2013-3-6 in vivo'), recSegment (t, v, stim
% fields), iteration number (so it knows what filename to give the file)
% Saves the .mat and .fig file of the recSegment
function [] = saveRecSegment(expDirectory, recSegment, iterNum)

    
    
    fileName = [ expDirectory '\recSegments\' ...
        'segment_iteration=' int2str(iterNum) '_I=' num2str(recSegment.stimVal)];
    
    save([fileName '.mat'], 'recSegment')
    saveas(gcf, [fileName '.fig'])
end