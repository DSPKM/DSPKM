randn('seed',2)
x = hanning(128);
figure(1), subplot(411), plot(x)
axis([1 128,-0.1,1.1]), xlabel('n'), title('Hamming pulse')
subplot(412)
plot(linspace(-pi,pi,1024), real(fftshift(fft(x,1024))))
axis([-0.1,0.1,-40,75]), xlabel('\Omega (rad)'), title('Hamming pulse DFT')
s = sign(randn(1,3));
y = kron(s',x);
subplot(413), plot(y), xlabel('n'), title('Signal'), axis tight
subplot(427),
plot(linspace(-pi,pi,65535), real(fftshift(fft(y,65535))))
axis([-0.1,0.1,-200,200]), xlabel('\Omega (rad)'), title('DFT, real part')
subplot(428)
plot(linspace(-pi,pi,65535), imag(fftshift(fft(y,65535))))
axis([-0.1,0.1,-200,200]), xlabel('\Omega (rad)')