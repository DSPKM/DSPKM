% function K = kernelmatrix(ker,X,X2,sigma)
%
% Inputs:
%	ker:    'lin','poly','rbf','sam'
%	X:	    data matrix with training samples in columns and features in rows
%	X2:	    data matrix with test samples in columns and features in rows
%	sigma:  width of the RBF kernel
% 	b:      bias in the linear and polinomial kernel
%	d:      degree in the polynomial kernel
%
% Output:
%	K: kernel matrix
%
% With Fast Computation of the RBF kernel matrix
% To speed up the computation, we exploit a decomposition of the Euclidean distance (norm)
%
% Gustavo Camps-Valls, 2006
% Jordi (jordi@uv.es),
%   2007-11: if/then -> switch, and fixed RBF kernel
%   2010-04: RBF can be computed now also on vectors with only one feature (ie: scalars)

function K = kernelmatrix(ker,X,X2,d,b)

switch ker
    case 'lin'
        if exist('X2','var')
            K = X' * X2;
        else
            K = X' * X;
        end
        
    case 'poly'
        if ~exist('b','var')
            b = 1;
        end
        if exist('X2','var')
            K = (X' * X2 + b).^d;
        else
            K = (X' * X + b).^d;
        end
        
    case {'rbf','RBF'}
        if size(X,1) == 1
            n1sq = X.^2;
        else
            n1sq = sum(X.^2);
        end
        n1 = size(X,2);
        
        if exist('X2','var');
            if size(X2,1) == 1
                n2sq = X2.^2;
            else
                n2sq = sum(X2.^2);
            end
            n2 = size(X2,2);
            D = (ones(n2,1)*n1sq)' + ones(n1,1)*n2sq -2*X'*X2;
        else
            D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*X'*X;
        end
        K = exp(-D/(2*d^2));
        
    case 'sam'
        if exist('X2','var');
            D = X'*X2;
        else
            D = X'*X;
        end
        K = exp(-acos(D).^2/(2*d^2));
        
    otherwise
        error(['Unsupported kernel ' ker])
end
