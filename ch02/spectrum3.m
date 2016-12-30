x2 = buffer(x,T,T-1,'nodelay'); % Windowed signal vectors
R = x2 * x2' / size(x2,2);
X = 1./sum(abs(fft(pinv(R),256)),2);
plot(linspace(0,1,128),10*log10(X(1:end/2)))
