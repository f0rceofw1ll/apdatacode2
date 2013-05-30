%% autopatch_trial class
% Ilya Kolb

classdef autopatch_trial < handle

    properties (SetAccess = public)
        initDepth
        pipette_resistances
        hunting_resistances
        gigaseal_resistances
        date % experiment date (e.g. 2013/05/18)
        outcome
        breakin_current
        voltage_offset
        whisker_stim_folder
        
        % membrane test file locations (all)
        memtest_rec_files
        
        % arrays of voltage/current clamp recording names
        vclamp_rec_names
        iclamp_rec_names
        
        % recording object
        whisker_recording
        
%         % references to recording files
        currentTraceFile
        recFile
        
    end
    
    properties (SetAccess = private)
        outcomeID
        finalDepth
        
        maxR % max gigaselaing resistance (MOhms)
        Ra % Access resistance    (Ohms)
        Rm % Membrane resistance  (Ohms)
        Cm % Membrane capacitance (F)
        Ih % Holding current      (A)
        RMP % resting membrane potential (V) <<?>>
        Rin % input resistance ( Ohms )
        holding_time % cell holding time in seconds - measured by measuring length of whisker stim
        
    end
    
    methods
        % constructor
        function at = autopatch_trial()
        end
        
        function oID = get.outcomeID(at)
            oID = getOucomeID(at.outcome);
        end
        
        % plot resistance tests
        function f = plotResistances(at)

            f = figure('Name', 'Resistance measurements');
            subplot(2,3,1:3)
            % plot clog test
           
%             if isstruct(at.pipette_resistances)
%                figure
%                 ct = at.pipette_resistances.Segment1.data;
%                 title('Pipette resistances')
%                 plot(ct,  'o-', 'linewidth' ,2)
%             end

            if isstruct(at.hunting_resistances)
                nh = at.hunting_resistances.Segment1.data;
                t_nh = 1:length(nh); % neuron hunting every second
                plot(t_nh, nh,  'ko-', 'linewidth', 2)
                ylabel('Pipette resistance (M/Omega)', 'fontsize', 12)
                xlabel('Time (s)', 'fontsize', 12)
            end
            if isstruct(at.gigaseal_resistances)
                gr = at.gigaseal_resistances.Segment1.data;
                t_gr = t_nh(end) + [.5:.5:length(gr)/2];
                hold on; plot(t_gr, gr(:,1), 'ko-', 'linewidth' ,2)
            end
        end
        
        % plot current traces
        function plotCurrentTrace(at)
            try
            ct = lvm_import(at.currentTraceFile);
            data = ct.Segment1.data;
            t = data(:,1); % time
            i = data(:,2)/1000; % current in nA
            %data(:,1) is the time
            %data(:,2) is the current (pA)
            catch
                t = [];
                i = [];
                disp('No current traces found... moving on')
                
            end

            subplot(2,3,4)
            plot(t, i, 'k-')
            xlabel('Time (s)', 'fontsize' ,12)
            ylabel('Current (nA)', 'fontsize', 12)
            subplot(2,3,5)
            plot(t, i, 'k-')
            xlabel('Time (s)', 'fontsize', 12)
            subplot(2,3,6)
            plot(t, i, 'k-')
            xlabel('Time (s)', 'fontsize' ,12)
        end
        
        % get maximum gigasealing resistane in MOhms
        function maxR = get.maxR(at)
            if isstruct(at.gigaseal_resistances)
                maxR = max(at.gigaseal_resistances.Segment1.data(:,1));
            else
                disp('get.maxR: No gigasealing trace found! Setting maxR to []')
                maxR = [];
            end
        end
        
        % get final depth using neuron hunting array depth
        function finalDepth = get.finalDepth(at)
            if isstruct(at.hunting_resistances)
                finalDepth = at.initDepth + length(at.hunting_resistances.Segment1.data(:,1));
            else
                disp('get.finalDepth: No final depth found!')
                finalDepth = [];
            end
        end
        
        % plot Breaking current
        function plotBreakin(at)
            samplingRate = 20000; % change if sampling rate is different
            bc = at.breakin_current.Segment2.data;
            tVec = linspace(0, length(bc)/samplingRate*1000, length(bc));
            
            figure
            plot(tVec, bc);
            title('Breakin current')
            ylabel('Current (pA)')
            xlabel('Time (ms)')
        end
        
        % plot membrane test
        % memtest_num: which memtest to plot (1 if the first one and so
        % on)
        function [meanRecs meanVs] = plotMemtest(at, memtest_num)
            rec = lvm_import(at.memtest_rec_files{memtest_num});
            i = 1;
            figure
            allRecs = [];
            meanVs = [];
            while isfield(rec, ['Segment' int2str(i)])

                eval(['currentData = rec.Segment' int2str(i) '.data;']); % get data from current segment
                subplot(2,1,1)
                if i == 1
                    meanVs = currentData(:,1); % voltage profile
                end
                hold on, plot(currentData(:,1)) % plot command voltage
                subplot(2,1,2)
                hold on, plot(currentData(:,2)) % plot recording
                
                allRecs = [allRecs currentData(:,2)];
                i = i+1;
            end
            meanRecs = mean(allRecs, 2);
            subplot(2,1,1)
            plot(meanVs, 'r-', 'linewidth' ,2)
            title('Command voltage')
            subplot(2,1,2)
            plot(meanRecs, 'r-', 'linewidth', 2)
            title('Recording')
            
            if isempty(allRecs)
                error('allRecs variable not assigned in plotMemtest')
            end
            if isempty(meanVs)
                error('allVs variable not assigned in plotMemtest')
            end
            
        end
        
        % memtest_setRaRmCm
        % Uses the membrane test to set the Ra, Rm and Cm fields
        function at = memtest_setRaRmCmIh(at)
            if ~isempty(at.memtest_rec_files) % if there is at least one membrane test
                Rms = []; Ras = []; Cms = []; Ihs = []; Rins = [];
                for i = 1:length(at.memtest_rec_files)
                    [meanRecs, meanVs] = plotMemtest(at, i);
                    initialV = meanVs(1);

                    stim_onset_index = find(meanVs ~=initialV, 1); % index of stimulation onset
                    stepV = meanVs(stim_onset_index);
                    stim_offset_index = stim_onset_index + find(meanVs(stim_onset_index:end) ~= stepV, 1)-1; % index of stimulation turning off

                    deltaV = stepV-initialV;

                    [Rms(end+1), Ras(end+1), Cms(end+1), Ihs(end+1), Rins(end+1)] = ...
                        cellstats_memtest(meanRecs, stim_onset_index, stim_offset_index, deltaV);
                    disp(['MEMTEST # ' int2str(i) ' DONE'])
                    pause
                end
                if length(Rms) == 1 % only one option
                    theRm = Rms; theRa = Ras; theCm = Cms; theIh = Ihs; theRin = Rins;
                else % let user choose which membrane test
                    in = input(['Which cell stats? 1-' num2str(length(Rms)) ': ']);
                    theRm = Rms(in); theRa = Ras(in); theCm = Cms(in);
                    theIh = Ihs(in); theRin = Rins(in);
                end
            else % if there is no memtest, set everything to NaN
                theRm = NaN;
                theRa = NaN;
                theCm = NaN;
                theIh = NaN;
                theRin = NaN;
            end
            at.Rm = theRm;
            at.Ra = theRa;
            at.Cm = theCm;
            at.Ih = theIh;
            at.Rin = theRin;
        end
        
        % function to plot voltage/current clamp protocols
        function plotClamps(at, whichClamp)
            
            try
                clampNames = at.([whichClamp 'clamp_rec_names']);
            catch
                error('autopatch_trial::plotClamps: No corresponding clamp found!')
            end
            
            for i = 1:length(clampNames)
               currentClampName = clampNames{i};
               clamp_recs = lvm_import([currentClampName '/Recordings.lvm']);
               clamp_recs = clamp_recs.Segment1.data;
               view_recs = lvm_import([currentClampName '/View_profile.lvm']);
               view_recs = view_recs.Segment1.data;
               
               figure('name', ['Clamp # ' int2str(i)])
               subplot(2,1,1)
               plot(view_recs, 'k-')
               
               subplot(2,1,2)
               plot(clamp_recs, 'k-')
               
            end
        end
        
        % function to get the resting membrane potential (RMP) from Current
        % clamp recordings
        % at: trial object
        % numSamples: number of samples we will be averaging over
        function setRMP(at, numSamples)
            L = length(at.iclamp_rec_names);
            switch L
                case 0
                    disp('setRMP: No ICLAMP found! Setting RMP = NaN')
                    at.RMP = NaN;
                case 1
                    plotClamps(at, 'i')
                   clampName = at.iclamp_rec_names{1};
                   clamp_recs = lvm_import([clampName '/Recordings.lvm']);
                   clamp_recs = clamp_recs.Segment1.data;
                   at.RMP = mean(mean(clamp_recs(1:numSamples,:)));
                otherwise
                    plotClamps(at, 'i')
                   in = input(['There are ' int2str(L) ' IClamp recordings. Which one do you want to use <index>? : ']);
                   clampName = at.iclamp_rec_names{in}
                   clamp_recs = lvm_import([clampName '/Recordings.lvm']);
                   clamp_recs = clamp_recs.Segment1.data;
                   at.RMP = mean(mean(clamp_recs(1:numSamples,:)));
            end
        end
        
        % function to measure holding time
        function setHoldingTime(at, folderName)
            
            % if a whisker recording exists
            if ~isempty(at.whisker_recording) % lengh of recording = holding time
                [recTable] = analyze_large_recording(folderName, 0, 1);
                at.holding_time = length(recTable);
            elseif ~isempty(at.whisker_stim_folder) % number of files in folder = holding time
                at.holding_time = length([dir(at.whisker_stim_folder)]);
            else
                disp('setHoldingTime: no whisker recording found!')
                at.holding_time = NaN;
                pause;
            end
        end
    end
end
