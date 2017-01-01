function [A, B] = covZero(dummy, x, z);

% covariance function for a constant function. The covariance function is
% parameterized as:
%
% k(x^p,x^q) = 0
%


if nargin == 0, A = '0'; return; end              % report number of parameters

is2 = 0;                                            % s2 inverse

if nargin == 2
  A = zeros(size(x,1));
elseif nargout == 2                              % compute test set covariances
      A = zeros(size(z,1),1);
  B = zeros(size(x,1),size(z,1));
else                                                % compute derivative matrix
  A = zeros(size(x,1));
end

