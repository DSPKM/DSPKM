function [Xtrain,Ytrain,Xtest,Ytest] = load_data(conf)

data = conf.data.loadDataFuncName(conf);
if isfield(data,'h') % Deconvolution problem
    Xtrain = data.z; Xtest = data.u;
    Ytrain = data.h; Ytest = data.x;
elseif isfield(data,'Xtrain') % Learning task
    Xtrain = data.Xtrain; Xtest = data.Xtest;
    Ytrain = data.Ytrain; Ytest = data.Ytest;
else
    error('ErrorTests:convertTest', 'Unexpected data structure generated...\nFor further information see: load_data.m');
end