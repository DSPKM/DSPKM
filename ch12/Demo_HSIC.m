function Demo_HSIC
% Number of examples
N = 1000;
% Distribution 1: correlation/linear association happens
X = rand(N,1); Y = X + 0.25 * rand(N,1); X = X + 0.25*rand(N,1);
% Distribution 2: no correlation, but dependence happens
t = 2*pi*(rand(N,1)-0.5);
X = cos(t) + 0.25*rand(N,1); Y = sin(t) + 0.25*rand(N,1);
% Distribution 3: neither correlation nor dependence exist
X = 0.25*rand(N,1); Y = 0.25*rand(N,1);
% Get dependence estimates
C       = corr(X, Y) % Correlation
HSIClin = hsic(X, Y, 'lin', [])
HSICrbf = hsic(X, Y, 'rbf', estimateSigma(X))
MI      = mutualinfo(X,Y)

function h = hsic(X,Y,ker,sigma)
Kx = kernelmatrix(ker, X', X', sigma); Kxc = kernelcentering(Kx); 
Ky = kernelmatrix(ker, Y', Y', sigma); Kyc = kernelcentering(Ky);
h  = trace(Kxc * Kyc) / (size(Kxc,1).^2);

function m = mutualinfo(X,Y)
binsx = round(sqrt(size(X,1))); [hh rr] = hist(X,binsx); 
pp = hh/sum(hh); h1 = -sum(pp.*log2(pp)) + log2(rr(3)-rr(2));
binsy = round(sqrt(size(Y,1))); [hh rr] = hist(Y,binsy); 
pp = hh/sum(hh); h2 = -sum(pp.*log2(pp)) + log2(rr(3)-rr(2));
[hh rr] = hist3([X Y],[binsx binsy]); pp = hh(:)/sum(hh(:));
h12 = -sum(pp.*log2(pp)) + log2((rr{1}(3)-rr{1}(2))*(rr{1}(2)-rr{2}(2)));
m = h1 + h2 - h12;