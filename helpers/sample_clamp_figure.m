function [ f ] = sample_clamp_figure( singleTrial, whichClamp )
%sample_clamp_figure Plot a sample current clamp or voltage clamp trace
%   Input: trial object
    
%% CONSTANTS
grayColor = [.5 .5 .5];
samplingRate = 20000;


switch whichClamp
    case 'i' % curent clamp
%% plot CURRENT clamp figure
        try
            clampNames = singleTrial.iclamp_rec_names;
        catch
            error('sample_clamp_figure : current clamp: No corresponding iclamp found!')
        end

        
        for i = 1:length(clampNames)
           currentClampName = clampNames{i};
           clamp_recs = lvm_import([currentClampName '/Recordings.lvm']);
           clamp_recs = clamp_recs.Segment1.data;
           view_recs = lvm_import([currentClampName '/View_profile.lvm']);
           view_recs = view_recs.Segment1.data;
           
           lengthRecording = length(view_recs);
           
           tVec = 0:1/20000:lengthRecording/20000;
           tVec = tVec*1000; % time vector in ms
           tVec = tVec(1:end-1);
           
           list_of_clamps = get_clamp_list(view_recs);
           
           meanRec = []; % mean recording
           % cycle through each recording in the protocol
           f = figure('Name', [currentClampName ': Current clamp #' int2str(i)])
           
           for j = 1:length(list_of_clamps)
               thisRec = clamp_recs(:,j);
               thisView = view_recs(:,j);
               subplot(2,1,1)
               title('Command current (pA)', 'fontsize' ,12)
               hold on,plot(tVec, thisView, 'k-', 'linewidth', 2)
               
               subplot(2,1,2)
               title('Neural recording', 'fontsize' ,12)
               xlabel('Time (ms)', 'fontsize', 12)
               ylabel('Membrane voltage (mV)', 'fontsize' ,12)
               plot(tVec, thisRec, 'color', grayColor)
               hold on
               meanRec = [meanRec thisRec];
               % if this is the last element or if the next clamp currnet
               % is not the same as this one
               if j == length(list_of_clamps) || list_of_clamps(j+1) ~= list_of_clamps(j)
                   plot(tVec, mean(meanRec,2), 'k-', 'linewidth' ,2) % plot the mean of the recordings
                   meanRec = []; % reset the meanRec array
               end
           end
           

        end
        
    case 'v' % voltage clamp
%% plot VOLTAGE clamp figure

        try
            clampNames = singleTrial.vclamp_rec_names;
        catch
            error('sample_clamp_figure : current clamp: No corresponding iclamp found!')
        end

        
        for i = 1:length(clampNames)
           currentClampName = clampNames{i};
           clamp_recs = lvm_import([currentClampName '\Recordings.lvm']);
           clamp_recs = clamp_recs.Segment1.data;
           view_recs = lvm_import([currentClampName '\View_profile.lvm']);
           view_recs = view_recs.Segment1.data;
           
           lengthRecording = length(view_recs);
           
           tVec = 0:1/20000:lengthRecording/20000;
           tVec = tVec*1000; % time vector in ms
           tVec = tVec(1:end-1);
           
           list_of_clamps = get_clamp_list(view_recs);
           
           meanRec = []; % mean recording
           % cycle through each recording in the protocol
           g = figure('Name', [currentClampName ': Voltage clamp #' int2str(i)])
           
           for j = 1:length(list_of_clamps)
               thisRec = clamp_recs(:,j);
               thisView = view_recs(:,j);
               subplot(2,1,1)
               title('Command voltage (mV)', 'fontsize' ,12)
               hold on,plot(tVec, thisView, 'k-', 'linewidth', 2)
               
               subplot(2,1,2)
               title('Neural recording', 'fontsize' ,12)
               xlabel('Time (ms)', 'fontsize', 12)
               ylabel('Membrane current (pA)', 'fontsize' ,12)
               plot(tVec, thisRec, 'color', grayColor)
               hold on
               meanRec = [meanRec thisRec];
               % if this is the last element or if the next clamp currnet
               % is not the same as this one
               if j == length(list_of_clamps) || list_of_clamps(j+1) ~= list_of_clamps(j)
                   plot(tVec, mean(meanRec,2), 'k-', 'linewidth' ,2) % plot the mean of the recordings
                   meanRec = []; % reset the meanRec array
               end
           end
           

        end
    otherwise
        perror('Clamp options are either i or v!');
end


end

