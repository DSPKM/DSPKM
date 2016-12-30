load filtradoegm
fs = 1e3; ts = 1/fs;
N = length(x1);
t = ts*(0:N-1);
figure(1), plot(t,x1); axis tight,
xlabel('t (s)'), ylabel('mV');
X1 = abs(fftshift(fft(x1)));
f=linspace(-fs/2,fs/2,length(X1));
figure(2), plot(f,X1), axis tight,
xlabel('f (Hz)'), ylabel('X(f)');
% Filter at 300 Hz
h1 = fir1(64+1,2*300/fs);
[H1,f1] = freqz(h1,1,1024,fs);
y1 = filtfilt(h1,1,x1);
figure(3), plot(t,y1);axis tight,
xlabel('t (s)'), ylabel('mV');
figure(4), plot(f1,abs(H1))
axis tight, xlabel('f(Hz)');
Y1 = abs(fftshift(fft(y1)));
figure(5), plot(f,Y1), axis tight,
xlabel('f (Hz)'), ylabel('X(f)');
title('fc = 300 Hz')