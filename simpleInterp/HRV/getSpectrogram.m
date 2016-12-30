function [axisF, axisT, EG] = getSpectrogram(X, Y, conf)

% Getting spectrogram
EG = zeros(length(Y),conf.Lfft/2);
for n = 1:length(Y)
    y = detrend(Y{n});    
    aux = abs(fft(y,conf.Lfft));
    aux = aux(1:length(aux)/2);
    EG(n,:) = aux; 
end
EG = EG ./ max(max(EG));
% Getting frequency and time axis
f = X;
if iscell(X),
    T = 0; lX = length(X);
    for n = 1:lX
        T = T + mean(diff(X{n}))/lX;
    end
    f = linspace(0, (1000/T)/2, conf.Lfft/2);
end
t = 1:length(Y);
[axisF, axisT] = meshgrid(f, t);
