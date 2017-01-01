function [A, B] = covAR1(logtheta, x, z)

% Covariance function for an AR(1) process
%
% k(x^(t),x^(t+n)) = sf2/(1-phi^2) phi^|n|
%
% The scalar hyperparameters are:
%
% logtheta = [ atanh(phi) log(sqrt(sf2)) ]
%
%
% 2010 Miguel Lazaro Gredilla

if nargin == 0, A = '2'; return; end              % report number of parameters

phi = tanh(logtheta(1));
sf2 = exp(2*logtheta(2));    
n = size(x,1);

if nargin == 2
    A = sf2/(1-phi^2)*phi.^abs(repmat(x,1,n)-repmat(x',n,1));
elseif nargout == 2                              % compute test set covariances
    ntst = size(z,1);
    A = sf2/(1-phi^2)*ones(ntst,1);
    B = sf2/(1-phi^2)*phi.^abs(repmat(x,1,ntst)-repmat(z',n,1));
else                                                % compute derivative matrix
    if z == 1   % wrt phi
        absn = abs(repmat(x,1,n)-repmat(x',n,1));
        A = sf2*(cosh(2*logtheta(1)) + absn -1).*phi.^(absn-1);
    elseif z == 2   % wrt sf2
        A = 2*sf2/(1-phi^2)*phi.^abs(repmat(x,1,n)-repmat(x',n,1));
    end
end

