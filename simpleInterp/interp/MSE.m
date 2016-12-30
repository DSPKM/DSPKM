function value = MSE(ypred,y)
value = mean((ypred - y).^2);