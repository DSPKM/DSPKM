function param1
% Load the samples, contained in variable 'data'
% with frequency fs=11025 samples/second
load guitar; y=data;

%% Variable setup
ts = 1/fs;        % sampling period
N = length(y);    % signal length
tw = 0.025;       % window length in seconds
to = 0.0125;      % window overlap in seconds
nw = floor(tw / ts)+1;   % window length in samples
no = floor(to / ts)+1;   % window overlap in samples
res1 = fs / N;    % Signal resolution
res2 = fs / nw;   % Window resolution
Nt   = floor(N/no); % Time length of the spectrogram
% in samples
Nw   = nw/2;        % Frequency length onf the spectrogram
% in samples
t = no/fs*(0:Nt-1); % time axis for the spectrum
tt = 1/fs*(0:N-1);  % time axis for the time representation
f = fs*(0:Nw-1)/2/Nw; %frequency axis

%% Signal representation
figure(1), plot(tt,y);
axis tight, xlabel('t(s)'), ylabel('mV')

%% Windows used for the representation
wwT = repmat(triang(nw),1,Nt);
wwH = repmat(hamming(nw),1,Nt);
wwB = repmat(blackman(nw),1,Nt);

%% Signal buffering and windowing
s = buffer(y,nw,no,'nodelay');
sT = s .* wwT;
sH = s .* wwH;
sB = s .* wwB;

%% Spectrogram computation
S = spectrogr(s);
ST = spectrogr(sT);
SH = spectrogr(sH);
SB = spectrogr(sB);

%% Representation
figure(2), subplot(211), imagesc(t,f,S);
xlabel('t(s)'), ylabel('dBm')
title('Spectrogram with a rectangular window')
subplot(212), imagesc(t,f,ST);
xlabel('t(s)'), ylabel('dBm')
title('Spectrogram with a triangular window')
figure(3), subplot(211), imagesc(t,f,SH);
xlabel('t(s)'), ylabel('dBm')
title('Spectrogram with a Hamming window')
subplot(212), imagesc(t,f,SB);
xlabel('t(s)'), ylabel('dBm')
title('Spectrogram with a Blackman window')

%% Auxiliary function
function S = spectrogr(s,Nw)
Nw = size(s,1) / 2;
S = 10 * log10(abs(fftshift(fft(s))));
S = S(Nw+1:2*Nw,:);
