% Comparing SVR, KRR and GPR (simpleR MATLAB toolbox needed)
addpath(genpath('../simpleR/')), addpath('../libsvm/')
% Generating Data
n = 100; X = linspace(-pi,pi,n)'; s = sinc(X); y = s + 0.1*randn(n,1);
% Split training and testing sets
n = length(y); r = randperm(n); ntr = round(0.3*n);
idtr = r(1:ntr); idts = r(ntr+1:end);
Xtr = X(idtr,:); ytr = y(idtr,:); Xts = X(idts,:); yts = y(idts,:);
%% SVR
model1 = trainSVR(Xtr,ytr); ypred1 = testSVR(model1,X);
ypred1ts = testSVR(model1,Xts);
%% RVM
model2 = trainRVM(Xtr,ytr); ypred2 = testRVM(model2,X);
ypred2ts = testRVM(model2,Xts);
%% GPR
model3 = trainGPR(Xtr,ytr); [ypred3 s3] = testGPR(model3,X);
ypred3ts = testGPR(model3,Xts);
%% Results in the test set
r1 = assessment(yts,ypred1ts,'regress');
r2 = assessment(yts,ypred2ts,'regress');
r3 = assessment(yts,ypred3ts,'regress');
%% Plots
figure(1), clf, plot(X,y,'ko'), hold on, plot(X,s,'k')
plot(X,ypred1,'r'), plot(Xtr(model1.idx),ytr(model1.idx),'ro'),
legend('Actual','Observations','SVR','SVs'), axis off
figure(2), clf, plot(X,y,'ko'), hold on, plot(X,s,'k')
plot(X,ypred2,'r'), plot(Xtr(model2.used),ytr(model2.used),'ro')
legend('Actual','Observations','RVM','RVs'), axis off
figure(3), clf, plot(X,y,'ko'), hold on, plot(X,s,'k')
plot(X,ypred3,'r'), plot(X,ypred3+sqrt(s3),'r--'),
plot(X,ypred3-sqrt(s3),'r--'),
legend('Actual','Observations','KRR/GPR','\mu_y \pm \sigma_y'), axis off