function [predict,coefs] = deconv_GM(z,h,u,gamma,alfa)

% Initials
pr   = [0.5 0.5];
sn   = [0.5 1]*mean(z.^2);
m    = [1000 50];
mu   = 1e-2;
N    = length(z);
x    = zeros(N,1);
% Construct kernel matrix
Haux = convmtx(h,length(x));
H    = Haux(1:length(x),:);
% Initial norm-2 loop
for i = 1:m(1)
   x = x+2*mu*H'*(z-H*x);
end
% Main loop
for i = 1:m(2)
   % Posteriori
   p(:,1) = gauss(0,sn(2),x);
   p(:,2) = gauss(0,sn(1),x);
   pp     = (pr(2)*p(:,1)+pr(1)*(p(:,2)));
   r(:,1) = pr(2)*p(:,1)./pp;
   r(:,2) = pr(1)*p(:,2)./pp;
   % q caltulation
   q      = x.*(r(:,1)/sn(2)+r(:,2)/sn(1));
   % Intermediate steps
   c      = 2*H'*(H*x-z)+alfa*q;
   A      = H'*H;
   lam    = max(eig(A,'nobalance'));
   v      = c.*x;
   d      = zeros(length(x),1);
   d(v<0) = 1/(lam+alfa/(2*sn(1)));
   d(v>0) = min(1/(lam+alfa/(2*sn(1))), x(v>0)./c(v>0));
   D      = diag(d);
   % Main step
   x      = x-D*c;
   x      = x*(max(z))/max(abs(x));
   % Updating posteriori
   p(:,1) = gauss(0,sn(2),x);
   p(:,2) = gauss(0,sn(1),x);
   pp     = (pr(2)*p(:,1)+pr(1)*(p(:,2)));
   r(:,1) = pr(2)*p(:,1)./pp;
   r(:,2) = pr(1)*p(:,2)./pp;
   % Updating parameters
   sn(2)  = gamma*sn(2) + (1-gamma)*sum(x.^2.*r(:,1))/sum(r(:,1));
   sn(1)  = gamma*sn(1) + (1-gamma)*sum(x.^2.*r(:,2))/sum(r(:,1));
   pr(2)  = gamma*pr(2) + (1-gamma)*mean(r(:,1));
   pr(1)  = gamma*pr(1) + (1-gamma)*mean(r(:,2));
end
predict = x;
coefs = filter(h,1,x);

if ~isempty(u); predict=coefs; coefs=x; end
