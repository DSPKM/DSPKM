figure(2)
p = cos(2*pi/16.*(0:length(y)-1)); % Carrier
z = p'.*y;
subplot(511), plot(z)
axis tight, xlabel('n'), title('DSB modulation')
subplot(523)
plot(linspace(-pi,pi,65536),real(fftshift(fft(z,65536))))
axis([-0.8 0.8 -100 100]), xlabel('\Omega (rad)'), title('DFT, real part')
subplot(524)
plot(linspace(-pi,pi,65536),imag(fftshift(fft(z,65536))))
axis([-0.8 0.8 -100 100]), xlabel('\Omega (rad)'), title('DFT, imag. part')
z2 = z;
Z2 = fftshift(fft(z,65536));
Z2(1:end/2) = 0;
subplot(525), plot(linspace(-pi,pi,65536),real(Z2))
axis([-0.8 0.8 -100 100])
xlabel('\Omega (rad)'), ylabel('Negative part removal')
subplot(526), plot(linspace(-pi,pi,65536),imag(Z2))
axis([-0.8 0.8 -100 100])
xlabel('\Omega (rad)'), ylabel('Negative part removal')
fc = 6553;
Z3 = [2*Z2(4097:end) ; zeros(4096,1)];
subplot(527), plot(linspace(-pi,pi,65536),real(Z3))
axis([-0.1 0.1 -200 200])
xlabel('\Omega (rad)'), ylabel('Frequency shift')
subplot(5,2,8), plot(linspace(-pi,pi,65536),imag(Z3))
axis([-0.1 0.1 -200 200])
xlabel('\Omega (rad)'), ylabel('Frequency shift')
subplot(515), plot(real(ifft(fftshift(Z3))))
axis([1 length(y) -1 1]), title('Recovered signal'), xlabel('n')