% Paramaters of data generation
% conf.path_acorr='data/Section_8.7.4/acorr_HRV.mat';
conf.path_acorr='acorr_HRV.mat';
conf.NREPETS=279;      % It is used to load different segments
conf.load_acorr=1;     % 0: calculate a new rxx, 1: load a precomputed one
conf.recordType = 0;   % 0: in order to use RR intervals, 1: NN intervals
conf.Finterp  = 2;     % interpolation average factor
conf.Lfft = 2048;
conf.Tinterp = 500;    %ms % DELTA T is the time vector to interpolate
conf.T = 810;          %ms Delta T approximated average, used for the first spectral estimation in autocorr kernel
conf.resolution = 5;   %ms
conf.fs = 1/(conf.Tinterp/1000);
conf.f = linspace(-conf.fs/2,conf.fs/2,conf.Lfft);
%conf.filterBy_p_vlf = 1;
conf.correct_vlf = 0;  % 0: do not correct the power excess in very low freqs (vlf, f<0.04Hz).
                       % 1: the ls is corrected (fft(rxx)) to remove content of vlf freqs
                       % 2: the vlf is corrected with a ramp
                       % 3: the vlf is corrected with a parabola

% Parameters defining algorithms
conf.evalfuncs={@MSE};
conf.cv.searchfunc=@gridSearch;
conf.cv.evalfunc = @MSE;
conf.machine.params_name={'T0','gamma_RBF','epsilon_RBF','C_RBF',...
    'gamma_Corr','epsilon_Corr','C_corr','path_acorr'};
conf.machine.algs={@SVM_RBF, @SVM_Corr};
conf.machine.ind_params={1:4, 5:8};

conf.cv.value_range{1} = 600;               % T0      (of SVM_RBF)
conf.cv.value_range{2} = 1e-3;              % gamma   (of SVM_RBF)
conf.cv.value_range{3} = 1e-3;              % epsilon (of SVM_RBF)
conf.cv.value_range{4} = 100;               % C       (of SVM_RBF)
conf.cv.value_range{5} = 0.1;               % gamma   (of SVM_Corr)
conf.cv.value_range{6} = 0.1;               % epsilon (of SVM_Corr)
conf.cv.value_range{7} = 50;                % C       (of SVM_Corr)
conf.cv.value_range{8} = conf.path_acorr;   % acorr   (of SVM_Corr)

conf.displayfunc = @display_results_HRV;
