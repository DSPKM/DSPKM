% Sketch of the use of LMF in the BCI problem
%   - You need to download and install FilterSVM toolbox from
%       http://remi.flamary.com/soft/soft-filtersvm.html 
%   - Assume that the data is stored in matrix X and Y (training),
%       Xte and Yte (test), and Xval and Yval (validation)
% Initialize parameters
f                            = 10; % filter length f (=tau)
options.f                    = f;
options.decy                 = 0;  % y time shift...
options.F                    = ones(f,d)/(f); % init filter weights
options.stopvarx             = 0;  % threshold for stopping on F changes
options.stopvarj             = 1e-3;
options.usegolden            = 1;
options.goldensearch_deltmax = .01;
options.goldensearch_stepmax = 1;
options.numericalprecision   = 1e-3;
options.multiclass           = 1;
linear = 1;  % let's try with a linear kernel
if linear == 1
    options.kernel = 'linear';
    options.kerneloption = 1;
    options.C = 1e0; % C parameter in the SVM
    options.regnorm2 = 1e0;
    options.regnorm12 = 0e-3;
    options.solver = 3;
    options.use_cg = 1;
else
    options.kernel = 'gaussian';
    options.kerneloption = 10;
    options.C = 1e3; % C parameter in the SVM
    options.regnorm2 = 1e1;
    options.regnorm12 = 0e2;
    options.solver = 3;
    options.use_cg = 1;
end
% No filtering at all
[svm,obj] = svmclass2(X,Y,options);
% Filtering and then classify
[svmf,obj] = svmclass2(mfilter(options,X),Y,options);
% LMF models: learn the optimal filters for classification
[sigsvm,obj] = filtersvmclass(X,Y,options);
% Evaluate in the test set
ysvm = svmval2(Xte,svm); prec_svm = get_precision(Yte,ysvm);
[ypred] = svmval2(mfilter(options,Xte),svmf); prec_filt = get_precision(Yte,ypred);
[ypred,yval] = filtersvmval(Xte,sigsvm); prec_filtsvm = get_precision(Yte,ypred);