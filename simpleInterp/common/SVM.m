function [predict,model] = SVM(X,Y,Xtest,inparams)
% svm_train = @mysvmtrain;
% svm_predict = @mysvmpredict;
% Training SVM
model = mexsvmtrain(Y,X,inparams);
% Prediction
predict = zeros(size(Xtest,1),1);
if ~isempty(model) && ~isempty(model.SVs) && ~isempty(Xtest)
    predict = mexsvmpredict(zeros(size(Xtest,1),1),Xtest,model);
end