function model_BOOST = trainBOOST(Xtrain,Ytrain)

ntrees = 200; % Number of trees in the bag
model_BOOST = fitensemble(Xtrain,Ytrain,'LSBoost',ntrees,'Tree');
