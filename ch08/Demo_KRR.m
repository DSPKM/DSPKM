%% Simple Multi-Output version of KRR
clear, clc
%% GENERATING DATA
sig_e = 0.8; %%% std of the noise
X = [-12 -10 -3 -2  2 8 12 14]';  % DIM => N x 1 (here d=1)
N = length(X); % number of data
Q = 4;
Y = sin(repmat(X,1,Q)) + sig_e * randn(N,Q); % DIM => N x Q
%% Basis functions
M = 4; % number of basis functions
phi = @(x) [1 x.^(1:M-1)]';
% Basis function matrix
PHI = zeros(length(X),M);
for i = 1:length(X)
    PHI(i,:) = phi(X(i))';  % DIM => N x M
end
% This hyper-parameter should be learnt with CV, for instance.
lambda = 1; 
% Optimal Primal Weights
W = (PHI'*PHI+ lambda*eye(M)) \ PHI' * Y;
% Optimal Dual Weights
A = (PHI * PHI' + lambda*eye(N)) \ Y; % for checking different equalities
sum(sum(W - PHI' * A)) % check equality
% kernel vector
KxX = @(x) PHI * phi(x);
% Inputs test
x_pr = -16:0.2:16;
% Predictor
F = zeros(M,length(x_pr)); Fdual = F;
for i = 1:length(x_pr)
    F(:,i) =  W' * phi(x_pr(i));
    Fdual(:,i) = KxX(x_pr(i))' * A; % for checking equality
end
%% Show results
figure(1), clf, plot(x_pr, F, 'LineWidth', 5), hold on
plot(x_pr, Fdual, '--', 'LineWidth', 5) % for checking equality
plot(X, Y, '.', 'MarkerSize', 30)
axis([-16 16 -4.2 4.2]), set(gca, 'Fontsize', 20), box on