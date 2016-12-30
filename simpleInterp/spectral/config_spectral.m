% Parameters defining experiment setting
conf.NREPETS = 1; % Number of executions

% Parameters defining the data generation (in @genDataInterp)
conf.data.n         = 128; % number of samples
conf.data.f         = 0.3; % frequency (Hz)
conf.data.var_noise = 0.1; % variance of Gaussian noise
conf.data.p         = 0.3; % prob. of impulsive noise
conf.data.A         = 10;  % Amplitude of impulsive noise

% Parameters defining algorithms and theirs free parameters
conf.machine.algs={@SVM_NSA};
conf.machine.params_name={'gamma','epsilon','C'};
conf.machine.ind_params={1:3};

% Parameters defining evaluation criterion
conf.evalfuncs={@MSE};

% Parameters defining free parameters searching
conf.cv.searchfunc=@gridSearch;
conf.cv.evalfunc = @MSE;
conf.cv.value_range{1} = 10;   % gamma
conf.cv.value_range{2} = 0;    % epsilon
conf.cv.value_range{3} = 0.01; % C

% Parameters defining visualization function
conf.displayfunc = @display_results_spectral;

% Vector with different values of SNR (Signal Noise Rate)
conf.varname_loop1 = 'cv.value_range{3}';
conf.vector_loop1 = [1.0 0.1 0.01];
