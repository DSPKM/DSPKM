function model_BAGTREE = trainBAGTREE(Xtrain,Ytrain);

ntrees = 200; % Number of trees in the bag
model_BAGTREE = fitensemble(Xtrain,Ytrain,'Bag',ntrees,'Tree','type','regression');
% figure, plot(loss(bag,Xtest,Ytest,'mode','cumulative')),xlabel('Number of trees'),ylabel('Test error');
% cv = fitensemble(Xtrain,Ytrain,'Bag',200,'Tree','type','regression','kfold',10)
