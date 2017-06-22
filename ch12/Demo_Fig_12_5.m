% This code needs gKDR: http://www.ism.ac.jp/~fukumizu/software.html
%% Data
[XX Yb] = wine_dataset;
XX = XX';
XX = XX - repmat(min(XX),size(XX,1),1);
XX = XX ./ repmat(max(XX),size(XX,1),1);
[YY, ~] = find(Yb==1);
ii = randperm(size(XX,1));
X = XX(ii(1:size(XX,1)),:);
Y = YY(ii(1:size(XX,1)),:); 
Xts = XX(ii(size(XX,1)/2+1:size(XX,1)),:);
Yts = YY(ii(size(YY,1)/2+1:size(YY,1)),:);
Yb = binarize(Y);
%% Feature extraction settings and projections
nf = 2;
Cxx = cov(X); Cxy = X'*Yb; Cyy = cov(Yb);
% PLS
[U_pls,S_pls,V_pls] = svds(Cxy);
XtsProj_PLS = Xts * U_pls(:,1:nf); XProj_PLS = X * U_pls(:,1:nf);
Ypred_PLS = classify(XtsProj_PLS, XProj_PLS, Y);
% CCA
[U_cca,S_cca] = eigs(Cxy*(Cyy\Cxy'), Cxx);
XtsProj_CCA = Xts * U_cca(:,1:nf); XProj_CCA = X * U_cca(:,1:nf);
Ypred_CCA = classify(XtsProj_CCA, XProj_CCA, Y);
% KDR
[U_kdr.basis, ~] = KernelDeriv(X, Y, 2, 1, 1, 1);
XtsProj_KDR = Xts * U_kdr.basis(:,1:nf);
XProj_KDR = X * U_kdr.basis(:,1:nf);
Ypred_KDR = classify(XtsProj_KDR, XProj_KDR, Y);