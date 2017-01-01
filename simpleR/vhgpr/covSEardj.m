function [A, B] = covSEardj(loghyper, x, z)

% jittered version

% Squared Exponential covariance function with Automatic Relevance Detemination
% (ARD) distance measure. The covariance function is parameterized as:
%
% k(x^p,x^q) = sf2 * exp(-(x^p - x^q)'*inv(P)*(x^p - x^q)/2)
%
% where the P matrix is diagonal with ARD parameters ell_1^2,...,ell_D^2, where
% D is the dimension of the input space and sf2 is the signal variance. The
% hyperparameters are:
%
% loghyper = [ log(ell_1)
%              log(ell_2)
%               .
%              log(ell_D)
%              log(sqrt(sf2)) ]
%
% For more help on design of covariance functions, try "help covFunctions".
%
% (C) Copyright 2006 by Carl Edward Rasmussen (2006-03-24)

persistent K

if nargin == 0, A = '(D+1)'; return; end          % report number of parameters

jitter = 1e-6;

[n D] = size(x);
ell = exp(loghyper(1:D));                         % characteristic length scale
sf2 = exp(2*loghyper(D+1));                                   % signal variance

if nargin == 2
  K = sf2*exp(-sq_dist(diag(1./ell)*x')/2);
  A = K+sf2*jitter*eye(n);                 
elseif nargout == 2                              % compute test set covariances
  A = sf2*(1+jitter)*ones(size(z,1),1);
  B = sf2*exp(-sq_dist(diag(1./ell)*x',diag(1./ell)*z')/2);
else                                                % compute derivative matrix
  if z == 1   
    K = sf2*exp(-sq_dist(diag(1./ell)*x')/2);
  end
  if z <= D                                           % length scale parameters
    A = K.*sq_dist(x(:,z)'/ell(z));  
  else                                                    % magnitude parameter
    A = 2*(K+sf2*jitter*eye(n));
    clear K
  end
end

