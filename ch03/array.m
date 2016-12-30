function array
% Transmitted signal
N = 100;
K = 5;
d = 0.51;
lambda = 1;
theta1 = 30*pi/180;  % Desired signal angle
theta2 = 60*pi/180;  % Interference 1
theta3 = -60*pi/180; % Interference 2
% Visible angle
Theta = asin(-linspace(-pi,pi,1024)'*lambda/2/pi/d)*180/pi;
sigma = 0.00; % Noise variance
% Signal and interferences
[X1,b] = signal(N,K,lambda,d,theta1);
X2 = signal(N,K,lambda,d,theta2);
X3 = signal(N,K,lambda,d,theta3);
X = X1 + X2 + X3;
X = X + sigma*randn(size(X)); % Additive noise
% MMSE array optimization
w = pinv(X')*b;
p = abs(fftshift(fft(w,1024)));
p = p/max(p);
figure(1), polar(Theta*pi/180,p)

function [X,b] = signal(N,K,lambda,d,theta)
% QPSK symbol stream transmitted
b = sign(randn(N,1))+1j*sign(randn(N,1));
% Steering vector
a = exp(1j*2*pi*d/lambda*[0:K]*sin(theta));
% Complex envelope signal
X = a'*b';