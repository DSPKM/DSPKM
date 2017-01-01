function model_ElasticNet = trainElasticNet(Xtrain,Ytrain)

[b fitinfo]= lasso(Xtrain,Ytrain,'CV',5,'Alpha',0.5);
lam = fitinfo.Index1SE; % find index of suggested lambda
model_ElasticNet.B = b;
model_ElasticNet.W = b(:,lam);
model_ElasticNet.S = fitinfo;
