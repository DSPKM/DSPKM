% Experiment: kernel adaptive filter algorithm profiler. 
% Compares the cost vs prediction error tradeoffs and convergence speeds
% for several algorithms on the MG30 data set.
clear, clc
currentdir = pwd; cd ../kafbox/; install; cd(currentdir)
%% Parameters
% data and algorithm setup
data.name = 'mg30';
data.n_train = 500; % number of data points
data.n_test = 100; % number of data points
data.embedding = 7; % time embedding
data.offset = 50; % apply offset per simulation
sim_opts.numsim = 5; % 10 seconds per simulation on a 2016 PC
sim_opts.error_measure = 'MSE';
i=0; % initialize setups
% QKLMS
i=i+1;
algorithms{i}.name = 'QKLMS';
algorithms{i}.class = 'qklms';
algorithms{i}.figstyle = struct('color',[1  0  0],'marker','o');
algorithms{i}.options = struct('eta',0.5,'sweep_par','epsu','sweep_val',[1E-4 1E-3 1E-2 .1 .2 .3 .5 .7 1],...
    'kerneltype','gauss','kernelpar',1);
% KRLS-T
i=i+1;
algorithms{i}.name = 'KRLS-T';
algorithms{i}.class = 'krlst';
algorithms{i}.figstyle = struct('color',[0  0  1],'marker','+');
algorithms{i}.options = struct('sn2',1E-6,'lambda',1,'sweep_par','M',...
    'sweep_val',[3 5 7 10 20 30 50 150],...
    'kerneltype','gauss','kernelpar',1);
%% Program
fprintf('Running profiler for %d algorithms on %s data.\n',i,data.name);
output_dir = fullfile(mfilename('fullpath'),'..','results');
t1 = tic;
[data,algorithms,results] = kafbox_profiler(data,sim_opts,algorithms,output_dir);
t2 = toc(t1);
fprintf('Elapsed time: %d seconds\n',ceil(t2));
%% Output
mse_curves = kafbox_profiler_msecurves(results);
kafbox_profiler_plotresults(algorithms,mse_curves,results,{'ssmse','flops'});
kafbox_profiler_plotresults(algorithms,mse_curves,results,{'ssmse','bytes'});
resinds = [1,2;2,8]; % result indices
kafbox_profiler_plotconvergence(algorithms,mse_curves,resinds);
