function [predict, coefs] = LI(Xtrain,Ytrain,Xtest,~)

F=scatteredInterpolant(Xtrain(:,1),Xtrain(:,2),Xtrain(:,3),Ytrain,'linear');
predict=F(Xtest(:,1),Xtest(:,2),Xtest(:,3));
coefs=[];
