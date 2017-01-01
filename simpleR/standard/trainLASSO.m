function model_LASSO = trainLASSO(Xtrain,Ytrain)

[b fitinfo]= lasso(Xtrain,Ytrain,'CV',5);
% lassoPlot(b,fitinfo);
lam = fitinfo.Index1SE; % find index of suggested lambda
model_LASSO.B = b;
model_LASSO.W = b(:,lam);
model_LASSO.S = fitinfo;
