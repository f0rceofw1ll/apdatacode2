%% vclamp_obj class
% Ilya Kolb

classdef vclamp_obj < handle

    properties (SetAccess = public)
        
        view_location
        rec_location
        RMP
        
        % different properties
        Ra % access R
        Rm % membrane R
        Cm % membrane capacitance
        Rin % Input R
        Ih % Holding current
        

    end
    
    methods
        % constructor
        function v = vclamp_obj(folderLocation)
            v.view_location = [folderLocation '/view_profile.lvm'];
            v.rec_location = [folderLocation '/rec_profile.lvm'];
        end
        
        % find RMP
        function setRMP(wr)
            wr.RMP = getVholding(wr.file_location);
        end
    end
end
