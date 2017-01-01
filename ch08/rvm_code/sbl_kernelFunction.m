% SBL_KERNELFUNCTION	Compute kernel functions for the RVM model
%
%	K = SBL_KERNELFUNCTION(X1,X2,KERNEL,LSCAL)
%	
%		K	N1 x N2 (or N2+1 if bias ) design matrix.
%			The first column comprises 1's if a bias is used
%
%		X1	N1 x d data matrix
%		X2	N2 x d data matrix
%		KERNEL	Kernel type: currently one of
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
%		LSCAL	Input length scale
%
%
% (c) Microsoft Corporation. All rights reserved. 
%

function K = sbl_kernelFunction(X1,X2,kernel_,lenscal)

[N1 d]		= size(X1);
[N2 d]		= size(X2);

if kernel_(1)=='+'
  b		= ones(N1,1);
  kernel_	= kernel_(2:end);
else
  b		= [];
end

if length(kernel_)>=4 & strcmp(kernel_(1:4),'poly')
  p		= str2num(kernel_(5:end));
  kernel_	= 'poly';
end
if length(kernel_)>=5 & strcmp(kernel_(1:5),'hpoly')
  p		= str2num(kernel_(6:end));
  kernel_	= 'hpoly';
end
eta	= 1/lenscal^2;

switch lower(kernel_)
  
 case 'gauss',
  K	= exp(-eta*distSqrd(X1,X2));
  
 case 'tps',
  r2	= eta*distSqrd(X1,X2);
  K	= 0.5 * r2.*log(r2+(r2==0));
  
 case 'cauchy',
  r2	= eta*distSqrd(X1,X2);
  K	= 1./(1+r2);
  
 case 'cubic',
  r2	= eta*distSqrd(X1,X2);
  K	= r2.*sqrt(r2);
  
 case 'r',
  K	= sqrt(eta)*sqrt(distSqrd(X1,X2));
  
 case 'bubble',
  K	= eta*distSqrd(X1,X2);
  K	= K<1;
  
 case 'laplace',
  K	= exp(-sqrt(eta*distSqrd(X1,X2)));
  
 case 'poly',
  K	= (X1*(eta*X2)' + 1).^p;

 case 'hpoly',
  K	= (eta*X1*X2').^p;

 case 'spline',
  K	= 1;
  X1	= X1/lenscal;
  X2	= X2/lenscal;
  for i=1:d
    XX		= X1(:,i)*X2(:,i)';
    Xx1		= X1(:,i)*ones(1,N2);
    Xx2		= ones(N1,1)*X2(:,i)';
    minXX	= min(Xx1,Xx2);
    
    K	= K .* [1 + XX + XX.*minXX-(Xx1+Xx2)/2.*(minXX.^2) + (minXX.^3)/3];
  end
  
 otherwise,
  error(sprintf('Unrecognised kernel function type: %s', kernel_))
end
  
K	= [b K];

function D2=distSqrd(X,Y)

if 0		% wavelengths (412, 443, 490, 510 and 555 nm).
%	weight = [1 1 1 1 1];
	weight = [0 1 0 0 1];
	[Nfil,kk] = size(X);
	etai = repmat(weight,Nfil,1);
	X = X.*etai;
	[Nfil,kk] = size(Y);
	etai = repmat(weight,Nfil,1);
	Y = Y.*etai;
end;
 
nx	= size(X,1);
ny	= size(Y,1);
D2	= sum(X.^2,2)*ones(1,ny) + ones(nx,1)*sum(Y.^2,2)' - 2*(X*Y');
