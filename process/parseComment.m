function [ protocol, triangle, pulsetrain, exponential] = parseComment( commentString )
%parseComment Summary of this function goes here
%   Detailed explanation goes here

    whiteSpaces = strfind(commentString, ' ');
    
    protocolIndices = strfind(commentString, 'PROTOCOL:')+9 : whiteSpaces(1)-1;
    protocol = commentString(protocolIndices);
    protocol = lower(protocol);
    
    indices = strfind(commentString, 'TSLOPE:')+7:whiteSpaces(3)-1;
    triangle.tslope = str2double(commentString(indices));
    indices = strfind(commentString, 'TOFFSET:')+8:whiteSpaces(4)-1;
    triangle.toffset = str2double(commentString(indices));
    indices = strfind(commentString, 'TAMPLITUDE:')+11:whiteSpaces(5)-1;
    triangle.tamplitude = str2double(commentString(indices));
    
    indices = strfind(commentString, 'PAMPLITUDE:')+11:whiteSpaces(7)-1;
    pulsetrain.pamplitude = str2double(commentString(indices));
    indices = strfind(commentString, 'POFFSET:')+8:whiteSpaces(8)-1;
    pulsetrain.poffset = str2double(commentString(indices));
    strfind(commentString, 'PFREQUENCY:')+11:whiteSpaces(9)-1;
    pulsetrain.pfrequency = str2double(commentString(indices));
    indices = strfind(commentString, 'PNUM:')+5:whiteSpaces(10)-1;
    pulsetrain.pnum = str2double(commentString(indices));
    
    if length(whiteSpaces) == 10 % experiment where we only have triangle and pulse
        indices = strfind(commentString, 'PWIDTH:')+7:length(commentString);
    else
        indices = strfind(commentString, 'PWIDTH:')+7:whiteSpaces(11)-1;
    end
    
    pulsetrain.pwidth = str2double(commentString(indices));
    
    exponential = [];
    if length(whiteSpaces) > 10 % experiment where we have exponential too
        indices = strfind(commentString, 'EAMPLITUDE:')+11:whiteSpaces(13)-1;
        exponential.eamplitude = str2double(commentString(indices));
        indices = strfind(commentString, 'EOFFSET:')+8:length(commentString);
        exponential.eoffset = str2double(commentString(indices));
    end
end

