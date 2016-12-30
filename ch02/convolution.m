h = [zeros(1,100), ones(1,150) zeros(1,100)]; % h[n]
x = [1:100]/100; % x[n]
xa = [fliplr(x),zeros(1,250)];             % x[-n]
xb = [zeros(1,50),fliplr(x),zeros(1,200)]; % x[50-n]
xc = [zeros(1,100),fliplr(x),zeros(1,150)];% x[100-n]
xd = [zeros(1,150),fliplr(x),zeros(1,100)];% x[150-n]
xe = [zeros(1,200),fliplr(x),zeros(1,50)]; % x[200-n]
xf = [zeros(1,250),fliplr(x)];             % x[250-n]
% Represent impulse response
figure(1), subplot(311), plot([-99:250],h)
% Represent x[t-n]
subplot(312), plot([-99:250],xa), hold all
plot([-99:250],xb), plot([-99:250],xc)
plot([-99:250],xd), plot([-99:250],xe)
plot([-99:250],xf)
% Convolution
y = [zeros(1,99) conv(h,x,'valid')];
% Represent convolution
subplot(313), plot([-99:250],y)
hold all, stem(0:50:250,y(100:50:end))