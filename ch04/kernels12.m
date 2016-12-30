%% Data
X_o = [-1.5 -1 -0.75 -0.4 -0.3 0]';
Y_o = [-1.6 -1.3 -0.5 0 0.3 0.6]';
%% Define a SE kernel
nu = 1.15; % scale of the kernel
s  = 0.30; % lengthscale sigma parameter of the kernel
kf = @(x,x2) nu^2 * exp( (x-x2).^2  /(-1*s^2) );
sn = 0.01; % known noise on observed data
ef = @(x,x2) sn^2 * (x==x2); % iid noise
% Let's sum the signal and noise kernel functions:
k = @(x,x2) kf(x,x2) + ef(x,x2);
% Let's plot the kernel function of domain x
np = 100; x = linspace(-1,1,np)';
y = kf(zeros(length(x),1),x);
figure(1), plot(x,y,'k','LineWidth',8), axis([-1 1 0 1.5]), axis off
% Now let's draw two random functions out of the kernel
K = zeros(length(x));
for i = 1:length(x)
    K(i,:) = kf(x(i) * ones(length(x),1), x);
end
% Due to numerical precision, we need to add a small factor to the diagonal
% to ensure positive definiteness
sphi = chol(K + 1e-12 * eye(size(K)))';
rf = sphi * randn(length(x),2);
figure(2), plot(x,rf(:,1)+1,x,rf(:,2)-1,'LineWidth',8), axis off

%% Done!

% As a proposed exercise, try to do the same with the 
% rational-quadratic kernel, the periodic kernel and combinations. 
% We give you some hint material:

% 1) Rational-quadratic kernel,
c = 0.05; 
krq = @(x1,x2) sigma_f^2 * (1 - (x1-x2).^2 ./ ((x1-x2).^2 + c)) + ef(x1,x2);
% 2) Periodic kernel
p = 0.4; % periode
s = 1;   % SE kernel lengthscale
kper = @(x1,x2) sigma_f^2 * exp(-sin(pi*(x1-x2)/p).^2/l^2) + ef(x1,x2);
% 3) Linear kernel
offset = 0; 
kl = @(x1,x2) sigma_f^2 * (x1 - offset) .* (x2 - offset) + 1e-5*ef(x1,x2);
