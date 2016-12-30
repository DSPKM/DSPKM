% Paramaters of data generation
conf.data.path='dataIndoorLocation.mat';
conf.NREPETS=1;      % It is used to load different segments
% Parameters defining algorithms
conf.evalfuncs={@MSE};
conf.cv.searchfunc=@cross_validation;
conf.cv.n_folds=10;
conf.cv.evalfunc=@MSE;
conf.machine.params_name={'gamma','epsilon','C','stepA','K'};
conf.machine.algs={@SVM_CC,@kNN};
conf.machine.ind_params={1:4,5};
%params.ggamma=1e-1; params.epsilon=1e-6; params.C=100;
conf.cv.value_range{1} = 0.1;  %logspace(-6,1,10);       % gamma
conf.cv.value_range{2} = 1e-6; %linspace(0.01,0.99,10);  % epsilon
conf.cv.value_range{3} = 1e2;  %logspace(-1,3,5);        % C
conf.cv.value_range{4} = 2;                              % step
conf.cv.value_range{5} = 2;                              % K
conf.displayfunc = @display_results_indoorLocation;
