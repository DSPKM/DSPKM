function param_selec = cross_validation(X,Y,conf,~,~)

% Implements cross validation
%
% Inputs:
%   - X, Y: input/output data (N samples x n variables)
%   - conf: structure with defined configuration
%     - conf.machine.function_name
%     - conf.machine.params
%
% Outputs:
%   - param_selec: selected parameters

if nargin<3 || isempty(conf); disp('"conf" parameter is madatory'); return; end
if ~isfield(conf,'machine') || ~isfield(conf.machine,'function_name'); conf.machine.function_name = @Yen1; end
if ~isfield(conf.cv,'evalfunct'); conf.cv.evalfunc = @MSE; end

n_folds = min(conf.cv.n_folds,size(X,1));
value_range = conf.machine.value_range;
pos_str = zeros(1,length(value_range));
for i = 1:length(value_range); pos_str(i) = ischar(value_range{i}); end
str_args = value_range(pos_str);
value_range(pos_str) = {0};

% Do grid search when more than one parameter
ind_combs = combvec(value_range{:});
[nparams,ncombs] = size(ind_combs);
param_selec = cell(nparams,1);
if sum(pos_str) > 0; value_range(pos_str) = str_args; end
% Check if only one parameter passed
if ncombs == 1; param_selec = value_range; return; end

ncases = size(X,1);
nsamples = floor(ncases/n_folds);
randomCases = randperm(ncases);
err = zeros(1,ncombs);

if conf.parallelize; parforArg = inf; else parforArg = 0; end
fprintf('Finding best free parameters in a %dD grid search using %d-fold CV...\n(There are %d combinations)\n',nparams,n_folds,ncombs)
for N = 1:n_folds % N is the index of the selected partition
    
    indValid = randomCases(1+(N-1)*nsamples:min(N*nsamples,ncases));
    indTrain = setdiff(1:ncases,indValid);
    
    XTrain = X(indTrain,:);
    YTrain = Y(indTrain,:);
    XValid = X(indValid,:);
    YValid = Y(indValid,:);
    
    if isfield(conf,'center') && conf.center ==  1
        [XTrain,XValid] = centrar_datos(XTrain',XValid',[],[],conf.normalize);
        XTrain = XTrain'; XValid = XValid';
    end
    
    % Loop over parameters
    parfor (ic = 1:ncombs, parforArg)
        if mod(ic,1000) == 0; fprintf('Combination %d of %d in folder %d/%d\n',ic,ncombs,N,n_folds); end
        params = cell(nparams,1);
        for ip = 1:nparams
            params{ip} = ind_combs(ip,ic);
        end
        if sum(pos_str)>0; params(pos_str) = str_args; end
        % Train and obtain prediction
        prediction = conf.machine.function_name(XTrain,YTrain,XValid,params{:});
        % Validation error
        err(ic) = err(ic) + conf.cv.evalfunc(prediction,YValid)/n_folds;
    end
end
[~,indMin] = min(err);

for ip = 1:nparams
    param_selec{ip} = ind_combs(ip,indMin);
end
if sum(pos_str)>0; param_selec(pos_str) = str_args; end