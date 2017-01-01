load barbara512
% Single-level decomposition of X of a particular wavelet
wname = 'db1'; % wname = 'sym4';
[CA,CH,CV,CD] = dwt2(X,wname);
decompo = [ CA/max(max(CA)), CH/max(max(CH));
            CV/max(max(CV)), CD/max(max(CD)) ];
figure, imshow(decompo,[])
% Let's remove the horizontal coefficients and invert the representation
CH = zeros(size(CH));
Xr = idwt2(CA,CH,CV,CD,wname);
% Plot the reconstruction error
figure, imshow(abs(X-Xr),[]);