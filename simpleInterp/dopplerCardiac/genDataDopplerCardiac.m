function data=genDataDopplerCardiac(conf)

load(conf.data.path)
[Xtr,Ytr,Xtst,Ytst] = selectSamples(I,conf.Ntrain,conf.sampleType{1}); 
data.Xtrain = Xtr';
data.Ytrain = Ytr';
data.Xtest = Xtst';
data.Ytest = Ytst';
% Computing and saving autocorrelation vector and its axis
ax = 1:size(I,1);
ay = 1:size(I,2);
[AXs{1:2}] = ndgrid(ax,ay);
[acorr, acs] = autocorr(I,AXs{:});
save(conf.path_acorr,'acorr','acs')
