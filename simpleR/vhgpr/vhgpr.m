function [out1, out2, mutst, diagSigmatst, atst, diagCtst]= vhgpr(LambdaTheta, covfunc1, covfunc2, fixhyp, X, y, Xtst)
% VHGPR - MV bound for heteroscedastic GP regression
%
% Input:    - LambdaTheta: Selected values for [Lambda hyperf hyperg mu0].
%           - covfunc1: Covariance function for the GP f (signal).
%           - covfunc2: Covariance function for the GP g (noise).
%           - fixhyp: 
%                        0 - Nothing is fixed (all variational parameters
%                        and hyperparameters are learned).
%                        1 - Hyperparameters for f are fixed.
%                        2 - Hyperparameters for f and g are fixed. (Only
%                        variational parameters are learned).
%           - X: Training input data. One vector per row.
%           - y: Training output value. One scalar per row.
%           - Xtst: Test input data. One vector per row.
%
% Output:   - out1: 
%                   Training mode: MV bound.
%                   Testing mode: Expectation of the approximate posterior
%                   for test data.
%           - out2: 
%                   Training mode: MV bound derivatives wrt LambdaTheta.
%                   Testing mode: Variance of the approximate posterior
%                   for test data.
%           - mutst: Expectation of the approximate posterior for g.
%           - diagSigmatst: Variance of the approximate posterior for g.
%           - atst: Expectation of the approximate posterior for f.
%           - diagCtst: Variance of the approximate posterior for f.
%
% Modes:    Testing (all inputs are given) / Training (last input is omitted)
%
% The algorithm in this file is based on the following paper:
% M. Lazaro Gredilla and M. Titsias, 
% "Variational Heteroscedastic Gaussian Process Regression"
% Published in ICML 2011
%
% See also: vhgpr_ui
%
% Copyright (c) 2011 by Miguel Lazaro Gredila

[n,D] = size(X); %#ok<NASGU>

% Parameter initialization
ntheta1 = eval(feval(covfunc1{:}));
ntheta2 = eval(feval(covfunc2{:}));

if n+ntheta1+ntheta2+1 ~= size(LambdaTheta,1),error('Incorrect number of parameters');end
Lambda = exp(LambdaTheta(1:n));
theta1 = LambdaTheta(n+1:n+ntheta1);
theta2 = LambdaTheta(n+ntheta1+1:n+ntheta1+ntheta2);
mu0 = LambdaTheta(n+ntheta1+ntheta2+1);

Kf = feval(covfunc1{:},theta1, X);
Kg = feval(covfunc2{:},theta2, X);

% Precomputations
sLambda = sqrt(Lambda);
cinvB = chol(eye(n) + Kg.*(sLambda*sLambda'))'\eye(n);   % O(n^3)
cinvBs = cinvB.*(ones(n,1)*sLambda');
beta = (Lambda-0.5);
mu = Kg*beta+mu0;

hBLK2 = cinvBs*Kg;                                         % O(n^3)
Sigma = Kg - hBLK2'*hBLK2;                                 % O(n^3) (will need the full matrix for derivatives)

R = exp(mu-diag(Sigma)/2);
p = 1e-3; % This value doesn't affect the result, it is a scaling factor
scale = 1./sqrt(p+R); 
Rscale = 1./(1+p./R);
Ls = chol(Kf.*(scale*scale')+diag(Rscale));     % O(n^3)
Lys = (Ls'\(y.*scale));
alphascale = Ls\Lys;
alpha = alphascale.*scale;

% --- Objective
F = -0.5*y'*alpha       - sum(log(diag(Ls)))  +sum(log(scale))             - n/2*log(2*pi) ... % log N(y|0,Kf+R)
    -0.5*beta'*(mu-mu0) + sum(log(diag(cinvB))) - 0.5*sum(sum(cinvB.^2)) + n/2 ...           % -KL(N(g|mu,Sigma)||N(g|0,Kg))
    -0.25*trace(Sigma);                                                                      % Normalization

out1=-F;

% --- Derivatives
if nargin == 6 && nargout == 2
    out2=zeros(n+1+ntheta1+ntheta2,1);
    
    invKfRs = Ls\(Ls'\eye(n));    % O(n^3)
    betahat = -0.5*(diag(invKfRs).*Rscale-alphascale.^2.*Rscale);
    Lambdahat = betahat + 0.5;
    
    % wrt Lambda
    dFLambda = -(Kg+0.5*Sigma.^2)*(Lambda-Lambdahat);
    out2(1:n) = -Lambda.*dFLambda;
    
    if fixhyp < 1
    % wrt Kf hyperparameters
    W = alpha*alpha'- invKfRs.*(scale*scale');
    for k = 1:ntheta1
        out2(n+k) = -sum(sum(W.*feval(covfunc1{:}, theta1, X, k)))/2;
    end
    end
    
    if fixhyp < 2
    % wrt Kg hyperparameters
    invBs = cinvB'*cinvBs;    % O(n^3)
    W = beta*beta' + 2*(betahat-beta)*beta' - invBs'*(((Lambdahat./Lambda-1)*ones(1,n)).*invBs) - cinvBs'*cinvBs;    % O(n^3)
    for k = 1:ntheta2
        out2(n+ntheta1+k) = -sum(sum(W.*feval(covfunc2{:}, theta2, X, k)))/2;
    end
    
    % wrt mu0
    dFmu0 = sum(Lambdahat-0.5);
    out2(n+ntheta1+ntheta2+1) = -dFmu0;
    end

% --- Predictions
elseif nargin == 7
    [K1ss, K1star] = feval(covfunc1{:}, theta1, X, Xtst);     % test covariance f
    [K2ss, K2star] = feval(covfunc2{:}, theta2, X, Xtst);     % test covariance g
    atst  = K1star' * alpha;                                  % predicted mean  f 
    mutst = K2star' * beta + mu0;                             % predicted mean  g 
    out1 = atst;                                              % predicted mean  y

  if nargout > 1
    v = Ls'\((scale*ones(1,size(Xtst,1))).*K1star);
    diagCtst = K1ss - sum(v.*v)';                             % predicted variance f 
    v = cinvBs*K2star;
    diagSigmatst = K2ss - sum(v.*v)';                         % predicted variance g 
    out2 = diagCtst + exp(mutst+diagSigmatst/2);              % predicted variance y
  end  
end