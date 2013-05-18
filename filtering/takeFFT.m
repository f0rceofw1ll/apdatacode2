%% takeFFT.m
% take fft of recording
% Inputs: out: voltage waveform
%          Fs: sampling rate
% Outputs: fftOut: FFT waveform
%               f: vector of frequencies

function [fftOut f] = takeFFT(out, Fs)

    L = length(out);                     % Length of signal

    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    fftOut = fft(out,NFFT)/L;
    fftOut = 2*abs(fftOut(1:NFFT/2+1));
    f = Fs/2*linspace(0,1,NFFT/2+1);

end