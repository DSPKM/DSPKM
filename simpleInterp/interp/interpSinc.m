function [y,Ak] = interpSinc(tk,yk,t,T0,B)
Ak = B * yk;      % Coefficients
y=zeros(size(t)); % Reconstruction
for i=1:length(Ak)
    y = y + Ak(i)*(sinc((t-tk(i))/T0)/T0);
end