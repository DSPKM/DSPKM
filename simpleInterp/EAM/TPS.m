function [predict,coefs] = TPS(Xtrain,Ytrain,Xtest,lambda)

[N,D]=size(Xtrain);
Ntest=size(Xtest,1);
% Contruct kernel matrix
distances = sqrt(dist2(Xtrain,Xtrain));
K = K_matrix(distances);
P = [ones(N,1) Xtrain];
% Train
K_reg = K + lambda*eye(size(K,1));
L = [K_reg P; P' zeros(D+1,D+1)];
Q = [Ytrain; zeros(D+1,1)];
coefs = L\Q;
% Predict
distances = sqrt(dist2(Xtest,Xtrain));
matrix_eta= K_matrix(distances);
predict = [ones(Ntest,1) Xtest]*coefs(N+1:end)+matrix_eta*coefs(1:N);
