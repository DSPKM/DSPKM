function mmdDemo

clc; close all;
rng(1234);

% Two gaussians with different means
n=500;
x = linspace(-10,10,n);
mu1 = -2; si1 = +2; mu2 = +2; si2 = +2;
PX = normpdf(x,mu1,si1); PY = normpdf(x,mu2,si2);
Xe = mu1 + si1*randn(1,n); Ye = mu2 + si2*randn(1,n);
muXe = mean(Xe); muYe = mean(Ye); % d = abs(muXe-muYe);
figure,plot(x,PX,'k-',x,PY,'r-'),
legend('Px','Py'), xlabel('x'), ylabel('PDF'), grid

% Two gaussians with the same mean but different variances
mu1 = 0; si1 = +2; mu2 = 0; si2 = +6;
PX = normpdf(x,mu1,si1); PY = normpdf(x,mu2,si2);
Xe = mu1 + si1*randn(1,n); Ye = mu2 + si2*randn(1,n);
muXe = mean(Xe); muYe = mean(Ye); % d = abs(muXe-muYe);
figure,plot(x,PX,'k-',x,PY,'r-'),
legend('Px','Py'),xlabel('x'),ylabel('PDF'),grid

% Two gaussians with different variances, features transformed into x^2
mu1 = 0; si1 = +2; mu2 = 0; si2 = +4;
PX = normpdf(x.^2,mu1,si1); PY = normpdf(x.^2,mu2,si2);
Xe = mu1 + si1*randn(1,n); Ye = mu2 + si2*randn(1,n);
muXe = mean(Xe); muYe = mean(Ye); % d = abs(muXe-muYe);
muXe2 = mean(Xe.^2); muYe2 = mean(Ye.^2); % d = abs(muXe2-muYe2);
figure,semilogx(x.^2,PX,'k-',x.^2,PY,'r-'),
hold on, stem(log(muXe2),max(PX),'k'),stem(log(muYe2),max(PX),'r'),
legend('Px','Py'),xlabel('x'),ylabel('PDF'),grid, xlim([1,10])

% A gaussian and a Laplacian with same mean and variance
mu1 = 0; si1 = +2; mu2 = 0; si2 = +2;
PX = normpdf(x,mu1,si1); PY = lappdf(x,mu2,si2);
Xe = mu1 + si1*randn(1,n); Ye = mu2 + si2*randn(1,n);
muXe = mean(Xe); muYe = mean(Ye); % d = abs(muXe-muYe);
figure,plot(x,PX,'k-',x,PY,'r-'),
legend('Px','Py'), xlabel('x'), ylabel('PDF'), grid

function x = randlap(mu,st,n)
u = rand(n) - 0.5;
x = mu - st*sign(u) .* log(1-2*abs(u));

function p = lappdf(x,mu,st)
p = 1/(2*st)*exp(-abs(x-mu)/st);