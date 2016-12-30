T = 32; % Window length
x2 = buffer(x,T,T-1,'nodelay'); % Windowed signal vectors
X = abs(fft(x2,256)).^2; % FFT
X = mean(X,2);  % Expectation
figure(1), plot(linspace(0,1,128),10*log10(X(1:end/2)))
