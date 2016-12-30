function data = genDataSpectral(conf)

rng(500)
cf = conf.data;
% Signal
y = sin(2*pi*cf.f*(1:cf.n))';
% Gaussian noise
y = y + sqrt(cf.var_noise)*randn(size(y));
% Impulsive noise
nin = round(cf.p*cf.n);
affected_samples = randperm(cf.n,nin);
imp_noise = cf.A*sign(rand(1,nin)-.5)+(rand(1,nin)-0.5);
y(affected_samples)=imp_noise;
% Create data structure
data.Xtrain=cf.f; data.Ytrain=y; data.Xtest=cf.f; data.Ytest=y;
