% SBL_RVM	Relevance Vector Machine specialisation of sparse Bayes model
%	
% [W,USED,ML,A,B,G]	= SBL_ESTIMATE(X,T,A,B,KERNEL,LSCAL,MAXITS,MONITS)
% 
%	W		trained weights (subset of full model)
%	USED		index into column of PHI of relevant basis
%	ML		marginal likelihood of final model
%	A		estimated 'alpha' values
%	B		estimated 'beta' for regression
%	G		estimated 'gamma' (well-determinedness) parameters
% 
%	X		input variable matrix
%	T		target vector
%	A		initial alpha value (scalar)
%	B		initial beta value (negative to fix in regression,
%			zero for classification)
%	KERNEL		Kernel type: currently one of
%			'gauss'		Gaussian
%			'laplace'	Laplacian
%			'poly'		Polynomial
%			'hpoly'		Homogeneous Polynomial
%			'spline'	Linear spline [Vapnik et al]
%			'cauchy'	Cauchy (heavy tailed) in distance
%			'cubic'		Cube of distance
%			'r'		Distance
%			'tps'		'Thin-plate' spline
%			'bubble'	Neighbourhood indicator
% 
%			Prefix with '+' to add bias (e.g. '+gauss')
%	LSCAL		Input length scale
%	MAXITS		maximum number of iterations to run for
%	MONITS		monitor training info every MONITS iterations
%			[optional] 
%
% (c) Microsoft Corporation. All rights reserved. 
%

function [weights, used, marginal, alpha, beta, gamma] = ...
    sbl_rvm(X,t,alpha,beta,kernel_,lengthScale,maxIts,monIts)

getEnvironment;

[N d]	= size(X);
if strcmp(kernel_,'linear')
  PHI	= X;
elseif strcmp(kernel_,'+linear')
  PHI	= [ones(N,1) X];
else
  if ENV.InfoLevel>=3
    fprintf(ENV.logID,'*\nEvaluating kernel ...\n');
  end
  PHI	= sbl_kernelFunction(X,X,kernel_,lengthScale);
end

if ENV.InfoLevel>=2
  fprintf(ENV.logID,'*\nCreated RVM ...\nkernel:\t''%s''\nscale:\t%f\n',...
	  kernel_, lengthScale);
  fprintf(ENV.logID,'PHI:\t%d x %d\n', size(PHI));
end
if ENV.InfoLevel>=1
  fprintf(ENV.logID,'*\nCalling hyperparameter estimation routine ...\n');
end

[weights, used, marginal, alpha, beta, gamma]	= ...
    sbl_estimate(PHI,t,alpha,beta,maxIts,monIts);

