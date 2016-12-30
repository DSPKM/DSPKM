
conf.data.path='data/MAE/Milk.mat'; conf.NREPETS = 6;
% conf.data.path='data/MAE/Beer.mat'; conf.NREPETS = 14;

% Parameters defining algorithms and theirs free parameters
conf.machine.algs={@SVR_linear,@SVR_RBF};
conf.machine.params_name={'sigma','nu','C'};
conf.machine.ind_params={2:3,1:3};

% Parameters defining evaluation criterion
conf.evalfuncs={@MSE};

% Parameters defining free parameters searching
% conf.cv.searchfunc=@gridSearch;
conf.cv.searchfunc=@cross_validation;
conf.cv.n_folds=inf; % if n_folds=inf; leave-one-out cross validation
conf.cv.evalfunc = @MSE;
conf.cv.value_range{1} = linspace(0.01,20,20);     % sigma
conf.cv.value_range{2} = linspace(0.01,0.99,10);   % nu
conf.cv.value_range{3} = logspace(-1,3,5);         % C

% Parameters defining visualization function
conf.displayfunc = @display_results_MAE;
