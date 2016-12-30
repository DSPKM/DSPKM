function [B,C,A,Phi,y_test] = sinusoidals(y_train,t_train,t_test,w)
% Data
n = length(t_train); m = length(w);
M = zeros(m,n);   % Data matrix
N = zeros(m,n);
for i = 1:m;
    M(i,:) = cos(w(i)*t_train');
    N(i,:) = -sin(w(i)*t_train');
end
MN = [M',N'];
gam = 1e-5;
D = inv(MN'*MN + gam*eye(2*m)) * (MN'*y_train);
% Solution in polar coordinates
B = D(1:m);
C = D(m+1:end);
% Solution in cartesian coordinates
A = sqrt(B.^2+C.^2);
Phi = atan(C./B);
% Test estimation
y_test = zeros(size(t_test));
for i = 1:m
    y_test = y_test + A(i)*cos(w(i)*t_test+Phi(i));
end