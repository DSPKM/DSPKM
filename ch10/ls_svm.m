function y = ls_svm(y,K,Ktest,lambda)
% Example of LS-SVM

% Train
w = pinv([ 0 -y'; y diag(y)*K*diag(y) + lambda*eye(size(K,1)) ]) * ...
         [ 0 ; ones(size(y)) ];

alpha = w(2:end) .* y;
b = w(1);

% Test
y = Ktest' * alpha + b;