function kmeans_kernelkmeans

%% Initials
rng(12345)
clear; clc; close all
addpath('../simpleR/'),

%% Generate data (2-class concentric rings problem)
N1 = 200; N2 = 500;
x1 = 2*pi*rand(N1,1); r1 = rand(N1,1);
x2 = 2*pi*rand(N2,1); r2 = 2 + rand(N2,1);
X = [r1.*cos(x1) r1.*sin(x1) ; r2.*cos(x2) r2.*sin(x2)];
Y = [ones(N1,1) ; 2*ones(N2,1)];

%% Some parameters
k = 2;[N] = size(X,1);

%% k-means (Matlab) function
[idx,V] = kmeans(X, k, 'Display', 'iter');c1 = idx == 1;c2 = idx == 2;

%% plot
figure(1),clf, scatter(X(c1,1),X(c1,2),'+'),hold on, grid on,
scatter(X(c2,1),X(c2,2),'ro')

%% Kernel k-means
sigma = 1;Ke  = kernelmatrix('rbf',X',X',sigma);
Si = [ones(N,1) zeros(N,1)];Si(1,:) = [0 1];Si(2,:) = [0 1];
Si_prev = Si + 1;
while norm(Si-Si_prev,'fro') > 0
    Si_prev = Si;Si = assign_cluster(Ke,Si,k);
end

%% Plot results
Si = logical(Si);
figure(2), clf, scatter(X(Si(:,1),1),X(Si(:,1),2),'+'),hold on, grid on,
scatter(X(Si(:,2),1),X(Si(:,2),2),'ro')
end

%% Callback function
function Si = assign_cluster(Ke,Si,kc)
[N] = size(Ke,1);Nk = sum(Si,1);dist = zeros(N,kc);
for k = 1:kc
    dist(:,k) = diag(Ke) - (2/(Nk(k)))*sum(repmat(Si(:,k)',N,1).*Ke,2) + ...
        Nk(k)^(-2)*sum(sum((Si(:,k)*Si(:,k)').*Ke));
end
Si = real(dist == repmat(min(dist,[],2),1,kc));
end