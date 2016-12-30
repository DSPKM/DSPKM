function [predict,coefs] = SVM_NSA(~,Ytrain,~,gamma,epsilon,C)

% Initialization
ts=1; fs=1;
N = length(Ytrain);
t = ts*(0:N-1);	% ts is the sampling period
w0 = 2*pi*fs/N; % fs is the sampling frequency, w0 is the angular frequency resolution

% Construct kernel matrix
KC = cos((1:N)'*w0*t);
KS = sin((1:N)'*w0*t);
H = KC'*KC + KS'*KS;

% Train SVM and predict
inparams=sprintf('-s 3 -t 4 -g %f -c %f -p %f -j 1', gamma, C, epsilon);
[predict,model]=SVM(H,Ytrain,H,inparams);
coefs=getSVs(Ytrain,model);
