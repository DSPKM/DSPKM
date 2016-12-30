function value = R2(ypred,y)

[~,~,~,~,STATS] = regress(y(:),[ypred(:) ones(size(ypred(:)))]);
value=STATS(1);
