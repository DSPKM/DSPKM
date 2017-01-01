function [nlpdapprox, nlpd] = nlogprob_vhgpr(y_tst, mu, s2, a, c2)
% NLOGPROB_VHGPR computes the Negative Log-Probability density for VHGPR
% using Gauss-Hermite quadrature.
%
% Input:    - y_tst: Test values.
%           compute error measures, predictions below do not use it.
%           - mutst: Expectation of the approximate posterior for g*.
%           - diagSigmatst: Variance of the approximate posterior for g*.
%           - atst: Expectation of the approximate posterior for f*.
%           - diagCtst: Variance of the approximate posterior for f*.
%
%
% Output:   - nlpdapprox: NLPD using Gaussian approximation
%           - nlpd: NLPD computed by Gauss-Hermite quadrature.
%
%
% The algorithm in this file is based on the following paper:
% M. Lazaro Gredilla and M. Titsias, 
% "Variational Heteroscedastic Gaussian Process Regression"
% Published in ICML 2011
%
% See also: vhgpr
%
% Copyright (c) 2011 by Miguel Lázaro Gredila

Ey = a;
Vy = c2+exp(mu+s2/2);

nlpdapprox = -0.5*(-(Ey-y_tst).^2./Vy-log(2*pi)-log(Vy));

xw = [  0.194840741569	0.375238352593;...
        0.584978765436	0.277458142303;...
        0.97650046359	0.151269734077;...
        1.37037641095	0.0604581309559;...	
        1.76765410946	0.0175534288315;...	
        2.16949918361	0.00365489032677;...
        2.57724953773	0.000536268365495;...
        2.99249082501	5.41658405999E-005;...
        3.41716749282	3.65058512533E-006;...
        3.85375548542	1.5741677944E-007;...
        4.30554795347	4.09883215841E-009;...
        4.77716450334	5.93329148347E-011;...
        5.27555098664	4.21501019491E-013;...
        5.81222594946	1.19734401957E-015;...
        6.40949814928	9.23173653482E-019;...
        7.12581390983	7.31067642754E-023];
x=[-xw(end:-1:1,1);xw(:,1)];
w=[xw(end:-1:1,2);xw(:,2)];
 
n=size(mu,1);
Ns = length(x);
samples = mu*ones(1,Ns)+(sqrt(2*s2)*ones(1,Ns)).*(ones(n,1)*x');
V = c2*ones(1,Ns) + exp(samples);
if size(V,1) == 1
    V = repmat(V, size(y_tst,1),1);
end

logp0 = -0.5*log(2*pi)-0.5*((y_tst-a).^2*ones(1,Ns))./V-0.5*log(V);
logfactor = max(logp0, [], 2);
logp0 = logp0 - logfactor*ones(1,Ns);
p0 = exp(logp0);

nlpd = -log(p0*w)+0.5*log(pi)-logfactor;
