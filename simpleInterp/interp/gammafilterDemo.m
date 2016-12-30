% System
A_true=[1 0.5 0.3]; B_true=[1 0.5];
% Data
x  = randn(100,1); Pn = 0.01; 
y  = filter(B_true,[1 A_true],x)+sqrt(Pn)*randn(size(x));
% gamma-SVM parameters
epsilon = 0; gamma = 1e-1; C = 10; p = 5; mu = (.1:.1:1.9);
% Try different mu values
for i = 1:length(mu)
    disp([num2str(i) ' de ' num2str(length(mu))]);
    [a, b, ypred,er(i)] = svm_gamma_wls(x,y,p,mu(i),epsilon,C,gamma);
end
% Get best results
[m,k] = min(er); mimu = mu(k); [a,b,ypred,ee] = svm_gamma_wls(x,y,p,mimu,epsilon,C,gamma);
% Plot figure
figure(1), clf, subplot(211), plot(y), hold on, plot(ypred,'r'),hold off; subplot(212),plot(mu,er);

function [a,b,ypred,er] = svm_gamma_wls(x,y,p,mu,e,C,gam)
%
%  SVM_GAMMA_WLS Support Vector for ARMA modeling with WLS optimization
%
%  Usage: [a b ypred] = svm_gamma_wls(x,y,p,mu,e,C,gam)
%
%  Parameters: x      - Plant input
%              y      - Plant output
%              p      - Order of a 
%              mu     - gamma memory
%              e      - Insensitivity on prediction error
%              C      - Upper bound and linear cost param
%              gam    - Quadratic cost param
%              a  b   - Model coeffs
%              ypred  - Predicted output

% Init
y = y(:); x = x(:); N = length(y);
% Construct X matrix and w vector  
k0 = p+1; X = []; b = mu; a = [1 -(1-mu)];
xold = x';
for i = 1:p
    X = [X;xold]; xold = filter(b,a,xold);
end
X = X(:,k0:end); yold = y; y = y(k0:end);
%%% >>> Insert here your SVM solver: [W,mu] = SVMsolver(X,y)  <<<<
ypred = X'*W; ypred = [zeros(p,1) ; ypred];
er = norm(ypred(p+1:end) - yold(p+1:end));
