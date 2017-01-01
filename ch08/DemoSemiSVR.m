% SS-SVR on LAI estimation
clear, clc
rng('default'); rng(0); addpath('../libsvm/')
% Supervised free parameters
sigma = 1; C = 1; epsilon = 0.1;
% Semi-supervised free parameters
gamma = 1e-2; nn = 5;
% Generate dummy data: labeled (X,Y) and unlabeled (Xu, Yu)
% X, Y, Xu, Yu (only for testing)
% Kernel matrix: (l+u) x (l+u)
K = kernelmatrix('rbf',[X;Xu]',[X;Xu]',sigma);
% Graph Laplacian
lap_options.NN = nn; % neighbors
L = laplacian([X;Xu],'nn',lap_options);
M = gamma*L; I = eye(size(L,1));
INVERSE = (I + M*K) \ M;
Khat = zeros(size(K));
for x = 1:length(K) 
   Khat(x,:) = K(x,:) - K(:,x)' * INVERSE * K;
end
% Train and test with the deformed kernel
model = mexsvmtrain(Y,Khat,params);
Yp = mexsvmpredict(Y,Khat,model);
