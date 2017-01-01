% SBL_EXAMPLE_C	Simple demonstration of sparse Bayes classification with an RVM
%
% (c) Microsoft Corporation. All rights reserved. 
%

function sbl_example_c(N,kernel_,width,maxIts)

% Set info level to 2 to avoid churning out posterior mode data
% 
setEnvironment('InfoLevel',2);

if nargin==0
  % Some acceptable default values
  % 
  rand('state',1)
  N		= 100;
  kernel_	= '+gauss';
  width		= 0.5;
  maxIts	= 500;
end
monIts		= round(maxIts/10);
N		= min([250 N]);
Nt		= 1000;

% Load Ripley's synthetic training data (see reference in manual)
% 
load synth.tr
synth	= synth(randperm(size(synth,1)),:);
X	= synth(1:N,1:2);
t	= synth(1:N,3);
% Plot it
figure(1)
whitebg(1,'k')
clf
h_c1 = plot(X(t==0,1),X(t==0,2),'r.','MarkerSize',16);
hold on
h_c2 = plot(X(t==1,1),X(t==1,2),'y.','MarkerSize',16);
box = 1.1*[min(X(:,1)) max(X(:,1)) min(X(:,2)) max(X(:,2))];
axis(box)
drawnow

%
% Set up initial hyperparameters -
% should be relatively insensitive to exact values
% 
initAlpha	= (1/N)^2;
initBeta	= 0;	% setting to zero for classification
%
% Train the RVM
% 
[weights, used] = sbl_rvm(X,t,initAlpha,initBeta,kernel_,width,...
			  maxIts,monIts);
%
% Compute test error
% 
load synth.te
synth	= synth(randperm(size(synth,1)),:);
Xtest	= synth(1:Nt,1:2);
ttest	= synth(1:Nt,3);
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
% Compute RVM over test data and calculate error
% 
PHI	= sbl_kernelFunction(Xtest,X(used,:),kernel_,width);
y_rvm	= PHI*weights;
errs	= sum(y_rvm(ttest==0)>0) + sum(y_rvm(ttest==1)<=0);
fprintf('\nRVM CLASSIFICATION test error: %.2f%%\n', errs/Nt*100)

%
% Visualise the results
% 
gsteps		= 50;
range1		= box(1):(box(2)-box(1))/(gsteps-1):box(2);
range2		= box(3):(box(4)-box(3))/(gsteps-1):box(4);
[grid1 grid2]	= meshgrid(range1,range2);
Xgrid		= [grid1(:) grid2(:)];
% Compute RVM over a grid for visualisation purposes
% 
PHI		= sbl_kernelFunction(Xgrid,X(used,:),kernel_,width);
y_grid		= 1./(1+exp(-PHI*weights)); % apply sigmoid for probabilities

% Show decision boundary (p=0.5) and illustrate p=0.25 and 0.75
% 
[c,h05]	= contour(range1,range2,reshape(y_grid,size(grid1)),[0.5 0.5],'-');
[c,h075]	= ...
    contour(range1,range2,reshape(y_grid,size(grid1)),[0.25 0.75],'--');
set(h05,'Color','w','LineWidth',3);
set(h075,'Color',0.7*[1 1 1],'LineWidth',2);

h_rv	= plot(X(used,1),X(used,2),'wo','LineWidth',2,'MarkerSize',10);
legend([h_c1 h_c2 h05 h075(1) h_rv],...
       'Class 1','Class 2','Decision boundary','p=0.25/0.75','RVs')
hold off
title('RVM Classification of Ripley''s synthetic data','FontSize',14)
