function Yp = testSVR(model,Xtest)

Xtrain = model.Xtrain;
sigma  = model.sigma;
model = rmfield(model, {'Xtrain', 'sigma', 'C'});

Kt = kernelmatrix('rbf',Xtest',Xtrain',sigma);
Yp = mexsvmpredict(zeros(size(Xtest,1),1), Kt, model);