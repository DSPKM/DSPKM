clear; clc; close all
rng('default'); rng(0)
addpath(genpath('.')), addpath('../libsvm/')

% Select dataset:
ind_datafunc = 1;
% Availabe data sets (see common/config_file and correspondig subdirs for more info)
%  1: Interpolation. 2: Deconvolution. 3: Ultrasound. 4: HRV. 5: OFDM.
%  6: Spectral. 7: Cardiac Doppler. 8: EAM. 9: MAE. 10: Indoor location.

% Use MATLAB paralellization (parfor)
conf.parallelize = 1;

% That's it, run!
run
