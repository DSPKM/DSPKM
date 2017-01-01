function Ypredtest = testELM(model,Xtest)

[Ntest,d] = size(Xtest);

Xtest = Xtest';

% The model
h  = model.hopt;
W1 = model.W1;
W2 = model.W2;
BH = model.BH;
maxim = model.maxim;
minim = model.minim;

% Test the net
tempH = W1*Xtest;
ind   = ones(1,Ntest);
B2    = BH(:,ind);
tempH = tempH+B2;
Htest = 1./(1 + exp(-tempH));
Ypredtest = (Htest' * W2)';
Ypredtest = 0.5*(Ypredtest + 1)*(maxim-minim) + minim;
Ypredtest = Ypredtest';
