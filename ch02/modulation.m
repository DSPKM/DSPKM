randn('seed',2)
x = hanning(128);
figure(3) 

s = sign(randn(1,3));
s = [s ones(1,-mean(s)*length(s))];
y = kron(s',x);
subplot(411), plot(y), axis tight
Y = fftshift(fft(y,65535));
Y(1:fix(end/2)) = 0;
subplot(423), plot(linspace(-pi,pi,65535),real(Y))
axis([-0.1,0.1,-200,200]), xlabel('\Omega (rad)')
subplot(424), plot(linspace(-pi,pi,65535),imag(Y))
axis([-0.1,0.1,-200,200]), xlabel('\Omega (rad)')
yssb = ifft(fftshift(Y));
yssb = yssb(1:length(y));

subplot(413), plot(real(yssb)), axis tight
subplot(414), plot(imag(yssb)), axis tight

figure(5)
p = cos(2*pi*4096/65536.*(0:length(y)-1));
q = sin(2*pi*4096/65536.*(0:length(y)-1));
subplot(611)
plot(linspace(-pi,pi,65536),abs(fftshift(fft(p,65536))))
z = p'.*real(yssb)+q'.*imag(yssb);
subplot(612), plot(z), axis tight

subplot(625)
plot(linspace(-pi,pi,65536),real(fftshift(fft(z,65536))))
axis([-0.8 0.8 -100 100])
subplot(626)
plot(linspace(-pi,pi,65536),imag(fftshift(fft(z,65536))))
axis([-0.8 0.8 -100 100])

z2 = z;
Z2 = fftshift(fft(z,65536));
Z2(1:end/2) = 0;
subplot(627), plot(linspace(-pi,pi,65536),real(Z2))
axis([-0.8 0.8 -100 100])
subplot(628), plot(linspace(-pi,pi,65536),imag(Z2))
axis([-0.8 0.8 -100 100])
fc = 6553;
Z3 = [2*Z2(4097:end);zeros(4096,1)];
subplot(629), plot(linspace(-pi,pi,65536),real(Z3))
axis([-0.1 0.1 -200 200])
subplot(6,2,10), plot(linspace(-pi,pi,65536),imag(Z3))
axis([-0.1 0.1 -200 200])
subplot(616), plot(real(ifft(fftshift(2*Z3))))
axis([1 length(y) -1 1])