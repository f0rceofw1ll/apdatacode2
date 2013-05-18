%% whisker_recording_obj class
% Ilya Kolb

classdef whisker_recording_obj < handle

    properties (SetAccess = public)
        
        file_location
        RMP
        

    end
    
    methods
        % constructor
        function wr = whisker_recording_obj(rF)
            wr.file_location = rF; % location of recording file
        end
        
        % find RMP
        function setRMP(wr)
            wr.RMP = getVholding(wr.file_location);
        end
    end
end
