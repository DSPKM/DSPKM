function [predict,coefs] = SVM_AutoCorr(Xtrain,Ytrain,Xtest,gamma,nu,C,path_acorr)

% Initialize params
if nargin==7 && ischar(path_acorr)
    load(path_acorr) % Precomputed autocorrelation of all available data
else
    % Computing autocorrelation with training data
    if nargin<7; paso=path_acorr; else paso=1; end
    x = (min(Xtrain(:)):paso:max(Xtrain(:))+paso);
    axs=cell(1,size(Xtrain,2)); axs(:)={x(:)};
    [ACs{1:size(Xtrain,2)}]=ndgrid(axs{:});
    interpAxis = griddatan(Xtrain,Ytrain,cat(2,ACs{:}));
    interpAxis(isnan(interpAxis)) = 0;
    [acorr,acs] = autocorr(reshape(interpAxis,size(ACs{1})),ACs{:});
end
% Construct kernel matrix
H = getAutoCorrKernel(Xtrain,Xtrain,acorr,acs{:});
% Train SVM and predict
nchunks=16; ntest=length(Xtest); % Chunks partition for speeding up
chunks=floor(ntest/nchunks); % If Xtest is an image: 4x4 chunks
chunksTest = mat2cell(Xtest,...
    [repmat(chunks,1,nchunks-1),ntest-(nchunks-1)*chunks],2);
%inparams=sprintf('-s 3 -t 4 -g %f -c %f -p %f -j 1', gamma, C, epsilon);
inparams=sprintf('-s 4 -t 4 -g %f -c %f -n %f -j 1', gamma, C, nu);
chunksPredict=cell(1,nchunks);
for i=1:nchunks
    Htest = getAutoCorrKernel(Xtrain,chunksTest{i},acorr,acs{:});
    [chunksPredict{i},model]=SVM(H,Ytrain,Htest,inparams);
end
predict=cell2mat(chunksPredict');
coefs = getSvmWeights(model);
