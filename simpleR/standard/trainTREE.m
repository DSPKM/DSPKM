function model_TREE = trainTREE(Xtrain,Ytrain)

model_TREE = treefit(Xtrain,Ytrain,'method','regression');
% Uncomment this if you want to perform xval pruning ...
[c,s,nn,best] = treetest(model_TREE,'cross',Xtrain,Ytrain);
model_TREE    = treeprune(model_TREE,'level',best);
