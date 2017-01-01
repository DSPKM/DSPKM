% RVM compared with the GPR solution
clear, clc
% Generating data
sig_e = 0.5; % std of the noise
X = [-12 -10 -3 -2  2 8 12 14]';
N = length(X); % number of data
Y = sin(X) + sig_e * randn(N,1); % N x 1
% Basis functions
M = N; % number of basis functions  =  data size (RVM)
sig = 2; phi = @(x1,x2) exp(-(x1-x2).^2/sig^2);
% Basis function matrix
z = meshgrid(X); PHI = phi(z,z'); % N x M
% Prior variance
% For simplicity, we assume that we learn in training
% the same sigma_prior for each basis function/weight
% hence, we assume the same relevance for each basis function
sig_prior = 1;
Sigma_p = sig_prior^2 * eye(M); % Cov-Matrix of the prior over w
% moments of the posterior of w
w_mean = ((PHI'*PHI) + sig_e^2/sig_prior^2*eye(M)) \ PHI' * Y; % M x 1
w_Covar_Matrix = ((1/sig_e^2)*(PHI'*PHI)+inv(Sigma_p)) \ eye(M); % M x M
% Test inputs
x_pr = -16:0.2:16;
Lambda = (PHI + sig_e^2 * eye(N)); % FOR GP comparison
% Posterior mean and variance of f
f_mean = zeros(1,length(x_pr)); sigma_post = f_mean;
f_meanGP = f_mean; sigma_postGP = f_meanGP;
for i = 1:length(x_pr)
    Phix = phi(x_pr(i),X)';
    f_mean(i) =  Phix * w_mean; % RVM
    sigma_post(i) = Phix * w_Covar_Matrix * Phix'; % RVM
    f_meanGP(i) = Phix / Lambda * Y; % GP
    sigma_postGP(i) = phi(x_pr(i),x_pr(i)) - Phix / Lambda * Phix'; % GP
end
% Sampling functions from RVM Posterior
Num_Funct = 3;
w_sample = mvnrnd(w_mean, w_Covar_Matrix, Num_Funct);
f_samples_from_post = zeros(length(x_pr), Num_Funct);
for i = 1:length(x_pr)
    Phix = phi(x_pr(i),X)';
    f_samples_from_post(i,:) = Phix * w_sample';
end
% RVM
V1 = f_mean - sqrt(sigma_post); V2 = f_mean + sqrt(sigma_post);
figure(1), clf, plot(x_pr, f_mean, 'k', 'LineWidth', 5), hold on
fill([x_pr, fliplr(x_pr)], [V1, fliplr(V2)], 'k', ...
    'FaceAlpha', 0.3, 'EdgeAlpha', 0.7)
plot(x_pr, f_samples_from_post,'--', 'LineWidth', 3);
plot(X, Y, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10)
axis([-16 16 -4.2 4.2]), set(gca, 'Fontsize', 20)
h = legend('RVM'); set(h,'Box','off'), box on
% GP
V1 = f_meanGP - sqrt(sigma_postGP); V2 = f_meanGP + sqrt(sigma_postGP);
figure(2), clf, plot(x_pr, f_meanGP, 'k', 'LineWidth', 5), hold on
fill([x_pr, fliplr(x_pr)], [V1, fliplr(V2)], 'k', ...
    'FaceAlpha', 0.3, 'EdgeAlpha', 0.7)
plot(X, Y, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10)
axis([-16 16 -4.2 4.2]), set(gca, 'Fontsize', 20),
h = legend('GP'); set(h,'Box','off'), box on
% RVM & GP
figure(3); clf, plot(x_pr, sigma_post, 'k', 'LineWidth', 5), hold on
plot(x_pr, sigma_postGP, 'r--', 'LineWidth', 5),
plot(X, zeros(1,N), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10)
axis([-22 22 0 max(sigma_postGP)+0.4]), set(gca, 'Fontsize', 20),
h = legend('RVM','GP','Data points'); set(h,'Box','off'), box on