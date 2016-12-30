N = 100;
x = randn(N,1);
b = [3 -0.5  0.2];
a = [1 -0.03 0.01];
y = filter(b,a,x);
% ... plus noise ...
yy = y + sqrt(.1) * randn(size(y));
% Filter impulse response
h = impz(b,a,10);