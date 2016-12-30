% Parameters defining data generation and simulation
conf.NREPETS = 5;            % Number of 'pasadas'(times runned the program)
conf.data.BW = 2*10^6;       % Band-Width [Hz]
conf.data.N = 64;            % Number of subcarriers
conf.data.Npil = 16;         % Number of pilot subcarriers (Npil<=N)
conf.data.Lp = 2;            % Length of preamble [Nr. of OFDM-symbols]
conf.data.M = 2;             % Number of bits per symbol (M-PSK): [M=1,2,3]
conf.data.Nsymb_frm = 20;    % Number of OFDM-symbols of data per frame
conf.data.maxdel=1e-6; % Maximal delay spread [sec]:defined by (SUI-3/Omni)
conf.data.fs=conf.data.BW;   % Sampling frequency (equals BW)
conf.data.Ts=1/conf.data.fs; % Sampling period
conf.data.PC=ceil(conf.data.maxdel*conf.data.fs); % Number of samples of Cyclic Prefix, avoids ISI
conf.data.L=conf.data.N+conf.data.PC;
conf.data.Nb_frm=(conf.data.N*conf.data.M)*conf.data.Nsymb_frm;  % Number of information bits per frame
conf.data.inicSync=1;         % Synchronism (1: perfect synchronism)
conf.data.SNR=25;             % Signal to Noise Ratio [dB]
conf.data.p=.05;              % Probability of Bernoulli trials
conf.data.sirFlag = 1;        % 1 for look in SIR

conf.varname_loop1 = 'SIR';   % Signal to Interference Ratio [dB]
conf.vector_loop1 = -21:3:21; % First loop used to eval SIR

% Parameters defining algorithms
conf.machine.params_name={'N','M','epsilon','gamma','C'};
conf.machine.algs={@LS_OFDM, @SVM_OFDM};
conf.machine.ind_params={1:2, 1:5};
conf.cv.value_range{1} = conf.data.N;
conf.cv.value_range{2} = conf.data.M;
conf.cv.value_range{3} = linspace(0,.1,3);      % epsilon
conf.cv.value_range{4} = logspace(-6,-1.25,3);  % gamma  
conf.cv.value_range{5} = [0.1, 1, 10];          % C      

conf.cv.searchfunc=@gridSearch;
conf.cv.evalfunc = @BER;
conf.evalfuncs = {@BER_and_MSE};

conf.displayfunc = @display_results_OFDM;
