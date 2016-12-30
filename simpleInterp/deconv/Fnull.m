function fnull = Fnull(ypred,y)
fnull = norm(ypred(y == 0));
