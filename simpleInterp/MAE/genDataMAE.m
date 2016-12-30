function data = genDataMAE(conf)

load(conf.data.path);
X=data{conf.I}.X;
Y=data{conf.I}.Y; clear data
N=size(X,1);
pos_test = randperm(N,ceil(0.3*N)); % 70% train / 30% test
pos_train = setdiff(1:N,pos_test);
data.Xtrain = X(pos_train,:);
data.Ytrain = Y(pos_train);
data.Xtest = X(pos_test,:);
data.Ytest = Y(pos_test);
