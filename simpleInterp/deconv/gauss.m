function y = gauss(mu, covar, x)
%GAUSS	Evaluate a Gaussian distribution.
%
%	Description
%
%	Y = GAUSS(MU, COVAR, X) evaluates a multi-variate Gaussian  density
%	in D-dimensions at a set of points given by the rows of the matrix X.
%	The Gaussian density has mean vector MU and covariance matrix COVAR.
%
%	See also
%	GSAMP, DEMGAUSS

%	Copyright (c) Christopher M Bishop, Ian T Nabney (1996, 1997)

invcov = inv(covar);
[n, d] = size(x);
mu = reshape(mu, 1, d);    % Ensure that mu is a row vector
x = x - ones(n, 1)*mu;
fact = sum(((x*invcov).*x), 2);
y = exp(-0.5*fact);
y = y./sqrt((2*pi)^d*det(covar));