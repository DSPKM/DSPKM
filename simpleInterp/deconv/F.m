function f = F(ypred,y)
indx = find(y ~= 0);
f = norm(ypred(indx) - y(indx));