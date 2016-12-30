figure(3)
y = kron(s',x);
subplot(411), plot(y), title('Signal'), xlabel('n'), axis tight
Y = fftshift(fft(y,65535));
Y(1:end/2) = 0;
subplot(423), plot(linspace(-pi,pi,65535),real(Y))
axis([-0.1,0.1,-200,200])
ylabel('Negative spectrum removal'), xlabel('\Omega (rad )')
subplot(424), plot(linspace(-pi,pi,65535),imag(Y))
axis([-0.1,0.1,-200,200])
xlabel('\Omega (rad)'), ylabel('Negative spectrum removal')
yssb = ifft(fftshift(Y));
yssb = yssb(1:length(y));
subplot(413), plot(real(yssb)), title('Baseband SSB, real part')
xlabel('n'), axis tight
subplot(414), plot(imag(yssb))
axis tight, title('Baseband SSB, imag. part'), xlabel('n')