function [ tau, scaledExpWvfrm, plotExpWvfrm, scaledFitWvfrm] = fitExp2( expWvfrm, meanflatSegment, stdflatSegment, samplingRate )
% fitExp.m Calculates tau of given exponential
%   Inputs: expWvfrm: Waveform of JUST the exponential curve
%           meanflatSegment: mean value of flat segment
%           stdflatSegment: std value of flat segment (this and above used
%           to determine baseline)
%           samplingRate: sampling Rate (Hz)
%   Outputs: tau: time constant of given exponential (s)
%            scaledExpWvfrm: expWvfrm reduced down to the necessary range.
%            plotExpWvfrm: will be plotted over the main waveofrm

%            Used in cellstats_memtest_testbed.m

    % conditioning
    expWvfrm = expWvfrm(find(expWvfrm == max(expWvfrm), 1):end); % first element is the peak of the exponential
    expWvfrm = expWvfrm(1:find(expWvfrm < meanflatSegment + 2*stdflatSegment, 1)); % last element is when the waveform reaches plateau
    plotExpWvfrm = expWvfrm; % this is the little chunk that will be plotted on top of the main waveform
    expWvfrm = expWvfrm-min(expWvfrm); % remove DC
    
    exp_t = 0:1/samplingRate:length(expWvfrm)/samplingRate; % in seconds
    exp_t = exp_t(1:end-1); % remove last element to make everything work
    
    figure('Name', 'Exponential fit');
    plot(exp_t, expWvfrm*1e12, 'ko', 'linewidth' ,2)
    
    % fitting
    try
        [myFit, gof] = fit(exp_t', expWvfrm, 'exp2');
        tau1 = abs(1/myFit.b); % tau = 1/b in y(t) = Ae^(bt), in seconds
        tau2 = abs(1/myFit.d); 
        tau = max([tau1 tau2]); % pick slowest time constant
        scaledFitWvfrm = myFit.a*exp(myFit.b*exp_t) + myFit.c*exp(myFit.d*exp_t);
        hold on, plot(exp_t, scaledFitWvfrm*1e12, 'r', 'linewidth', 2)
        xlabel ('Time', 'fontsize', 12)
        ylabel('Current (pA)', 'fontsize' ,12)
        legend({'Data', 'Exponential Fit'})
        title(['Adjusted R^2 = ' num2str(gof.adjrsquare)])

    catch ME
        disp('Fitting failed!')
        pause
        tau = 0;
        
    end

    disp('-------- STATISTICS ------------')
    disp(['tau = ' num2str(tau) ' s'])
    scaledExpWvfrm = expWvfrm;
    
end

