%% Paths
addpath('../simpleR/');
%% Data
NN = 200;
% Generate X Y pairs: 3 Gaussians
% YY = binarize([ones(NN,1); 2*ones(NN,1); 3*ones(NN,1)]);
YY = [ones(NN,1); 2*ones(NN,1); 3*ones(NN,1)];
XX(:,1) = rand(3*NN,1) * 2;
XX(:,2) = [ (XX(1:NN,1)-1).^2 ; (XX(NN+1:NN*2,1)-1).^2 + 0.2 ; ...
            (XX(2*NN+1:NN*3,1)-1).^2+0.4] + 0.04 * randn(3*NN,1);
XX = XX - repmat(mean(XX),size(XX,1),1);
% Generate train / test sets
ii = randperm(3*NN);
X = XX(ii(1:NN),:); Y = YY(ii(1:NN),:); 
Xts = XX(ii(NN+1:3*NN),:); Yts = YY(ii(NN+1:3*NN),:); 
% Binarize outputs for PLS, OPLS, CCA and kernel variants
Yb = binarize(Y);

%% Number of features (projections, components) to be extracted
nf = 2;
%% Covariances for Linear Methods
Cxx = cov(X); Cxy = X'*Yb; Cyy = cov(Yb);
% PCA
[U_pca D] = eig(Cxx);
XtsProj_PCA = Xts * U_pca(:,1:nf); XProj_PCA = X * U_pca(:,1:nf);
Ypred_PCA = classify(XtsProj_PCA, XProj_PCA, Y);
% PLS
[U_pls,S_pls,V_pls] = svds(Cxy);
XtsProj_PLS = Xts * U_pls(:,1:nf); XProj_PLS = X * U_pls(:,1:nf);
Ypred_PLS = classify(XtsProj_PLS,XProj_PLS,Y);   
% OPLS
[U_opls,S_opls] = eigs(Cxy*Cxy', Cxx);
XtsProj_OPLS = Xts * U_opls(:,1:nf); XProj_OPLS = X * U_opls(:,1:nf);
Ypred_OPLS = classify(XtsProj_OPLS,XProj_OPLS,Y);
% CCA
[U_cca,S_cca] = eigs(Cxy*(Cyy\Cxy'), Cxx);
XtsProj_CCA = Xts * U_cca(:,1:nf); XProj_CCA = X * U_cca(:,1:nf);
Ypred_CCA = classify(XtsProj_CCA,XProj_CCA,Y);

%% Kernels for Nonlinear methods
sigmax = estimateSigma(X,X);
K = kernelmatrix('rbf', X', X', sigmax); Kc = kernelcentering(K);
Ktest = kernelmatrix('rbf', X', Xts', sigmax); Kctest = kernelcentering(Ktest, Kc);
% KPCA
[U_kpca,S_kpca] = eigs(Kc, nf);
XProj_KPCA = Kc' * U_kpca; XtsProj_KPCA  = Kctest' * U_kpca;
Ypred_KPCA = classify(XtsProj_KPCA, XProj_KPCA, Y);
% KPLS
[U_kpls,S_kpls,V_kpls] = svds(Kc*Yb, nf);
XProj_KPLS = Kc' * U_kpls; XtsProj_KPLS  = Kctest' * U_kpls;
Ypred_KPLS = classify(XtsProj_KPLS, XProj_KPLS, Y);
% KOPLS
[U_kopls,S_kopls] = eigs(K*(Yb*Yb')*K, K'*K, nf);
XProj_OKPLS = Kc' * U_kopls; XtsProj_OKPLS  = Kctest' * U_kopls;
Ypred_OKPLS = classify(XtsProj_OKPLS, XProj_OKPLS, Y);
% KCCA
npmax = min([nf,size(X,1)]);
[U_kcca, S_kcca] = eigs(Kc*Yb*(Cyy\Yb')*Kc, Kc*Kc, nf); % Basis in X
XProj_KCCA = Kc' * U_kcca; XtsProj_KCCA  = Kctest' * U_kcca;
Ypred_KCCA = classify(XtsProj_KCCA, XProj_KCCA, Y);