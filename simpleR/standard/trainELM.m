function model = trainELM(X,Y)

% Set to non-zero to use it (for instance, vfold = 4)
vfold = 0;

% Cross validation
rand('seed',0)
r = randperm(size(Y,1)); % random index
Ntrain = round(size(Y,1) * 0.66);

% Training
Xtrain = X(r(1:Ntrain),:);
Ytrain = Y(r(1:Ntrain),:);

% Validation
Xvalid = X(r((Ntrain+1):end),:);
Yvalid = Y(r((Ntrain+1):end),:);

maxim = max(Y);
minim = min(Y);
Y = (Y-minim)/(maxim-minim)*2-1;
Ytrain = (Ytrain-minim)/(maxim-minim)*2-1;
Yvalid = (Yvalid-minim)/(maxim-minim)*2-1;

% Row-wise
X = X';
Y = Y';
Xtrain = Xtrain';
Xvalid = Xvalid';
Ytrain = Ytrain';
Yvalid = Yvalid';

[di,N]      = size(X);
[di,Ntrain] = size(Xtrain);
[di,Nvalid] = size(Xvalid);
c=0;
for h = 1:Ntrain;
    
    % Build and train the net:
    W1  = rand(h,di)*2-1;
    BH  = rand(h,1);
    tempH = W1*Xtrain;
    ind = ones(1,Ntrain);
    B   = BH(:,ind);
    tempH = tempH+B;
    H  = 1./(1 + exp(-tempH));
    for lambda=logspace(-20,0,20);
        c=c+1;
    %     W2 = pinv(H') * Ytrain';
        W2 = (lambda*eye(size(H,1)) + H * H') \ H * Ytrain'; % regularized
        Ypred = (H' * W2)';
        r = assessment(Ytrain,Ypred, 'regress');
        RMSE1 = r.RMSE;
        
        % Validation
        tempH = W1*Xvalid;
        ind   = ones(1,Nvalid);
        B2    = BH(:,ind);
        tempH = tempH+B2;
        Hvalid = 1./(1 + exp(-tempH));
        Ypredvalid = (Hvalid' * W2)';
        r = assessment(Yvalid,Ypredvalid, 'regress');
        RMSE = r.RMSE;
        results(c,:) = [h lambda RMSE1 RMSE];
    end
    
end

% Optimal structure in xval
% figure, semilogy(RMSE1,'b'),hold on, semilogy(RMSE,'r')
[val idx] = min(results(:,4));
h      = results(idx,1);
lambda = results(idx,2);

% Build and train the net:
W1    = rand(h,di)*2-1;
BH    = rand(h,1);
tempH = W1*X;
ind   = ones(1,N);
B     = BH(:,ind);
tempH = tempH+B;
H     = 1./(1 + exp(-tempH));
% W2    = pinv(H') * Y';
W2 = (lambda*eye(size(H,1)) + H * H') \ H * Y'; % regularized
Ypred = (H' * W2)';
Ypred = 0.5*(Ypred + 1)*(maxim-minim) + minim;

% The model
model.hopt = h;
model.W1 = W1;
model.W2 = W2;
model.BH = BH;
model.maxim = maxim;
model.minim = minim;

% r = assessment(Ytest,Ypredtest, 'regress');
% figure,plot(Ytest,Ypredtest,'k.')


