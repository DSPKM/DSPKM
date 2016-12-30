function [predict,coefs] = deconv_AKSM(z,h,u,gamma,epsilon,C)

% Initials
ht    = h(end:-1:1);    % Anticausal
z1    = filter(ht,1,z); % Anticausal filtering
y     = [z1(length(h):end)' zeros(1,length(h)-1)]';
N     = length(y);
hauto = xcorr(h);       % Autocorr. del filtro
L     = (length(hauto)+1)/2;
aux   = hauto(L:end);
Kh    = [aux' zeros(1,N-L)];
% Construct kernel matrix
H     = toeplitz(Kh);
% Deconvolution
inparams = ['-s 3 -t 4 -g ',num2str(gamma),' -c ',num2str(C),' -p ',num2str(epsilon) ' -j 1']; %,' -q'];
[~,model] = SVM(H,y,[],inparams);
predict = getSVs(y,model);
coefs = filter(h,1,predict);
if ~isempty(u); aux=predict; predict=coefs; coefs=aux; end