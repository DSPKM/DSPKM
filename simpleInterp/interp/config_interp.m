% Parameters defining experiment setting
conf.NREPETS = 1; % Number of executions
% Parameters defining data generation (in @genDataInterp)
fnames = {'doblesinc2','MSSF','DMGF','50sincs','gauss','sinc2'};
ind_fname = 1; % <--- SELECT HERE THE INTERPOLATION PROBLEM TO GENERATE
conf.data.FNAME = fnames{ind_fname}; % Name of the signal generation problem
conf.data.T = 1/2;        % Sample period
conf.data.L = 16*2;       % Number of samples
conf.data.T0 = 1;         % Initial sinc width
conf.data.DESP = 1;       % Center of the sincs offset
conf.data.sigma = 0.5;    % Sigma of the example signal envelope
conf.data.mu = 0;         % Mean of the example Gaussian signal envelope
conf.data.f = 0.4;        % Sample frequency of the example signal
conf.data.k = 0.5;
% Parameters defining algorithms and theirs free parameters
conf.machine.algs={@Y1, @Y2, @S1, @S2, @S3};
conf.machine.params_name={'T0','gamma'};
conf.machine.ind_params={1, 1:2, 1, 1, 1};
% Parameters defining evaluation criterion
conf.evalfuncs={@MSE, @SE};
% Parameters defining free parameters searching
conf.cv.searchfunc = @gridSearch;%@cross_validation;
conf.cv.n_folds = inf;
conf.cv.evalfunc = @MSE;
conf.cv.value_range{1} = linspace(conf.data.T/2, 2*conf.data.T, 10); % T0
conf.cv.value_range{2} = logspace(-9,1,10); % gamma
% Parameters defining visualization function
conf.displayfunc = @display_results_interp;
% Vector with different randomization values for nonuniform generation
conf.varname_loop1 = 'u';
conf.vector_loop1 = [0 0.1]; % if u=0: uniform generation
% Vector with different values of SNR (Signal Noise Rate)
conf.varname_loop2 = 'SNR';
conf.vector_loop2 = 10; %[1000 40 30 20 10];