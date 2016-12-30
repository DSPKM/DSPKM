function [predict,coefs] = SVM_CC(Xtrain,Ytrain,Xtest,gamma,epsilon,C,path_acorr)

% Initialize params
if nargin==7 && ischar(path_acorr)
    load(path_acorr) % Precomputed autocorrelation of all available data
else
    % Computing autocorrelation with training data
    Ytrain = Ytrain(:,1) + 1i * Ytrain(:,2);
    if nargin<7; stepA=path_acorr; else stepA=1; end
    x = (min(Xtrain(:)):stepA:max(Xtrain(:))+stepA);
    axs=cell(1,size(Xtrain,2)); axs(:)={x(:)};
    [ACs{1:size(Xtrain,2)}]=ndgrid(axs{:});
    interpAxis = griddatan(Xtrain,Ytrain,reshape(cat(2,ACs{:}),numel(ACs{1}),length(ACs)));
    interpAxis(isnan(interpAxis)) = 0;
    [acorr,acs] = autocorr(reshape(interpAxis,size(ACs{1})),ACs{:});
    Ytrain = [real(Ytrain); imag(Ytrain)];
end
% Construct kernel matrix
H = real(getAutoCorrKernel(Xtrain,Xtrain,acorr,acs{:}));
Htest = real(getAutoCorrKernel(Xtrain,Xtest,acorr,acs{:}));
H = blkdiag(H,H);
Htest = blkdiag(Htest,Htest);

% Train SVM and predict
%params.ggamma=1e-1; params.epsilon=1e-6; params.C=100;
inparams=sprintf('-s 3 -t 4 -g %f -c %f -p %f -j 1', gamma, C, epsilon);
[ypred,model]=SVM(H,Ytrain,Htest,inparams);
Ntest=size(Xtest,1);
Ytestpred = ypred(1:Ntest) + 1i*ypred(Ntest+1:end);
predict = [real(Ytestpred), imag(Ytestpred)];
coefs = getSvmWeights(model);
