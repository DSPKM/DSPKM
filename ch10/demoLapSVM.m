%% Demo for Laplacian SVM
clear, clc; rng('default')
%% Setup paths
addpath('../simpleR/'), addpath('../libsvm/')
%% Training data
l = 2; u = 300; [Xl,Yl] = moons(l/2);
%% Unlabeled data
Xu = moons(u/2); Yu = zeros(u,1); X1 = [Xl;Xu]; Y1 = [Yl;Yu];
%% Test data
[X2,Y2] = moons(200);
%% Scale data
X1 = scale(X1); X2 = scale(X2);
%% Build the graph Laplacian L of the adjacency graph W with all data l+u
options.type = 'nn';   % nearest neighbors to obtain the adjacent points
options.NN = 12;       % number of neighbors
options.GraphDistanceFunction = 'euclidean'; % distance for the adjacency
options.GraphWeights = 'heat'; % heat function applied to the distances in W
options.GraphWeightParam = 1;  % width for heat kernel (t) if 'heat'
options.GraphNormalize = 1;    % normalizes the adjacencies of each point
L = laplacian(X1, 'nn', options);
%% Hyperparameters: sigma, gamma_A, gamma_I
sigma = 0.3;
gL = 0.05; lambda1 = gL;
gM = 5;    lambda2 = gM; % Use gM = 0 for standard SVM
%% Train LapSVM
K1 = kernelmatrix('rbf', X1', X1', sigma);
K2 = kernelmatrix('rbf', X2', X1', sigma);
[alpha,b] = lapsvm(K1, Y1, L, lambda1, lambda2);
Y2pred = sign(K2 * alpha - b);
OA = 100 * length(find(Y2pred == Y2)) / length(Y2)
%% Plot results
x = -0.25:0.05:1.25; y = -0.25:0.05:1.25; % x and y range
[xx,yy] = meshgrid(x,y); X2 = [xx(:) yy(:)];
K2 = kernelmatrix('rbf', X2', X1', sigma);
z  = (K2 * alpha - b); Z = reshape(z,length(x),length(y));
figure(1), clf
[cs,h] = contourf(xx, yy, Z, 1); shading flat; colormap(summer) %colormap(cmr)
hold on, plot(X1(Y1==0,1), X1(Y1==0,2), 'k.');
plot(X1(Y1==+1,1), X1(Y1==+1,2), 'bo', X1(Y1==-1,1), X1(Y1==-1,2), 'ro');
axis off square