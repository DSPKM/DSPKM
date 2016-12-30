N = 5;
X = sin((N+0.5)*Omega)./sin(Omega/2); % Theoretical sinc
X(end/2) = 2*(N+0.5); % Remove the indetermination at the origin
subplot(211), plot(Omega,X)
% Signal in time domain
x2 = [ones(1,N+1) zeros(1,256-2*N-1), ones(1,N)];
% Its transform
X2 = fftshift(fft(x2));
subplot(212), plot(Omega,X2)