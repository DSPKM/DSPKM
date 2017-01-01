% SBL_EXAMPLE_R	Simple demonstration of sparse Bayes regression with an RVM
%
% (c) Microsoft Corporation. All rights reserved. 
%

function sbl_example_r(N,noise,kernel_,width,maxIts)

% Possible info levels 0 ... 3
% '3' gives most verbose output
% 
setEnvironment('InfoLevel',3);

if nargin==0
  % Some acceptable default values if none supplied
  % 
  randn('state',1)
  N		= 100;
  noise		= 0.1;
  kernel_	= '+gauss';
  width		= 3;
  maxIts	= 1000;
end
monIts		= round(maxIts/10);

% Generate the sinc data
% 
X	= 10*[-1:2/(N-1):1]';
y	= sin(abs(X))./abs(X);
t	= y + noise*randn(N,1);
% Plot the data and function
% 
figure(1)
whitebg(1,'k')
clf
h_y = plot(X,y,'r--','LineWidth',3);
hold on
plot(X,t,'w.','MarkerSize',16)
box = [-10.1 10.1 1.1*[min(t) max(t)]];
axis(box)
drawnow

%
% Set up initial hyperparameters -
% should be relatively insensitive to exact values
% 
initAlpha	= (1/N)^2;
epsilon		= std(t) * 1/100;
initBeta	= 1/epsilon^2;
%
% Train a relevance vector machine
% 
[weights, used, ml, alpha, beta] = ...
    sbl_rvm(X,t,initAlpha,initBeta,kernel_,width,maxIts,monIts);
%
% Visualise the results
% 
if kernel_(1)=='+'	
  % Take account of bias if originally used ...
  used	= used - 1;
  if used(1)~=0
    % ... and if pruned ...
    kernel_(1)	= [];
  else
    used(1)	= [];
  end
end
% Evaluate the model over the training data
PHI	= sbl_kernelFunction(X,X(used,:),kernel_,width);
y_rvm	= PHI*weights;
%
% Plot the results
% 
h_yrvm = plot(X,y_rvm,'w-','LineWidth',3);
h_rv	= plot(X(used),t(used),'wo','LineWidth',2,'MarkerSize',10);
legend([h_y h_yrvm h_rv],'sinc function','RVM predictor','RVs')
hold off
title('RVM Regression with noisy ''sinc'' data','FontSize',14)
%
% Output some info
% 
fprintf('\nRVM regression test error (RMS): %g\n', ...
	sqrt(mean((y-y_rvm).^2)))
fprintf('\testimated noise level: %.4f (true: %.4f)\n', ...
	sqrt(1/beta), noise)
