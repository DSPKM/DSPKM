conf.NREPETS = 1;
conf.parallelize = 1;

% conf.data.path='data/EAM/data_58_BIP.mat';
conf.data.path='data/EAM/'; % if folder, load all .mat
conf.data.colorpath='data/EAM/colormaps/ColCarto.mat';

% Parameters defining algorithms and theirs free parameters
conf.machine.algs={@LI,@TPS,@SVR};
conf.machine.params_name={'idle','lambda','sigma','nu','C'};
conf.machine.ind_params={1,2,3:5};

% Parameters defining evaluation criterion
conf.evalfuncs={@MSE};

% Parameters defining free parameters searching
conf.cv.searchfunc=@gridSearch;
% conf.cv.searchfunc=@cross_validation;
% conf.cv.n_folds=10; %inf % if n_folds=inf; leave-one-out cross validation
conf.cv.evalfunc = @MSE;
conf.cv.value_range{1} = 0.0; % idle (linear_interpolation has not param.)
conf.cv.value_range{2} = [0 1 10 50 100 500 1000]; % lambda
conf.cv.value_range{3} = linspace(10,20,50); %logspace(0,3,50);  % sigma
conf.cv.value_range{4} = 0.5;%0.05:0.15:0.95;   % nu
conf.cv.value_range{5} = 10;%[1 10 100 500 1000]; %linspace(0,8,10);   % C

% Parameters defining visualization function
conf.displayfunc = @display_results_EAM;

% Parameters for saving results
conf.save.results = 1; % 1: save results
conf.save.path = 'results'; % path where save results (only folder path)
