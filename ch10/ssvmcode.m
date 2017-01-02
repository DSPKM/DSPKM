function ssvmcode

% Code snippet simplifying the function test_svm_struct_learn.m from
% Andrea Vedaldi available in the SVM-Struct toolbox in 
%     http://www.robots.ox.ac.uk/~vedaldi/svmstruct.html#download-and-install
%
% - Assume have a set of input data X with structured outputs Y

% Initialize parameters
parm.patterns = X;                  % cellarray of patterns (inputs).
parm.labels = Y;                    % cellarray of labels (outputs).
parm.lossFn = @lossCB;              % loss function callback.
parm.constraintFn  = @constraintCB; % constraint generation callback.
parm.featureFn = @featureCB;        % feature map callback.
parm.dimension = 2;                 % feature dimension.
% Run SVM struct
model = svm_struct_learn(' -c 1.0 -o 1 -v 1 ', parm);
% Return model weights
w = model.w ;

% Some SVM struct callbacks
function psi = featureCB(param, x, y)
	psi = sparse(y*x/2) ;
end
function delta = lossCB(param, y, ybar)
	delta = double(y ~= ybar) ;
end
function yhat = constraintCB(param, model, x, y)
% slack resaling: argmax_y delta(yi, y) (1 + <psi(x,y), w> - <psi(x,yi), w>)
% margin rescaling: argmax_y delta(yi, y) + <psi(x,y), w>
	if dot(y*x, model.w) > 1, yhat = y ; else yhat = - y ; end
end