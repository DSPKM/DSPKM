function [predict,coefs] = kNN(Xtrain,Ytrain,Xtest,K)

%Ytrain = [real(Ytrain), imag(Ytrain)];
ndata = size(Xtrain,1);
for j=1:size(Xtest,1)
    s = zeros(ndata,1);
    for i=1:ndata
        s(i) = norm(Xtrain(i,:)-Xtest(j,:),1);
    end
    % Sort distances and find Kmax NN
    [ssort,indsort] = sort(s);
    ssort = ssort(1:K);
    indsort = indsort(1:K);
    sortedYtrain = Ytrain(indsort,:);
    % Weights
    sden = sum(ssort);
    w = ssort/(sden+1e-8);
    winvden = sum(1./(w+1e-8));
    coefs = 1./(w+1e-8)/winvden;
    % Estimated distances
    predict(j,:) = coefs'*sortedYtrain;
end
