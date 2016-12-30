function value = SE(ypred,y)
signal = sum(y.^2);
error = sum((ypred - y).^2);
value = signal/error;