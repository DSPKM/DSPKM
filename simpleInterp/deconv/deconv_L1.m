function [predict,coefs] = deconv_L1(y,h,u,lambda)
% Init
N     = length(y); coefx = ones(N,1); coefe = ones(N,1); lb    = zeros(1,4*N);
% Construct kernel matrix
Haux = convmtx(h,N);
H    = Haux(1:N,:);
A    = [H -H eye(N) -eye(N)];
% Deconvolution
options = optimset('Display','off');
fo      = [lambda*coefx; lambda*coefx ; coefe ; coefe];
x       = linprog(fo,[],[],A,y,lb,[],[],options);
predict = x(1:N)-x(N+1:2*N);
coefs   = filter(h,1,predict);
if ~isempty(u); aux=predict; predict=coefs; coefs=aux; end